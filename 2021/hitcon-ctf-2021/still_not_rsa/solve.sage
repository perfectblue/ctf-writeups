from Crypto.Util.number import bytes_to_long as b2l
from Crypto.Util.number import long_to_bytes as l2b
from Crypto.Cipher import AES
from hashlib import sha256
import random, os, binascii
import itertools
from pwn import *

Zx.<x> = ZZ[]
def convolution(f,g):
    return (f * g) % (x^n-1)

def balancedmod(f,q):
    g = list(((f[i] + q//2) % q) - q//2 for i in range(n))
    return Zx(g)  % (x^n-1)

def randomdpoly(d1, d2):
    result = d1*[1]+d2*[-1]+(n-d1-d2)*[0]
    random.shuffle(result)
    return Zx(result)

def invertmodprime(f,p):
    T = Zx.change_ring(Integers(p)).quotient(x^n-1)
    return Zx(lift(1 / T(f)))

def invertmodpowerof2(f,q):
    assert q.is_power_of(2)
    g = invertmodprime(f,2)
    while True:
        r = balancedmod(convolution(g,f),q)
        if r == 1: return g
        g = balancedmod(convolution(g,2 - r),q)

def keypair():
    while True:
        try:
            f = randomdpoly(61, 60)
            f3 = invertmodprime(f,3)
            fq = invertmodpowerof2(f,q)
            break
        except Exception as e:
            pass
    g = randomdpoly(15, 15)
    publickey = balancedmod(3 * convolution(fq,g),q)
    secretkey = f
    return publickey, secretkey, g

def encode(val):
    poly = 0
    for i in range(n):
        c = val % q 
        poly += (((c + q//2) % q) - q//2) * (x^i)
        val //= q
    return poly

def decode(poly):
    val = 0
    for i, c in enumerate(poly.coefficients(sparse=False)):
        val += (c % q) * q^i
    return val

def decrypt(ciphertext, secretkey):
    f = secretkey
    f3 = invertmodprime(f,3)
    a = balancedmod(convolution(encode(ciphertext), f), q)
    return balancedmod(convolution(a, f3), 3)

n, q = 167, 128

# r = process(['sage', 'prob.sage'])
r = remote('54.92.57.54', 31337)
iv = bytes.fromhex(r.recvline().strip().decode())
flag_enc = bytes.fromhex(r.recvline().strip().decode())
pubkey = eval(r.recvline().strip().decode().replace('^', '**'))

c = 24

for it in itertools.combinations(range(n), 2):
    print(it)
    t = 0
    for i in it:
        t += x^i
    msg = balancedmod(c // 3 * convolution(pubkey, t) + c, q)
    r.sendline(l2b(decode(msg)).hex().encode())
    msg = eval(r.recvline().strip().decode().replace('^', '**'))

    try:
        m1 = invertmodprime(msg, 3)
    except:
        continue
    
    for i in range(n):
        f = balancedmod(convolution(x^i, m1), 3)
        for j in range(n):
            seckey = convolution(x^j, f)
            key = sha256(str(seckey).encode()).digest()
            flag = AES.new(key, AES.MODE_CBC, iv).decrypt(flag_enc)
            if flag.startswith(b'hitcon{'):
                print(flag)
                exit(0)
