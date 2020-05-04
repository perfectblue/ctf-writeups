# Jiahui Chen et al. cryptosystem, 80-bit security
# WARNING: very slow implementation.
import sys
q,n,a,s = (3,59,10,25)
m = n+1-a+s
FF = GF(q)
R = PolynomialRing(FF, ["x{}".format(i) for i in range(n)])
xs = R.gens()

def keygen():
    while True:
        C = random_matrix(FF, n+1, n)
        if matrix(FF, [2*C[i]-2*C[i+1] for i in range(n)]).is_invertible():
            break

    FC = []
    for i in range(n+1):
        p = 0
        for j in range(n):
            p += (xs[j] - C[i][j])^2
        FC.append(p)

    while True:
        S_lin = random_matrix(FF, n, n)
        if S_lin.is_invertible():
            break
    S_trans = (FF^n).random_element()
    S = (S_lin, S_trans)

    while True:
        T_lin = random_matrix(FF, m, m)
        if T_lin.is_invertible():
            break
    T_trans = (FF^m).random_element()
    T = (T_lin, T_trans)

    G = []
    for i in range(s):
        G.append(R.random_element(degree=2, terms=Infinity))
    F = FC[:n+1-a] + G

    P = vector(xs)
    P = S[0]*P
    P += S[1]
    v = []
    for i in range(len(F)):
        v.append(F[i](*P))
        print("keygen {}/{}".format(i+1,len(F)))
    P = vector(v)
    P = T[0]*P
    P += T[1]
    print("done keygen")

    return (P, (C, G, S, T))

def make_blocks(ss):
    x = 0
    for i in ss:
        x = x*256+ord(i)
    v = []
    while x > 0:
        v.append(FF(x%q))
        x = x//q
    v += [FF(0) for i in range(n - (len(v) % n))]
    blocks = []
    for i in range(0, len(v), n):
        blocks.append(vector(v[i:i+n]))
    return blocks

def combine_blocks(blocks):
    x = 0
    for i in blocks[::-1]:
        for j in i[::-1]:
            x = x*q+Integer(j)
    ss = ""
    while x > 0:
        ss = chr(x % 256) + ss
        x = x//256
    return ss

def encrypt_block(plain, pk):
    return vector([pk[i](*plain) for i in range(m)])

def encrypt(plain, pk):
    blocks = make_blocks(plain)
    enc = []
    for i in range(len(blocks)):
        print("encrypt {}/{}".format(i+1,len(blocks)))
        enc.append(encrypt_block(blocks[i], pk))
    return enc

def decrypt_block(cipher, sk):
    C, G, S, T = sk
    C2I = matrix(FF, [2*C[i]-2*C[i+1] for i in range(n)]).inverse()
    cv = []
    for i in range(n):
        cc = 0
        for j in range(n):
            cc += C[i+1][j]^2 - C[i][j]^2
        cv.append(cc)
    cv = vector(cv)
    g1 = T[0].inverse()*(cipher - T[1])
    for g2 in FF^a:
        print("decrypt: trying:", g2)
        g = vector(list(g1)[:n+1-a]+list(g2))
        g_diff = vector([g[i+1]-g[i] for i in range(len(g)-1)])
        d = C2I * (g_diff-cv)
        for i,j in zip(G,g1[n+1-a:]):
            if i(*d) != j:
                break
        else:
            return S[0].inverse() * (d - S[1])

def decrypt(cipher, sk):
    dec = []
    for i in range(len(cipher)):
        print("decrypt {}/{}".format(i+1,len(cipher)))
        dec.append(decrypt_block(cipher[i], sk))
    return combine_blocks(dec)

output = open("output", "rb").read().decode('utf-8').strip().split("\n")
for i in range(n)[::-1]:
    output[0] = output[0].replace("x{}".format(i), "xs[{}]".format(i))
output[0] = output[0].replace("^", "**")
pk = eval(output[0])
flag_cipher = [(2, 1, 1, 1, 2, 2, 0, 2, 0, 0, 0, 0, 0, 2, 1, 2, 2, 1, 0, 0, 1, 2, 0, 2, 0, 2, 1, 0, 2, 0, 1, 2, 2, 1, 0, 1, 2, 0, 2, 1, 0, 2, 0, 0, 2, 0, 0, 2, 0, 2, 0, 1, 2, 0, 0, 2, 2, 1, 1, 0, 1, 0, 2, 1, 2, 2, 1, 0, 1, 1, 2, 0, 1, 0, 2), (0, 1, 1, 1, 1, 2, 2, 0, 2, 0, 1, 2, 1, 1, 0, 2, 2, 1, 0, 0, 0, 2, 0, 2, 2, 0, 1, 2, 1, 1, 2, 1, 1, 0, 2, 1, 2, 1, 2, 2, 1, 2, 0, 1, 1, 0, 0, 2, 1, 0, 1, 2, 0, 2, 0, 0, 0, 0, 2, 1, 2, 0, 1, 1, 1, 1, 2, 0, 0, 0, 2, 1, 0, 2, 1), (2, 2, 0, 0, 1, 1, 0, 2, 2, 2, 1, 2, 2, 2, 0, 0, 0, 1, 2, 1, 1, 2, 0, 2, 1, 2, 0, 1, 0, 2, 1, 0, 2, 0, 1, 2, 1, 0, 0, 0, 0, 1, 0, 2, 2, 1, 0, 2, 0, 2, 2, 0, 2, 2, 1, 1, 0, 2, 0, 1, 1, 1, 1, 2, 1, 2, 1, 2, 0, 1, 1, 1, 0, 1, 2), (2, 0, 0, 2, 2, 2, 2, 0, 1, 2, 2, 2, 0, 0, 1, 0, 2, 2, 0, 2, 2, 1, 0, 0, 1, 1, 2, 0, 2, 0, 2, 0, 1, 0, 1, 0, 2, 1, 2, 2, 2, 0, 1, 1, 0, 2, 0, 0, 1, 0, 2, 1, 2, 2, 1, 1, 1, 0, 1, 2, 2, 1, 2, 1, 2, 0, 0, 1, 2, 0, 1, 1, 0, 2, 1), (0, 0, 2, 1, 0, 2, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 2, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 2, 0, 1, 1, 0, 2, 1, 0, 1, 2, 2, 1, 0, 1, 2, 2, 1, 2, 0, 1, 0, 1, 0, 0, 1, 0, 2, 2, 0, 1, 2, 2, 2, 0, 2, 2, 0, 1, 0, 2, 0, 0, 0, 2, 0, 2, 1, 1), (0, 0, 2, 0, 0, 1, 1, 2, 1, 0, 2, 2, 2, 2, 0, 0, 0, 1, 2, 1, 0, 1, 1, 0, 2, 0, 2, 2, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 2, 2, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 0, 2, 1, 1, 2, 2, 1, 2, 1, 0, 2, 0, 0, 1, 2, 1, 1, 0)]
print(len(pk))
print(len(flag_cipher))

flag = "PCTF{the_quick_brown_fox}"
# ciph = encrypt(flag, pk)
ciph = [(2, 1, 1, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 1, 2, 0, 2, 0, 0, 0, 1, 0, 1, 0, 2, 2, 1, 1, 0, 2, 2, 2, 1, 2, 0, 1, 2, 1, 0, 2, 1, 2, 2, 0, 2, 0, 1, 0, 2, 0, 2, 1, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 1, 0, 2, 0, 0, 0, 1, 1, 2, 1), (2, 2, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 2, 0, 2, 2, 2, 1, 2, 0, 2, 2, 2, 1, 2, 1, 1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2, 0, 0, 1, 1, 0, 0, 2, 2, 1, 1, 2, 0, 0, 2, 0, 2, 0, 0, 2, 0), (2, 0, 0, 2, 0, 0, 0, 1, 0, 2, 1, 2, 2, 1, 2, 1, 1, 0, 2, 1, 1, 1, 2, 0, 2, 0, 1, 1, 1, 0, 0, 2, 2, 2, 1, 0, 2, 1, 1, 2, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 2, 0, 0, 2, 1, 1, 0, 2, 1, 1, 2, 1, 0, 0, 1, 2, 2, 1, 2, 2, 2, 1, 0, 0, 1)]
ciph = flag_cipher
block_id = 5
print(ciph)
print(len(ciph))

eqns = [[0 for j in range(m)] for i in range(n*n)]

for i in range(m):
    for x_i in range(n):
        for x_j in range(n):
            eqns[x_i*n + x_j][i] = pk[i].monomial_coefficient(xs[x_i]*xs[x_j])

part1_mat = Matrix(FF, eqns)
kernel_basis = part1_mat.right_kernel(basis='pivot')
print("Basis:", kernel_basis)
sample_basis = kernel_basis.basis()

R = []
for i in range(n-a):
    curr = 0
    for j in range(m):
        curr += sample_basis[i][j] * pk[j]
    R.append(curr)

R_right = []
for i in range(n-a):
    curr = 0
    for j in range(m):
        curr += sample_basis[i][j] * ciph[block_id][j]
    R_right.append(curr)

R_right_adj = []

R_mat_arr = []
for i in range(n-a):
    curr = []
    for j in range(n):
        curr.append(R[i].monomial_coefficient(xs[j]))
    R_right_adj.append(R_right[i] + FF(-R[i].constant_coefficient()))
    R_mat_arr.append(curr)


FUCKME = 12

R_mat = Matrix(FF, R_mat_arr)
soln = R_mat.augment(vector(R_right_adj)).echelon_form()
R_sice = PolynomialRing(FF, ["sice{}".format(i) for i in range(FUCKME)])
sices = R_sice.gens()
print(soln)

eqns = []

for i in range(n-FUCKME):
    curr = 0
    for j in range(FUCKME):
        curr += soln[i][j+n-FUCKME] * sices[j]
    curr = soln[i][n] - curr
    eqns.append(curr)

for j in range(FUCKME):
    eqns.append(sices[j])

poly_subs = {}
for i in range(n):
    poly_subs[xs[i]] = eqns[i]
new_poly = [pk[i].subs(poly_subs) for i in range(m)]

# ptxt_block = make_blocks(flag)[1]
# print ptxt_block
# print repr(combine_blocks([ptxt_block]))
# import ipdb
# ipdb.set_trace()

ctr = 0
for trial in FF**FUCKME:
    if ctr % 1000 == 0:
        print(ctr)
    ctr += 1
    corr = True
    for i in range(m):
        if new_poly[i](*trial) != ciph[block_id][i]:
            corr = False
            break
    if corr:
        ans = [eqns[i](*trial) for i in range(n)]
        print(ans)
        break
