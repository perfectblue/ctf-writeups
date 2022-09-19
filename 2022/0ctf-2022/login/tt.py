#from sage.all import *
import numpy as np
from scipy.linalg import solve_toeplitz, toeplitz, solve

def fit_line(y):
    d = 0
    for i in range(1, len(y)):
        d += y[i]-y[i-1]
    d //= len(y)-1
    return d

def load_v(fname):
    with open(fname, 'r') as f:
        s = f.read().strip()
    return [int(b)*2-1 for b in s]

def shift(x): return [ -x[-1], *x[:-1] ]

def mul(a, b):
    out = [0]*2048
    for i in range(2048):
        for j in range(2048):
            out[j] += a[i]*b[j]
        b = shift(b)
    return out

#for i in range(1, len(x)):
#    print(x[i])

def decode(vals):
    m = max(vals)
    vals = [x if x < 2**62 else x-1-m for x in vals]

    xs = vals[:]
    xs.sort()

    cnt = 0
    avg = 0

    clusters = []
    for i in range(0, len(xs)):
        if i > 0:
            gap = xs[i] - xs[i-1]
            #print(gap)
            #        8923383622288646
            #        19026552261133
            #       -22696370656015
            if gap > 100000000000000:
                clusters.append(avg//cnt)
                avg = 0
                cnt = 0
        cnt += 1
        avg += xs[i]
            
    clean_clusters = clusters[len(clusters)*1//3:len(clusters)*2//3]
    g = fit_line(clean_clusters)
    o = min(clusters, key=abs)
    #print(o)

    with open('/tmp/p', 'w') as f:
        for x in clusters:
            i = int(round(x/g))
            print(x, i*g+o, i, file=f)

    out = []
    for x in vals:
        i = int(round(x/g))
        #e = i*g+o
        #print(x - e)
        out.append(i*2)

    #print(max(x))
    return out

def attack2(leak):
    conv = decode(leak)

    usr = load_v('0ctf-player.recov')

    usr_matrix = []
    tmp = usr
    for i in range(2048):
        usr_matrix.append(tmp)
        tmp = shift(tmp)

    if 1:
        c = np.array(usr_matrix[0], dtype=np.float64)
        r = np.array([usr_matrix[i][0] for i in range(2048)], dtype=np.float64)
        rhs = np.array(conv, dtype=np.float64)
        #print([usr_matrix[i][0] for i in range(2048)])
        #sol = solve_toeplitz((c, r,), rhs)
        t = toeplitz(c, r)
        sol = solve(t, rhs)
        sol = list(np.round(sol).astype(np.int32))
        #assert sol == adm
        return [(int(x)+1)//2 for x in sol]

    if 0:
        print(max(conv, key=abs))
        F = GF(next_prime(2**32))
        usr_matrix = matrix(F, usr_matrix)
        conv_col = column_matrix(F, conv)
