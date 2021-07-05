from pwn import *
import gmpy2

r = remote("111.186.59.11", 16256)

w = r.recvuntil("= ?").decode()
print(w)
exp = int(w.split(')')[0].split('^')[-1])
mod = gmpy2.mpz(int(w.rstrip(' = ?').split(' ')[-1]))

result = gmpy2.mpz(2)
n = 10
expo = gmpy2.mpz(2**n)
for i in range(exp // n):
    result = gmpy2.powmod(result, expo, mod)
for i in range(exp % n):
    result = gmpy2.powmod(result, 2, mod)
#print(result)
r.sendlineafter('Your answer:', str(result))
r.interactive()