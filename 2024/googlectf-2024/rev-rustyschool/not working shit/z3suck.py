from z3 import *
s = Solver()

FUCKSTICk = 0
def new_var(name):
    global FUCKSTICk
    FUCKSTICk+=1
    return BitVec(f'_{FUCKSTICk}_{name}', 16)

def def_var(name, val):
    new_ = new_var(name)
    s.add(new_ == val)
    return new_

def derive(arr, i, m: int) -> bytes:
    out = []
    key = BitVecVal(0, 16)
    c0, c1 = arr[(i + 2 * m) % 6], arr[(i + 2 * m + 1) % 6]
    # while c0 and c1:
    for NNNN in range(16):
        key = def_var('key', key ^ c0 & -(LShR(c1, NNNN) & 1))
        c0 = def_var('c0', (c0 << 1) ^ If((c0 & 0x8000) == 0, BitVecVal(0, 16), BitVecVal(0x2B, 16)))
    return arr[(i + 4 + m) % 6] ^ key

import os
import hashlib
import struct

P = 79160129948973046149879599747


def p16(x):
    return struct.pack("<H", x)


def u16(x):
    return struct.unpack("<H", x)[0]

def derive_not_gay(seed: bytes, *, m: int) -> bytes:
    assert len(seed) == 12
    arr = [u16(seed[i * 2 : i * 2 + 2]) for i in range(6)]
    out = []
    print(arr)
    for i in range(6):
        key = 0
        c0, c1 = arr[(i + 2 * m) % 6], arr[(i + 2 * m + 1) % 6]
        while c0 and c1:
            key ^= c0 & -(c1 & 1)
            v17 = (c0 << 1) ^ 0x2B
            if (c0 & 0x8000) == 0:
                v17 = c0 << 1
            c0 = v17 & 0xFFFF
            c1 >>= 1
        out.append(arr[(i + 4 + m) % 6] ^ key)
    return out


correct_out = derive_not_gay(b'123456654321',m=0)

inps = [12849, 13363, 13877, 13622, 13108, 12594]
output = [derive([BitVecVal(x, 16) for x in inps],i=i,m=0) for i in range(6)]
assert s.check() == sat
m = s.model()
output = [m.eval(x).as_long() for x in output]
print(output)
assert output == correct_out
print('self-test OK')


def solveit(solve_for, m):
    known_inputs = [...]*6

    c0, c1 = arr[(i + 2 * m) % 6], arr[(i + 2 * m + 1) % 6]

    for i in range(6):
        s.reset()
        arr = [BitVec(f'arr_{j}',16) for j in range(6)]
        for j in range(len(known_inputs)):
            s.add(arr[j] == known_inputs[j])
        print(s)
        output = derive(arr, i,m)
        s.add(output==solve_for[i])
        print(s.check())
        model = s.model()
        soln = model.eval(arr[i]).as_long()
        print('got ', soln)
        known_inputs.append(soln)
    return known_inputs
solve_for = [25327, 25045, 48669, 31010, 31040, 47682]
solution = solveit(solve_for,m=0)
print(solution)
