import numpy as np
import matplotlib.pyplot as plt
import itertools
import sys
from braindead import *
log.enable()
args = Args()
args.parse()

sig = np.fromfile(args.SIG, dtype=np.complex64)

if 0:
    plt.plot(np.real(sig))
    plt.plot(np.imag(sig))
    plt.show()

symbols = []
for i in range(5, sig.shape[0], 10):
    b0 = np.real(sig[i]) > 0.0
    b1 = np.imag(sig[i]) > 0.0
    symbols.append(b0 + 2*b1)

def to_bytes(bits):
    n = (len(bits)+7)//8
    out = bytearray(n)
    for i, b in enumerate(bits):
        assert b == 0 or b == 1
        out[i//8] += b << (i%8)
    return out

#for perm in itertools.permutations(tuple(range(4))):
for perm in ((0, 1, 2, 3,),):
    bits = []
    for si in symbols:
        so = perm[si]
        bits.append(so&1)
        bits.append(so>>1&1)
    sys.stdout.buffer.write(to_bytes(bits))
