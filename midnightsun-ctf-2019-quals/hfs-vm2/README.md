# hfs-vm2

**Category**: Pwn

660 Points
14 Solves

---

Binary functionality is explained in hfs-vm writeup.

The vulnerability exists in writing and reading to stack. The stack in the struct is indexed using the value from a register, and each register can store a 16 bit integer. Thus, we have out of bounds read and write on the stack.

Using this vulnerability, we can leak pie and libc from the stack into a register and print it out. Additionally, we can edit the return address of main.

Getting leaks:
```python
code += readstack(6, (0x68/2)) // pie leak
code += readstack(7, (0x68/2)+1)
code += readstack(8, (0x68/2)+2)
code += readstack(9, (0x68/2)+3)
code += addreg(6, 0x3e2)

code += readstack(10, (0xa8/2)) // libc leak
code += readstack(11, (0xa8/2)+1)
code += readstack(12, (0xa8/2)+2)
code += readstack(13, (0xa8/2)+3)
code += subreg(10, 0x830)
code += subreg(11, 0x2)
```

Registers 10-13 store our libc leak and register 6-9 store our pie leak.

One thing to note, however, is that we can only send VM code once to the binary, and at this stage, we cannot edit our VM code, so we essentially do not have leaks. However, since the binary provides us with adding capabilities, we can use the leaks, and adding/subtracting to create a ropchian 2 bytes at a time.

Ropchaining using relative additions:
```python
// gadget at offset libc + 0x22e8
code += addreg(10, 0x2e8)
code += addreg(11, 0x2)
code += putstack2(10, (0xb0/2))
code += putstack2(11, (0xb0/2)+1)
code += putstack2(12, (0xb0/2)+2)
code += putstack2(13, (0xb0/2)+3)
code += subreg(10, 0x2e8)
code += subreg(11, 0x2)
```

Now because we only have roughly 1000 bytes at our disposal and each VM instruction is 8 bytes, we cannot create a super long ropchain. So the idea is to trigger a read(rsp) to overwrite the return address and create an infinitely long ropchain. This is easily done using pop rdi, rsi, and rdx gadgets in the binary. However I hadtrouble getting the gets() or read() functions to work for some reason, but the read function used in the binary itself worked.

With an infinitely long ropchain at our disposal, we can now exploit more easily. However, the child has seccomp enabled:

```
prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT)
```

SECCOMP_MODE_STRICT only allows four syscalls: exit(), sigreturn(), read(), and write(). So, basically we cannot get a shell on the child process, so we have to attack the parent process.

Remember that the parent process copies data from the shared memory based on the first 2 bytes as size in the shared memory. Well, if we can control these first two bytes to be something very big, then we will have a stack overflow on the parent. HOWEVER, the binary changes the stack cookie in the parent process:

```C
v6 = fopen("/dev/urandom", "rb");
    v7 = v6;
    if ( v6 )
    {
      fread(&cookie, 8uLL, 1uLL, v6);
      fclose(v7);
      store_cookie(cookie);
      v8 = start_kernel(fds[1]);
      exit(v8);
    }

//--------------

store_cookie    proc near
                push    rdx
                mov     rdx, rdi
                mov     fs:28h, rdx
                pop     rdx
                retn
store_cookie    endp
```

So we don't know the cookie in the parent process, so we can't overflow the parent process without triggering stack_chk_fail.

The solution to this is a race condition bug in the parent process. The parent process first reads data from the shared memory based on its length onto its stack, performs syscalls, then writes data from its stack into the shared memory. If we have a small length in the beginning, the stack won't be smashed, then if the child process changes the length before the parent process finishes its syscall, then the parent process copies its entire stack, including the stack cookie, over to us! Luckily there is a syscall in the parent that essentially does a sleep(4), allowing us to exploit the race condition easily.

Notice that we have to implement all of this through a ropchain, not shellcode. A pointer to the shared memory is stored in the binary, which we can read using an arbitrary read gadget. The following gadgets are the ones I ended up using for the final exploit:

```
poprdi = libc + 0x0000000000021102 # pop rdi ; ret
poprsi = libc + 0x00000000000202e8 # pop rsi ; ret
poprdx = libc + 0x0000000000001b92 # pop rdx ; ret
poprcx = libc + 0x00000000000ea69a # pop rcx ; pop rbx ; ret
subrdi = libc + 0x00000000000aaf8b # sub rdi, 0x10 ; add rax, rdi ; ret
arbread = libc + 0x00000000000c8850 # mov rax, qword ptr [rdi + 0x20] ; ret
arbwrite = libc + 0x000000000003655a # mov qword ptr [rdi], rax ; xor eax, eax ; ret
movrdirax = libc + 0x0000000000086b37 # mov rdi, rax ; pop rbx ; pop rbp ; pop r12 ; jmp rcx
ret = libc + 0x0000000000000937 # ret
poprax = libc + 0x0000000000033544 # pop rax ; ret
writetofd = pie + 0x12d0
readfromfd = pie + 0x1250
bss = pie + 0x203130
addrax = libc + 0x000000000008d45a # add rax, rdi ; ret
```

If we implement it correctly, we now have the parent process's stack in the shared memory. We can now continue the ropchain to edit the return address of the parent's stack to a ropchain that calls system("/bin/sh"). Then we simply send a syscall to the parent again, and the parent copies its own smashed stack to its current stack from the shared memory, replacing its return address.

This step, however, took me 2 hours because the parent uses memcpy to copy bytes from the shared memory to its stack. For whatever reason, the sizes I tried, 0x200 and 0x98, caused memcpy to completely trash the shared memory, but memcpy works properly when I used the size 0x90. I had been stuck on this step for 2 hrs and there was 10 minutes left in the competition, and when I randomly tried changing the size to 0x90, it worked! Pwned! This is my favorite challenge in the competition :)

## Flag
midnight{7h3re5_n0_I_iN_VM_bu7_iF_th3r3_w@s_1t_w0uld_b3_VIM}
