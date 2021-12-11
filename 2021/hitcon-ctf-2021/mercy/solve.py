def KSA(key):
    keylength = len(key)

    S = list(range(512))

    j = 0
    for i in range(512):
        j = (j + S[i] + key[i % keylength]) % 512
        S[i], S[j] = S[j], S[i]  # swap

    return S


def PRGA(S):
    i = 0
    j = 0
    while True:
        i = (i + 1) % 512
        j = (j + S[i]) % 512
        S[i], S[j] = S[j], S[i]  # swap

        K = S[(S[i] + S[j]) % 512]
        yield K


def RC4(key):
    S = KSA(key)
    return PRGA(S)

key = 0x12B, 0x62, 0xBC, 0x9C, 0x3B, 0x34, 0x111, 0x89, 0x144
print(len(key))
S = KSA(key)

arr=[None]*27

def set(x,y):
    y&=(1<<27)-1
    print(hex(y))
    arr[x]=(y>>9)&0x1ff
    arr[x+1]=(y>>18)&0x1ff
    arr[x+2]=(y)&0x1ff

set(0+0x18, 0xC7A45E)
set(0+3, 0x441D6A8)
set(0+0x12, 0x624E22D)
set(0+0xF, -0xFFFFFFFFF90CF2EF)
set(0+0xC, 0x40FF43F)
set(0, 0x4062EE8)
set(0+0x15, 0x183716F)
set(0+6, 0x69EDF0E)
set(0+9, 0x7885B66)
print([hex(x) for x in arr])

from z3 import *
input = [BitVec('x%d' % i, 9) for i in range(27)]

def swap(arr, x, y):
    tmp = arr[x]
    arr[x] = arr[y]
    arr[y] = tmp

j = 0
prev = 0
output = [None] * 27

for i in range(27):
    j += S[i]
    j %= 512
    swap(S, i, j)
    R10 = S[S[i] + S[j] & 0x1ff]
    R11 = input[i]
    prev = output[i] = (R11 ^ R10) + prev

s = Solver()
s.add([x==y for x, y in zip(output, arr)])
print(s.check())
print([s.model()[x] for x in input])
print(bytes([104, 105, 116, 99, 111, 110, 123, 54, 100, 48, 102, 101, 55, 57, 102, 50, 49, 55, 57, 49, 55, 53, 100, 100, 97, 125, 10]).decode())