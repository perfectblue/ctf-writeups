from nacl.bindings.crypto_scalarmult import (
    crypto_scalarmult_ed25519_noclamp,
    crypto_scalarmult_ed25519_base_noclamp,
)
from nacl.bindings.crypto_core import (
    crypto_core_ed25519_scalar_mul,
    crypto_core_ed25519_scalar_reduce,
    crypto_core_ed25519_is_valid_point,
    crypto_core_ed25519_NONREDUCEDSCALARBYTES,
    crypto_core_ed25519_BYTES
)
import struct
import os
import ast
import hashlib
import random

from pwn import *
from Crypto.Util.number import *

# The order of Ed25519
L = 2**252 + 27742317777372353535851937790883648493

def sha512(b):
    return hashlib.sha512(b).digest()

def hsh(s):
    h = sha512(s)
    assert len(h) == crypto_core_ed25519_NONREDUCEDSCALARBYTES
    return crypto_scalarmult_ed25519_base_noclamp(crypto_core_ed25519_scalar_reduce(h))

def generate_secret_set(r):
    s = set()
    for (i, c) in enumerate(SECRET):
        s.add(hsh(bytes(str(i + 25037 * r * c).strip('L').encode('utf-8'))))
    return s

def to_scalar(v):
    return int(v).to_bytes(32, 'little')

def mult_P(s, P):
    return crypto_scalarmult_ed25519_noclamp(s, P)

def next_prime(v):
    while True:
        v += 2
        if isPrime(v):
            return v

CONST = 4096
primes = []
v = 1
for i in range(2, CONST):
    if isPrime(i):
        primes.append(i)
        v *= primes[-1]
        if v > 2 ** 32:
            break

mult = next_prime(10001)
to_send = []
mult_dict = dict()
for p in primes:
    for k in range(p):
        P = hsh(bytes(str(p + CONST * (k % p)).strip('L').encode('utf-8')))
        Q = mult_P(to_scalar(mult), P)
        mult_dict[mult] = (k, p)
        to_send += [P, Q]
        mult = next_prime(mult)

# con = process(['python3', './server.py'])

con = remote('pressure.chal.pwni.ng', 1337)
l = con.recvline().decode().strip()
res = os.popen(l).read()
con.send(res.encode())

con.recvuntil(b'data!\n')
con.sendline(repr(to_send).encode())

server_combined_client = set(eval(con.recvline()))
server_s = set(eval(con.recvline()))

point_dict = dict()
crts = [[], []]
base = None
for i, P in enumerate(server_combined_client):
    if P not in server_s:
        continue
    
    for j, Q in enumerate(server_combined_client):
        for mult in mult_dict:
            if mult_P(to_scalar(mult), P) == Q:
                k, p = mult_dict[mult]
                crts[0].append(k)
                crts[1].append(p)

                if base is None:
                    h = sha512(bytes(str(p + CONST * (k % p)).strip('L').encode('utf-8')))
                    h = int.from_bytes(h, 'little') % L
                    inv_h = inverse(h, L)
                    base = mult_P(to_scalar(inv_h), P)

r = crt(crts[0], crts[1])
print(r)

SECRET_LEN = len(server_s) - CONST + 1
SECRET = []

for i in range(SECRET_LEN):
    for c in range(1, 256):
        h = sha512(bytes(str(i + 25037 * r * c).strip('L').encode('utf-8')))
        h = crypto_core_ed25519_scalar_reduce(h)
        P = mult_P(h, base)

        if P in server_s:
            SECRET.append(c)
            break
    else:
        print("something wrong")
        exit(1)

s = generate_secret_set(r)
for k in range(1, CONST):
    s.add(hsh(bytes(str(k + CONST * (r % k)).strip('L').encode('utf-8'))))

con.recvuntil(b'time.\n')
server_s = set(eval(con.recvline()))

client_s = set(mult_P(to_scalar(3), P) for P in s)
masked_s = set(mult_P(to_scalar(3), P) for P in server_s)

con.recvuntil(b'points: \n')
con.sendline(repr(client_s).encode())
con.recvuntil(b'points: \n')
con.sendline(repr(masked_s).encode())

con.interactive()
