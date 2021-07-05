from pwn import *
import hashlib
import string
import itertools
import subprocess
import random

def _prod(L):
    p = 1
    for x in L:
        p *= x
    return p

def _sum(L):
    s = 0
    for x in L:
        s ^= x
    return s

def n2l(x, l):
    return list(map(int, '{{0:0{}b}}'.format(l).format(x)))

r = remote('111.186.59.28', 31337)
r.recvuntil('+ ')
suffix = r.recv(16)
r.recvuntil(' == ')
digest = r.recv(64).decode()

print(suffix, digest)
for x in itertools.product(string.ascii_letters + string.digits + '!#$%&*-?', repeat=4):
    if hashlib.sha256(''.join(x).encode() + suffix).hexdigest() == digest:
        print(x)
        r.sendlineafter('XXXX:\n', ''.join(x))
        break

# LFSR1
class Generator1_LFSR:
    def __init__(self, key: list):
        assert len(key) == 16
        self.LFSR = key[:]
        self.TAP = [0, 1, 12, 15]
        self.h_IN = [2, 4, 7, 15]
        self.h_OUT1 = [[1], [3], [0, 3], [0, 1, 2], [0, 2, 3]]
        self.h_OUT2 = [[0, 2], [0, 1, 2]]

    def h(self):
        x = [self.LFSR[i] for i in self.h_IN]
        t1 = _sum(_prod(x[i] for i in j) for j in self.h_OUT1)
        t2 = _sum(_prod(x[i] for i in j) for j in self.h_OUT2)
        return None if t2 else t1

    def f(self):
        return self.h()

    def clock(self):
        o = self.f()
        self.LFSR = self.LFSR[1: ] + [_sum(self.LFSR[i] for i in self.TAP)]
        return o

r.sendlineafter('which one: ', '1')
r.recvuntil('start:::')
stream = r.recvuntil(':::end')[:-6].decode('latin-1')
r.recvuntil('hint: ')
hint = r.recv(64).decode()
print("hint: ", hint)

assert len(stream) == 1000
arr = []
for i in range(1000):
    for j in range(8):
        arr.append( (ord(stream[i]) >> (7 - j)) & 1 )

inp = ''.join(str(v) for v in arr) + '\n'
proc = subprocess.run('./lfsr1', input=inp.encode(), stdout=subprocess.PIPE)
for l in proc.stdout.decode().split('\n'):
    if not l.strip():
        break
    
    k = int(l.strip(), 2)
    if hashlib.sha256(str(k).encode()).hexdigest() == hint:
        r.sendlineafter('k:', str(k))
        break

# LFSR3
class Generator3:
    def __init__(self, key: list):
        assert len(key) == 64
        self.LFSR = key
        self.TAP = [0, 55]
        self.f_IN = [0, 8, 16, 24, 32, 40, 63]
        self.f_OUT = [[1], [6], [0, 1, 2, 3, 4, 5], [0, 1, 2, 4, 6]]

    def f(self):
        x = [self.LFSR[i] for i in self.f_IN]
        return _sum(_prod(x[i] for i in j) for j in self.f_OUT)

    def clock(self):
        self.LFSR = self.LFSR[1: ] + [_sum(self.LFSR[i] for i in self.TAP)]
        return self.f()

class Generator3Sol:
    def __init__(self):
        self.LFSR = [ 1 << i for i in range(64) ]
        self.TAP = [0, 55]
        self.f_IN = [0, 8, 16, 24, 32, 40, 63]
        self.f_OUT = [[1], [6], [0, 1, 2, 3, 4, 5], [0, 1, 2, 4, 6]]

    def f(self):
        x = [self.LFSR[i] for i in self.f_IN]
        return x[1] ^^ x[6]

    def clock(self):
        for _ in range(3):
            self.LFSR = self.LFSR[1: ] + [self.LFSR[0] ^^ self.LFSR[55]]
            ret = self.f()
        return ret

r.sendlineafter('which one: ', '3')
r.recvuntil('start:::')
stream = r.recvuntil(':::end')[:-6].decode('latin-1')
r.recvuntil('hint: ')
hint = r.recv(64).decode()
print("hint: ", hint)

assert len(stream) == 1000
arr = []
for i in range(1000):
    for j in range(8):
        arr.append( (ord(stream[i]) >> (7 - j)) & 1 )

gen = Generator3Sol()
for i in range(8000):
    v = gen.clock()
    v = Matrix(GF(2), [(v >> i) & 1 for i in range(64)])
    arr[i] = (v, arr[i])

while True:
    wow = random.sample(arr, 64)
    mat = matrix(GF(2), 0, 64)
    for i in range(64):
        mat = mat.stack(wow[i][0])
    vec = vector(GF(2), [wow[i][1] for i in range(64)])

    if mat.rank() != 64:
        continue

    ans = mat.solve_right(vec)
    key = 0
    for i in range(64):
        key <<= 1
        key += int(ans[i])
    
    if hashlib.sha256(str(int(key)).encode()).hexdigest() == hint:
        r.sendlineafter('k:', str(int(key)))
        break

r.interactive()