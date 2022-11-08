from Crypto.Util.number import *

values = []
with open('output.txt', 'r') as f:
    for i in range(7):
        line = f.readline()
        values.append(list(map(int, line.strip().split(' '))))

N = prod(v[0] for v in values)
FF = Zmod(N)

tmp = 0
for n, a, b, y in values:
    F = Zmod(n)
    P.<m> = PolynomialRing(F)
    a, b, y = F(a), F(b), F(y)

    d = (3*m^2+a)^2
    e = 4*(m^3+a*m+b)
    xt = d - 2*m * e

    f = xt^3 + a * xt * e^2 + (b - y^2) * e^3
    f = f.change_ring(FF)
    f *= (N // n)
    tmp += f

f = tmp.monic()
print("Running")
print(f.small_roots(epsilon=0.033))