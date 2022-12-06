from Crypto.Util.number import long_to_bytes

Zx.<x> = ZZ[]
n, q = 263, 128
md = 0
for i in range(n):
    md += x^i

def convolution(f,g):
    return (f * g) % (x^n-1)

def balancedmod(f,q):
    g = list(((f[i] + q//2) % q) - q//2 for i in range(n))
    return Zx(g) % (x^n-1)

def balancedmod_pseudo(f,q):
    f = 0*x + f
    g = list(((f[i] + q//2) % q) - q//2 for i in range(n))
    return Zx(g) #% ((x^n-1)/(x-1))

def pseudoinvertmodprime(f,p):
    T = Zx.change_ring(Integers(p)).quotient(md)
    return Zx(lift(1 / T(f)))

def pseudoinvertmodpowerof2(f,q):
    assert q.is_power_of(2)
    b = pseudoinvertmodprime(f, 2)
    qr = 2
    while qr < q:
        qr = qr ^ 2
        b = b * (2 - f * b)
        b = b % md
        b = balancedmod_pseudo(b, q)
    return b

load('output.sage')
pinv = pseudoinvertmodpowerof2(pubkey, 128)
recov = [[] for _ in range(n)]
for i in range(1, 24):
    ccomb = balancedmod( convolution(res[0] - res[i], pinv), 128 )

    for j in range(n):
        if type(recov[j]) != list:
            continue
        if ccomb[j] == -2:
            recov[j] = -1
        elif ccomb[j] == 2:
            recov[j] = 1
        else:
            recov[j].append(ccomb[j])

r0 = 0
for i in range(n):
    if type(recov[i]) == list:
        r0 += round(sum(recov[i]) / 24) * x^i
    else:
        r0 += recov[i] * x^i

encoded = balancedmod(res[0] - convolution(pubkey, r0), q)
val = 0
for i in reversed(range(n)):
    val *= 3
    val += (encoded[i] + 1) % 3

print(long_to_bytes(val))