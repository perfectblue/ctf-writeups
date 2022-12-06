# Chimera

1. Recover n^2 with:
```py
from output import *

n2 = None

for i in range(62):
    x1, y1 = chimera[i]
    x2, y2 = chimera[i+1]
    x3, y3 = chimera[i+2]

    t1 = y1*y1 - y2*y2
    t2 = y2*y2 - y3*y3

    t1 = t1 * (x2 - x3) - t2 * (x1 - x2)
    t2 = (x1**3 - x2**3) * (x2 - x3) - (x2**3 - x3**3) * (x1 - x2)

    if n2 is None:
        n2 = abs(t1 - t2)
    else:
        n2 = gcd(n2, t1 - t2)

print(n2)
print(sqrt(n2))
```

2. Recover p, q by factoring `gift` and do ECM with it (`factor.sage`)
3. Use https://arxiv.org/abs/2010.15543 for isomorphism to `Z/giftZ * Z/nZ`
4. Get `k_i` that satisfies `k_i * chimera[0] = chimera[i]`, with dlog
5. Recover `snake_tail` with hidden subset problem

`factor.sage` and `solve.sage` are not well organized,
but you can understand what's going on by reading it