from pwn import *
from Crypto.Util.number import *
from gmpy2 import *

r = remote('BBB.seccon.games', 8080)

r.recvuntil(b'a=')
a = int(r.recvline().decode().strip())
r.recvuntil(b'p=')
p = int(r.recvline().decode().strip())

F = Zmod(p)
P.<x> = PolynomialRing(F)
b = int((-11*a - 110) % p)

f = x^2+a*x+b
r.sendlineafter(b'!!:', str(b).encode())

sols = set()
def get_sol(target, depth):
    if depth == 0:
        global sols
        if target not in sols:
            sols.add(target)
        return
    
    roots = (f - target).roots()
    for root, _ in roots:
        get_sol(root, depth - 1)

get_sol(11, 4)

assert len(sols) >= 5

for v in list(sols)[:5]:
    r.sendlineafter(b'seed: ', str(v).encode())

l1, l2 = [], []

for i in range(5):
    r.recvuntil(b'n=')
    n = int(r.recvline().decode().strip())
    r.recvuntil(b'e=')
    e = int(r.recvline().decode().strip())
    assert e == 11
    r.recvuntil(b'Cipher Text:')
    c = int(r.recvline().decode().strip())

    l1.append(c)
    l2.append(n)

res = crt(l1, l2)
print(res)
print(long_to_bytes(iroot(int(res), 65537)[0]))
