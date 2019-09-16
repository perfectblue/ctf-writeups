#! /usr/bin/env python2

from base64 import b64encode, b64decode
from bls.scheme import *
from bls.utils import *
from bplib.bp import G1Elem, G2Elem
from petlib.bn import Bn

from pwn import *

def key(x):
    return G2Elem.from_bytes(b64decode(x), G)
def sig(x):
    return G1Elem.from_bytes(b64decode(x), G)
def pp(x):
    return b64encode(x.export())

params = setup()
(G, o, g1, g2, e) = params

A = o.random()
B = A

while A == B:
    B = o.random()

print "testing with (%d, %d)" % (A, B)

l = [lagrange_basis(2, o, i, 0) for i in range(1, 3)]
L = [lagrange_basis(3, o, i, 0) for i in range(1, 4)]

Hm = G.hashG1(hash("this stuff"))
s1 = A * Hm
s2 = B * Hm

#r = process("./chal.py")
r = remote("crypto.chal.csaw.io", 1004)

r.recvline()
r.recvline()
r.recvline()
a = key(r.recvline())
r.recvline()
b = key(r.recvline())
r.recvline()
c = key(r.recvline())

r.recvline()
r.sendline("4")

r.recvline()
r.recvline()
r.sendline(pp(s1))
r.recvline()
r.sendline(pp(a))
r.recvline()
r.sendline(pp(s2))
r.recvline()
r.sendline(pp(b))
r.recvline()
r.sendline(pp(L[2].mod_inverse(o) * ((A * l[0] + B * l[1]) * g2 - L[0] * a - L[1] * b)))

print r.recvline().strip()
