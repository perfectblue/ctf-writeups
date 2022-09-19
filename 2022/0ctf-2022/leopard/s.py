from hashlib import sha256
from cipher import AEAD
import re

def blocks(x, n):
    for i in range(0, len(x), n):
        yield x[i:i+n]

def pad(s):
    l = 8 - (len(s) % 8)
    return s + l * bytearray([l])

def hash_val(x):
    if isinstance(x, int):
        return sha256(b'i' + str(x).encode()).digest()
    else:
        assert isinstance(x, Op)
        return x.h

class Op:
    def __init__(self, code, *args):
        self.code = code
        if code == '+':
            self.args = []
            const = 0
            q = list(args)
            i = 0
            xs = set()
            while i < len(q):
                x = q[i]
                i += 1
                if isinstance(x, int):
                    const ^= x
                elif isinstance(x, Op) and x.code == '+':
                    q.extend(x.args)
                else:
                    if x in xs:
                        xs.remove(x)
                    else:
                        xs.add(x)
            self.args.extend(xs)
            self.args.sort(key=lambda x: x.h)
            if const != 0:
                self.args.append(const)
        else:
            self.args = tuple(args)

        t = bytearray(code.encode())
        for a in self.args:
            t += hash_val(a)
        self.h = sha256(t).digest()

    def __str__(self):
        global known
        if self in known:
            return known[self]

        if len(self.args) == 0:
            return self.code
        elif self.code == 'S':
            return f'S({self.args[0]})'
        elif self.code == '+':
            return ' + '.join(map(str, self.args))
        elif self.code == '*':
            t = []
            for x in self.args:
                if isinstance(x, Op) and x.code == '+':
                    t.append('(' + str(x) + ')')
                else:
                    t.append(str(x))
            return '*'.join(t)

mem = {}
known = {}

def op(code, *args):
    t = Op(code, *args)
    if t.code == '+' and len(t.args) == 1:
        return t.args[0]
    if t.code == '+' and len(t.args) == 0:
        return 0
    if t.h in mem:
        return mem[t.h]
    mem[t.h] = t
    return t

def gmul(a, b): return op('*', a, b)
def add(*terms):
    t = terms[0]
    for s in terms[1:]:
        t = op('+', t, s)
    return t
def sbox(a): return op('S', a)

def aead_round(state):

    P = state[  :  8]
    Q = state[ 8: 17]
    R = state[17: 26]
    S = state[26: ]

    P_ = add(ord('0'), P[0], P[2], P[3], gmul(P[4], P[6]), Q[5])
    Q_ = add(ord('C'), Q[0], Q[3], gmul(Q[1], Q[8]), gmul(R[4], S[6]))
    R_ = add(ord('T'), R[0], R[2], R[3], gmul(R[5], R[8]), S[7])
    S_ = add(ord('F'), S[0], S[8], gmul(S[2], S[4]), gmul(P[7], Q[2]))

    return (
        P[1:] + [sbox(P_)] +
        Q[1:] + [sbox(Q_)] +
        R[1:] + [sbox(R_)] +
        S[1:] + [sbox(S_)]
    )

msg = b'The quick brown fox jumps over the lazy dog.'[16:]
initial = [ op(f'I{i:02}') for i in range(36) ]
pt = [ *pad(msg) ]

for i in AEAD.IDX:
    known[initial[i-4]] = f'i{i-4:02}'
    known[initial[i]] = f'i{i:02}'

#for i in [8, 17, 26, 27]:
#    known[initial[i]] = f'i{i:02}'

normal_out = []
fault_out = []

state = [*initial]
for bi, b in enumerate(blocks(pt, 8)):
    for i in range(8):
        j = AEAD.IDX[i]
        state[j] = add(state[j], b[i])
        normal_out.append(state[j])
        #known[state[j]] = f'ct_{bi*8+i}'
    state = aead_round(state)
    state = aead_round(state)
    state = aead_round(state)
    state = aead_round(state)

state = [*initial]
for bi, b in enumerate(blocks(pt, 8)):
    for i in range(8):
        j = AEAD.IDX[i]
        state[j] = add(state[j], b[i])
        fault_out.append(state[j])
    if bi == 0:
        state[0] = add(state[0], 255)
    state = aead_round(state)
    state = aead_round(state)
    state = aead_round(state)
    state = aead_round(state)

if 0:
    for i in range(len(fault_out)):
        print('F', i, ':', fault_out[i])
        #print('N', i, ':', normal_out[i])

#print('graph {')
#for x in initial:
#    if x not in known:
#        print(f'{x} [shape=circle,label="{x}"];')

node_inputs = {}
for i in range(8, 32):
    nodes = set(re.compile(r'I[0-9]{2}').findall(str(fault_out[i])))
    node_inputs[i] = nodes
    #print(f'out_{i} [shape=box,label="{i}"];')
    #for x in nodes:
    #    print(f'out_{i} -- {x};')
#print('}')

if 0:
    for i in range(32):
        t = add(normal_out[i], fault_out[i])
        print('X', i, ':', t)


if 1:
    budget = 0
    pending = set(node_inputs)
    known = set()
    while len(known) < 20:
        best = 9999, -1, -1
        for n in pending:
            cost = 8*len(node_inputs[n]) - 8
            tcost = 0
            if 'I00' in node_inputs[n]:
                cost -= 8
            for x in node_inputs[n]:
                if x in known:
                    cost -= 8
                else:
                    tcost += 8
            #print(n, cost)
            rcost = budget+tcost
            if (cost, rcost, n) < best:
                best = cost, rcost, n
        cost, rcost, n = best
        budget += cost
        print('pick', n, rcost, budget, node_inputs[n] - known, 'of', node_inputs[n])
        known.update(node_inputs[n])
        pending.remove(n)
