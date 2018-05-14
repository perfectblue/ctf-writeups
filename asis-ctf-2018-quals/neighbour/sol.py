import mpmath
from pwn import *
import math
from hashlib import sha256


def npp(n):
    mpmath.mp.dps = len(n)
    best = 0
    bbase=0
    bk=0
    for k in range(2, int(mpmath.ceil(mpmath.log(n, 2)))):
        base = int(mpmath.floor(mpmath.power(n,'1/%d' %(k,))))
        cand = pow(base,k)
        if cand > best:
            bbase = int(base)
            bk=k
            best = cand
    print bbase
    print bk
    return best

def solve_pow(goal):
    nonce = 0
    assert(len(goal)==6)
    while True:
        if sha256(str(nonce)).hexdigest()[-6:] == goal:
            print nonce
            return str(nonce)
        if nonce % 100000 == 0:
            print nonce
        nonce += 1

r = remote('37.139.22.174', 11740)
print r.recvuntil('sha256(X)[-6:] = ')
r.sendline(solve_pow(r.recvn(6)))
i = 0
print r.recvline()
print r.recvline()
print r.recvline()
while True:
    print r.recvn(4)
    n = r.recvline()
    print 'n=%s'%(n,)
    print r.recvline()
    sol = npp(n)
    print 'sol=%d'%(sol,)
    answer = int(n)-sol
    assert(answer>0)
    print 'r=%d'%(answer,)
    r.sendline(str(answer))
    output = r.recvline() # Great! :) please pass the next stage :P
    print output
    if 'Great' not in output:
        break
    i += 1
    print i
r.interactive()