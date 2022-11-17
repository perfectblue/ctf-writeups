from tqdm import tqdm
from pwn import *
import random

class Twister:
    N = 624
    M = 397
    A = 0x9908b0df

    def __init__(self):
        self.state = [ [ (1 << (32 * i + (31 - j))) for j in range(32) ] for i in range(624)]
        self.index = 624
    
    @staticmethod
    def _xor(a, b):
        return [x ^ y for x, y in zip(a, b)]
    
    @staticmethod
    def _and(a, x):
        return [ v if (x >> (31 - i)) & 1 else 0 for i, v in enumerate(a) ]
    
    @staticmethod
    def _shiftr(a, x):
        return [0] * x + a[:-x]
    
    @staticmethod
    def _shiftl(a, x):
        return a[x:] + [0] * x

    def get32bits(self):
        if self.index >= self.N:
            for kk in range(self.N):
                y = self.state[kk][:1] + self.state[(kk + 1) % self.N][1:]
                z = [ y[-1] if (self.A >> (31 - i)) & 1 else 0 for i in range(32) ]
                self.state[kk] = self._xor(self.state[(kk + self.M) % self.N], self._shiftr(y, 1))
                self.state[kk] = self._xor(self.state[kk], z)
            self.index = 0

        y = self.state[self.index]
        y = self._xor(y, self._shiftr(y, 11))
        y = self._xor(y, self._and(self._shiftl(y, 7), 0x9d2c5680))
        y = self._xor(y, self._and(self._shiftl(y, 15), 0xefc60000))
        y = self._xor(y, self._shiftr(y, 18))
        self.index += 1

        return y
    
    def getrandbits(self, bit):
        return self.get32bits()[:bit]

class Solver:
    def __init__(self):
        self.equations = []
        self.outputs = []
    
    def insert(self, equation, output):
        for eq, o in zip(self.equations, self.outputs):
            lsb = eq & -eq
            if equation & lsb:
                equation ^= eq
                output ^= o
        
        if equation == 0:
            assert output == 0
            return

        lsb = equation & -equation
        for i in range(len(self.equations)):
            if self.equations[i] & lsb:
                self.equations[i] ^= equation
                self.outputs[i] ^= output
    
        self.equations.append(equation)
        self.outputs.append(output)
    
    def solve(self):
        num = 0
        for i, eq in enumerate(self.equations):
            if self.outputs[i]:
                # Assume every free variable is 0
                num |= eq & -eq
        
        state = [ (num >> (32 * i)) & 0xFFFFFFFF for i in range(624) ]
        return state

# --------------------------- Get values

r = remote('janken-vs-kurenaif.seccon.games', 8080)

r.recvuntil(b'kurenaif: My spell is ')
witch_spell = r.recvuntil(b'.')[:-1].decode()
print(witch_spell)
witch_rand = random.Random()
witch_rand.seed(int(witch_spell, 16))

twister = Twister()

outputs = []
equations = []

for _ in range(666):
    witch_hand = witch_rand.randint(0, 2)

    output = (witch_hand - 2) % 3
    outputs.append(output)
    equations.append(twister.getrandbits(2))

solver = Solver()
solver.insert(1 << 31, 1)
for i in range(31):
    solver.insert(1 << i, 0)

for i in tqdm(range(666)):
    bit = len(equations[i])
    for j in range(bit):
        solver.insert(equations[i][j], (outputs[i] >> (bit - 1 - j)) & 1)

state = solver.solve()
recovered_state = (3, tuple(state + [624]), None)

witch_rand = random.Random()
witch_rand.seed(int(witch_spell, 16))

your_random = random.Random()
your_random.setstate(recovered_state)

def janken(a, b):
    return (a - b + 3) % 3

for _ in range(666):
    witch_hand = witch_rand.randint(0, 2)
    your_hand = your_random.randint(0, 2)

    if janken(your_hand, witch_hand) != 1:
        print("kurenaif: Could you come here the day before yesterday?")
        quit()

from z3 import *

mt = [19650218]
for i in range(1, 624):
    mt.append(1812433253 * (mt[i - 1] ^ (mt[i - 1] >> 30)) + i)
    mt[i] &= 0xFFFFFFFF

mt = [BitVecVal(v, 32) for v in mt]

init_key = [BitVec(f'k_{i}', 32) for i in range(624)]

i, j = 1, 0
for k in range(624, 0, -1):
    mt[i] = (mt[i] ^ ((mt[i-1] ^ LShR(mt[i-1], 30)) * 1664525)) + init_key[j] + j
    i += 1
    j += 1
    if i >= 624:
        mt[0] = mt[623]
        i = 1

for k in range(623, 0, -1):
    mt[i] = (mt[i] ^ ((mt[i-1] ^ LShR(mt[i-1], 30)) * 1566083941)) - i
    i += 1
    if i >= 624:
        mt[0] = mt[623]
        i = 1

sol = Solver()
for i in range(1, 624):
    sol.add(mt[i] == state[i])

print("Check")
res = sol.check()
print(res)

seed = 0
if res == sat:
    m = sol.model()
    for i in range(624):
        k = m[init_key[i]].as_long()
        seed |= k << (32 * i)

print(seed)

witch_rand = random.Random()
witch_rand.seed(int(witch_spell, 16))

your_random = random.Random()
your_random.seed(seed)

def janken(a, b):
    return (a - b + 3) % 3

for _ in range(666):
    witch_hand = witch_rand.randint(0, 2)
    your_hand = your_random.randint(0, 2)

    if janken(your_hand, witch_hand) != 1:
        print("kurenaif: Could you come here the day before yesterday?")
        quit()

r.sendlineafter(b'spell: ', hex(seed).encode())
r.interactive()