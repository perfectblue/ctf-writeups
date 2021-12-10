import random
import os
from mt import *

with open('data', 'r') as f:
    lines = f.read().split('\n')[2:-1]
    data = []
    for v in [int(line.split(' ')[0], 16) for line in lines]:
        for i in range(8):
            data.append((v >> (32 * i)) & 0xFFFFFFFF)

for i in range(2, len(data) - 624, 8):
    v1 = untemper(data[i])
    v2 = untemper(data[i + 1])
    # v3 = untemper(data[i + 397])
    v4 = untemper(data[i + 624])

    y = (v1 & 0x80000000) | (v2 & 0x7FFFFFFF)
    if y & 1:
        v = v4 ^ (y >> 1) ^ 0x9908b0df
    else:
        v = v4 ^ (y >> 1)
    
    v = temper(v)
    assert v >> 16 == data[i + 397]
    data[i + 397] = v

for i in range(391, 0, -8):
    # v1 = untemper(data[i])
    v2 = untemper(data[i + 1])
    v3 = untemper(data[i + 397])
    v4 = untemper(data[i + 624])

    y = v2 & 0x7FFFFFFF
    if y & 1:
        v = v3 ^ v4 ^ (y >> 1) ^ 0x9908b0df
    else:
        v = v3 ^ v4 ^ (y >> 1)

    if v:
        res = 0x80000000
    else:
        res = 0
    
    v1 = untemper(data[i - 1])
    # v2 = untemper(data[i])
    v3 = untemper(data[i + 396])
    v4 = untemper(data[i + 623])

    v = v3 ^ v4
    if v & 0x80000000:
        y = ((v ^ 0x9908b0df) << 1) | 1
    else:
        y = v << 1
    
    assert y & 0x80000000 == v1 & 0x80000000

    res |= y & 0x7FFFFFFF
    
    v = temper(res)
    assert v >> 16 == data[i]
    data[i] = v

data = [0] * 624 + [untemper(v) for v in data[:624]]

for i in range(623, -1, -1):
    v3 = data[i + 397]
    v4 = data[i + 624]

    v = v3 ^ v4
    if v & 0x80000000:
        y = ((v ^ 0x9908b0df) << 1) | 1
    else:
        y = v << 1

    data[i] |= y & 0x80000000
    data[i + 1] |= y & 0x7fffffff

def randomdpoly(d1, d2):
    result = d1*[1]+d2*[-1]+(263-d1-d2)*[0]
    random.shuffle(result)
    return result

for i in range(623, -1, -1):
    state = (3, tuple(data[:624] + [i]), None)
    random.setstate(state)
    result = randomdpoly(18, 18)
    if random.getstate()[1][-1] == 624:
        print(result)
