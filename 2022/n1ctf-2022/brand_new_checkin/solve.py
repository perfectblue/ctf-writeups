from Crypto.Util.number import *
from output import pubkey, c
from tqdm import tqdm
import random

TemperingMaskB = 0x9d2c5680
TemperingMaskC = 0xefc60000

def untemper(y):
    y = undoTemperShiftL(y)
    y = undoTemperShiftT(y)
    y = undoTemperShiftS(y)
    y = undoTemperShiftU(y)
    return y

def undoTemperShiftL(y):
    last14 = y >> 18
    final = y ^ last14
    return final

def undoTemperShiftT(y):
    first17 = y << 15
    final = y ^ (first17 & TemperingMaskC)
    return final

def undoTemperShiftS(y):
    a = y << 7
    b = y ^ (a & TemperingMaskB)
    c = b << 7
    d = y ^ (c & TemperingMaskB)
    e = d << 7
    f = y ^ (e & TemperingMaskB)
    g = f << 7
    h = y ^ (g & TemperingMaskB)
    i = h << 7
    final = y ^ (i & TemperingMaskB)
    return final

def undoTemperShiftU(y):
    a = y >> 11
    b = y ^ a
    c = b >> 11
    final = y ^ c
    return final

s, t, n = pubkey
fenc = []
inv = [inverse(i, n) for i in range(256)]

def xgcd(a, b):
    x0, x1, y0, y1 = 0, 1, 1, 0
    while a != 0:
        (q, a), b = divmod(b, a), a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
    return b, x0, y0

def parse_1024bits(v):
    arr = []
    for i in range(0, 1024, 32):
        arr.append(v & 0xFFFFFFFF)
        v >>= 32
    return arr

_, a, b = xgcd(s, t)
assert s * a + t * b == 1

v384s = []
v416s = []
v608s = []
v640s = []

for idx, (c1, c2) in tqdm(enumerate(c), total=len(c)):
    if c1 == 0:
        fenc.append(0)
        continue

    for i in range(1, 256):
        rs = inv[i] * c1 % n
        rt = inv[i] * c2 % n
        if pow(rs, t, n) == pow(rt, s, n):
            fenc.append(i)
            if idx == 10:
                to_append = v384s
            elif idx == 11:
                to_append = v416s
            elif idx == 17:
                to_append = v608s
            elif idx == 18:
                to_append = v640s
            else:
                break
            r = pow(rs, a, n) * pow(rt, b, n) % n
            assert pow(r, s, n) == rs and pow(r, t, n) == rt
            while r.bit_length() <= 1024:
                to_append.append(r)
                r += n
            break
    else:
        print("??????")
        exit(0)

fenc = bytes_to_long(bytes(fenc))

for v384 in v384s:
    for v416 in v416s:
        for v608 in v608s:
            for v640 in v640s:
                state = parse_1024bits(s)
                state += [0] * (384 - 64)
                state += parse_1024bits(v384)
                state += parse_1024bits(v416)
                state += [0] * (608 - 448)
                state += parse_1024bits(v608)
                state += parse_1024bits(v640)[:16]
                assert len(state) == 624

                state = [untemper(v) if v else 0 for v in state]
                random.setstate((3, tuple(state + [0]), None))
                assert random.getrandbits(1024) == s

                for i in range(33):
                    v = state[-1] ^ state[396]
                    if v & 0x80000000:
                        y = ((v ^ 0x9908b0df) << 1) | 1
                    else:
                        y = v << 1
                    
                    if i == 0:
                        if (y & 0x7FFFFFFF) != state[0] & 0x7FFFFFFF:
                            break
                        state = [y & 0x80000000] + state[:-1]
                    else:
                        assert state[0] & 0x7FFFFFFF == 0
                        state[0] |= y & 0x7FFFFFFF
                        if i < 32:
                            state = [y & 0x80000000] + state[:-1]
                else:
                    random.setstate((3, tuple(state + [0]), None))
                    a = random.getrandbits(1024)
                    phi_mul = (1 - a) * t + a * s
                    if phi_mul < 0:
                        phi_mul = -phi_mul
                    while phi_mul % 0x10001 == 0:
                        phi_mul //= 0x10001
                    
                    if pow(2, phi_mul, n) != 1:
                        continue

                    res = inverse(0x10001, phi_mul)

                    print(long_to_bytes(pow(fenc, res, n)))