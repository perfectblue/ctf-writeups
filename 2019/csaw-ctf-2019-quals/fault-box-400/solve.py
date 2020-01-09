from pwn import *
import time
from Crypto.Util.number import long_to_bytes, bytes_to_long
import gmpy2
from fractions import gcd

def s2n(s):
    return bytes_to_long(bytearray(s, 'latin-1'))


def n2s(n):
    return long_to_bytes(n).decode('latin-1')

proc = remote('crypto.chal.csaw.io', 1001)
#proc = remote('localhost', 23333)

LIMIT = 10
e = 0x10001

generate_y = []
for y in range(LIMIT):
    print(y)
    fake_flag = 'fake_flag{%s}' % (('%X' % y).rjust(32, '0'))
    m = s2n(fake_flag)
    pre = pow(m, e)
    generate_y.append(pre)


while True:
    print("NEW TRY\n\n\n")

    proc.recvuntil("encrypt\n====================================\n")
    proc.sendline("1")
    flag = int(proc.recvline().strip(), 16)
    print('Flag: ', flag)

    proc.recvuntil("encrypt\n====================================\n")
    proc.sendline("4")
    proc.recvuntil("data:")
    proc.sendline(n2s(2))
    enc_2 = int(proc.recvline().strip(), 16)

    proc.recvuntil("encrypt\n====================================\n")
    proc.sendline("4")
    proc.recvuntil("data:")
    proc.sendline(n2s(3))
    enc_3 = int(proc.recvline().strip(), 16)

    n = gcd(pow(2, e) - enc_2, pow(3, e) - enc_3)
    print('N:', n)

    for i in range(2, 1000):
        if n % i == 0:
            n /= i

    assert pow(2, e, n) == enc_2
    assert pow(3, e, n) == enc_3

    proc.recvuntil("encrypt\n====================================\n")
    proc.sendline("3")
    fault = int(proc.recvline().strip(), 16)

    for y in range(LIMIT):
        print(y)
        pre = generate_y[y]
        p = gcd(pre - fault, n)
        if p != 1 and n % p == 0:
            print("SICESICESICE")
            print(p)
            q = n/p
            d = gmpy2.invert(e, (p - 1) * (q - 1))
            flag_m = pow(flag, d, n)
            print(repr(n2s(flag_m)))

# flag{ooo000_f4ul7y_4nd_pr3d1c74bl3_000ooo}
