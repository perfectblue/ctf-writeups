from pwn import *
from sage.all import *

def get_matrix(proc):
    ans = []
    for i in range(6):
        x = proc.recvline().strip("\n []")
        ans.append(map(int, x.split(", ")))
    return ans

proc = remote('13.231.224.102', 3002)

proc.recvline()

flag = get_matrix(proc)
p = int(proc.recvline().strip().split()[-1])

print flag

R = IntegerModRing(p)

curr_pow = 1
ans = Matrix(R, matrix.zero(6))

for b in range(0, 512, 8):
    print b
    curr = [0 for i in range(36)]
    for i in range(6):
        for j in range(6):
            curr[i*6 + j] = (flag[i][j] >> b) % 256
    proc.recvuntil("> ")
    proc.sendline("2")
    proc.recvuntil("Data: ")
    payload = b64e(''.join(map(chr, curr)))
    proc.sendline(payload)
    proc.recvline()
    resp = Matrix(R, get_matrix(proc))
    ans += 2**b * resp

print ans

sice = ''
for i in range(6):
    for j in range(6):
        sice += chr(int(ans[i][j]))

print sice

# zer0pts{r1ng_h0m0m0rph1sm_1s_c00l}
