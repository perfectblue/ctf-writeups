import subprocess
from binascii import a2b_base64
from math import ceil
from braindead import *
from tt import attack2
log.enable()

N = 2048

def solve_pow(r):
    pw = r.rla('sha256').decode().strip().replace('+',' + ').split()
    suff = pw[2][:-1]
    h = pw[-1]
    sol = subprocess.check_output(['./pow', '4', suff, h])
    r.sla('Give me XXXX:', sol[:4])

def v2s(v):
    N = len(v)
    x = 0
    for i in range(N):
        x += v[N-1-i]<<i
    s = x.to_bytes(N//8, 'big')
    assert s2v(s) == v
    return s

def s2v(s):
    return list(map(int, bin(int.from_bytes(s, 'big'))[2:].ljust(N, '0')))

def bnorm(x):
    x = int(x)
    if x > 2**63:
        return x - 2**65
    else:
        return x

def auth_for_passwd(x):
    n = len(x)
    y = [0]*n
    for i in range(n):
        y[(n-i)%n] = x[i]
    for i in range(1, n):
        y[i] ^= 1
    return y

def recov(leak):
    conv = [bnorm(x) for x in leak]
    recov = []
    for i in range(N):
        x = conv[i]
        if i+1 < N:
            y = conv[i+1]
        else:
            y = conv[0]
            x = -x
        if x > y:
            recov.append(1)
        else:
            recov.append(0)
    recov = recov[-1:] + recov[:-1]
    return recov

args = Args()
args.add('RHOST', default='127.0.0.1')
args.parse()

r = io.connect((args.RHOST, 13337))

solve_pow(r)

r.sla('> ', '1')
r.sla('Password: ', '00'*256)

leakb = r.rla('invalid data ').decode()
leakb = a2b_base64(leakb)
leak = []
for i in range(N):
    leak.append(int.from_bytes(leakb[i*8:i*8+8], 'big'))
with open('leak.py', 'w') as f:
    print(f'{leak=:}', file=f)

usr_passwd = recov(leak)
usr_auth = auth_for_passwd(usr_passwd)
with open('0ctf-player.recov', 'w') as f:
    print(*usr_passwd, sep='', file=f)

r.sla('> ', '1')
r.sla('Password: ', v2s(usr_auth).hex())
r.rla("Welcome")

r.sla('> ', '2')
#r.sla('Password: ', '00'*256)

leakb = r.rla('invalid data ').decode()
leakb = a2b_base64(leakb)
leak = []
for i in range(N):
    leak.append(int.from_bytes(leakb[i*8:i*8+8], 'big'))
with open('leak.py', 'w') as f:
    print(f'{leak=:}', file=f)

adm_passwd = attack2(leak)
adm_auth = auth_for_passwd(adm_passwd)
with open('0ctf-admin.recov', 'w') as f:
    print(*adm_passwd, sep='', file=f)

r.sla('Reset your password?', 'Y')
r.sla('Password: ', v2s(adm_auth).hex())

r.sla('> ', '2')

io.interactive(r)
