from Crypto.Util.number import long_to_bytes
from tqdm import tqdm

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

def to_matrix(f):
    mat = [
        [f[(i - j) % n] for j in range(n)]
        for i in range(n)
    ]
    return Matrix(Zmod(q), mat)

def to_vector(f):
    vec = [f[i] for i in range(n)]
    return vector(Zmod(q), vec)
        
load('output.sage')

m_sum = data[0](1) % q
for i in range(1, 400):
    assert m_sum == data[i](1) % q

mat = []
vec = []

for i in tqdm(range(400)):
    pinv = pseudoinvertmodpowerof2(keys[i], q)
    assert balancedmod((pinv * keys[i]) % md, q) == 1
    b = convolution(pinv, data[i])

    Hh = to_matrix(pinv)
    b = to_vector(b)

    a = Hh.transpose()[0] * Hh
    w = b * Hh

    arr = []
    for i in range(1, n // 2 + 1):
        arr.append(a[i] - a[0])
    for i in range(n):
        arr.append(-w[i])
    
    g = arr[0]
    for v in arr:
        g = gcd(g, v)

    assert g == 1
    
    s = int(36 - b * b - a[0] * m_sum^2)
    assert s % 2 == 0
    
    mat.append(arr)
    vec.append(s // 2)

mat = Matrix(Zmod(q // 2), mat)
vec = vector(Zmod(q // 2), vec)

ans = mat.solve_right(vec)
flag, p = 0, 1
for v in ans[n // 2:]:
    if v == 0:
        flag += p
    elif v == 1:
        flag += 2 * p
    p *= 3

print(long_to_bytes(flag))
    