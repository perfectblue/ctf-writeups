import math
import struct

def f2i(x):
    return struct.unpack('<q', struct.pack('<d', x))[0]

def i2f(n):
    return struct.unpack('<d', struct.pack('<q', n))[0]

def fstep(x,step=1):
    # NaNs and positive infinity map to themselves.
    if math.isnan(x) or (math.isinf(x) and x > 0):
        return x

    # 0.0 and -0.0 both map to the smallest +ve float.
    if x == 0.0:
        x = 0.0

    n = f2i(x)
    if n >= 0:
        n += step
    else:
        n -= step
    return i2f(n)
