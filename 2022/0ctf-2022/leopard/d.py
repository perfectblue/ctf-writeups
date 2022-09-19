from os import urandom
from cipher import AEAD, dump

def xor(a, b): return bytes((a^b for a,b in zip(a, b)))

def pad(s):
    l = 8 - (len(s) % 8)
    return s + l * bytearray([l])

def blocks(x, n):
    for i in range(0, len(x), n):
        yield x[i:i+n]

msg = b'The quick brown fox jumps over the lazy dog.'
ad = b'0CTF2022'
key = urandom(16)
iv = urandom(16)
C1 = AEAD(key, iv)
C2 = AEAD(key, iv, True)
C1.process_ad(ad)
C2.process_ad(ad)

output_mask = bytearray(36)
for i in AEAD.IDX:
    output_mask[i] = 0xff
output_mask = dump(output_mask).replace('0', ' ').replace('f', '*')

for bi, b in enumerate(blocks(pad(msg), 8)):
    C1.eat_block(b)
    C2.eat_block(b)
    if bi == 2:
        C2.state[0] ^= 0xff
    print(output_mask)
    for r in range(4):
        print(dump(xor(C1.state, C2.state)))
        C1.update(1)
        C2.update(1)
