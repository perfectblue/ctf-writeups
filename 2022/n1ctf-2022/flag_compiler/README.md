# flag_compiler

To understand the code, replace ';' with ';\n' then replace each emoji to a readable alphabet letter.

After this process, we can finally get how each template works: There are bitvecs, ints, and custom VM instructions!

As I couldn't organize my dirty CPP code, I'll just put the solver to get the flag here :cry:

```py
from Crypto.Util.number import *

F = Zmod(0xfa56ea25)
G = Zmod(0xfffffffb)

values = [0x5aa8136e, 0x55966a60, 0x1a5864a, 0x91206274, 0xa70182a2, 0x165bcd5d, 0xeec2bce3, 0xbdb5d6a5, 0x8d5c8940, 0xfa9d53fa]
values = [G(v).log(G(0xffffffef)) for v in values]

P = PolynomialRing(F, ','.join(f"x{i}" for i in range(10)))

cur = list(P.gens())
IMM = F(0x7f874cb)
imm = F(0x7f874cb)

for i in range(10):
    cur[i] = imm * cur[i] + F(i)
    imm *= IMM

while True:
    cur = cur + cur[:2]
    for i in range(10):
        cur[i] = (3 * cur[i + 2] + 2 * cur[i + 1] + cur[i]) * imm
        imm *= IMM
    cur = cur[:10]

    if imm == F(0x6e3a458b):
        break

mat = []
vec = []
for i in range(10):
    mat.append([ cur[i].monomial_coefficient(P.gens()[j]) for j in range(10) ])
    vec.append(-cur[i].constant_coefficient() + values[i])

mat = Matrix(mat)
vec = vector(F, vec)
res = mat.solve_right(vec)
print(b''.join(int(v).to_bytes(4, 'little') for v in res).decode()) 
```

The flag is `n1ctf{C++:teMp1aTe<Vm>_1s_cOo0l-6ut~Slow!;#<=>}`.