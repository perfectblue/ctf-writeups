from os import urandom
from pysmt.shortcuts import *
from cipher import AEAD, dump
from braindead import *
log.enable()
args = Args()
args.parse()

def blocks(x, n):
    for i in range(0, len(x), n):
        yield x[i:i+n]

def pad(s):
    l = 8 - (len(s) % 8)
    return s + l * bytearray([l])

u8 = BVType(8)

sbox_lut = Array(u8, BV(0, 8), { BV(i, 8): BV(AEAD.SBOX[i], 8) for i in range(256) })

def SBox(x): return Select(sbox_lut, x)
def gmul(a, b):
    MOD = 0x11d
    out = BV(0, 8)
    for i in range(8):
        out = out ^ Ite(Equals(BVExtract(b, i, i), BV(1, 1)), a, BV(0, 8))
        carry = BVExtract(a, 7, 7)
        a = BVLShl(a, BV(1, 8)) ^ Ite(Equals(carry, BV(1, 1)), BV(0x1d, 8), BV(0, 8))
    return out

def aead_round(state):
    P = state[  :  8]
    Q = state[ 8: 17]
    R = state[17: 26]
    S = state[26: ]

    P_ = BV(ord('0'), 8) ^ P[0] ^ P[2] ^ P[3] ^ gmul(P[4], P[6]) ^ Q[5]
    Q_ = BV(ord('C'), 8) ^ Q[0] ^ Q[3] ^ gmul(Q[1], Q[8]) ^ gmul(R[4], S[6])
    R_ = BV(ord('T'), 8) ^ R[0] ^ R[2] ^ R[3] ^ gmul(R[5], R[8]) ^ S[7]
    S_ = BV(ord('F'), 8) ^ S[0] ^ S[8] ^ gmul(S[2], S[4]) ^ gmul(P[7], Q[2])

    return P[1:] + [SBox(P_)] + \
    Q[1:] + [SBox(Q_)] + \
    R[1:] + [SBox(R_)] + \
    S[1:] + [SBox(S_)]

initial = [ Symbol(f'I_{i}', u8) for i in range(36) ]
msg = b'The quick brown fox jumps over the lazy dog.'

assertions = []

ad = b'0CTF2022'
key = urandom(16)
iv = urandom(16)
for do_fault in [ False, True ]:
    aead = AEAD(key, iv, do_fault)
    ct, _ = aead.encrypt(msg, ad)
    state = list(initial)
    for bi, b in enumerate(blocks(pad(msg)[:-8], 8)):
        for i in range(8):
            j = AEAD.IDX[i]
            state[j] = state[j] ^ BV(b[i], 8)
            assertions.append(
                Equals(state[j], BV(ct[bi*8+i], 8))
            )
        if do_fault and bi == 2:
            state[0] ^= 0xff
        for _r in range(4):
            state = aead_round(state)

problem = And(*assertions)
write_smtlib(problem, 'fuckme.smtlib')
with open('fuckme.smtlib', 'r') as f:
    smt = f.read()
smt = smt.replace('QF_ABV*', 'QF_ABV', 1)
with open('fuckme.smtlib', 'w') as f:
    f.write(smt)

solv = io.process(['boolector', '--smt2', '-v', '-m', '-x', '-fun-sl', 'fuckme.smtlib'])
solv.rla('[btor>main] sat')
recovered = [0]*36
for _ in range(36):
    l = solv.rla('define-fun I_').decode().split()
    i = int(l[0])
    v = int(l[-1][2:-1], 16)
    recovered[i] = v

log.success('recovered state: %s', dump(recovered))

c = AEAD(key, iv)
c.state[:] = recovered
for b in reversed(list(blocks(pad(ad), 8))):
    c.inv_update(4)
    c.eat_block(b)
c.inv_update(1337)
recov_key = bytes(c.state[:16])
recov_iv = bytes(c.state[16:32])

log.success('recovered key: %s', recov_key.hex())
log.success('actual key:    %s', key.hex())
log.success('recovered iv: %s', recov_iv.hex())
log.success('actual iv:    %s', iv.hex())

#subprocess.check_output(['boolector',
