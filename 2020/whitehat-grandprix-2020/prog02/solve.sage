from pwn import *
from sage.all import *

def conv(i, j):
    return i * 3 + j

a = []

for i in range(4):
    for j in range(3):
        curr = []
        for k in range(4):
            for l in range(3):
                if (abs(i-k) == 2 and abs(j-l) == 1) or (abs(i-k) == 1 and abs(j-l) == 2):
                    curr.append(1)
                else:
                    curr.append(0)
        a.append(curr)

mod_num = 10**39

print a
M = Matrix(IntegerModRing(mod_num), a)

flag = ''

proc = remote('15.165.30.141', 9399)
while True:
    proc.recvuntil("n = ")
    curr_n = int(proc.recvline().strip())
    sice = M**(curr_n-1)

    ans = 0

    for j in range(12):
        ans += sice[conv(3, 0)][j]
        ans += sice[conv(2, 1)][j]
        ans += sice[conv(3, 2)][j]

    ans = ans % mod_num
    print ans
    proc.recvuntil("Answer: ")
    proc.sendline(str(ans))
    reward = proc.recvline().strip()
    print reward
    flag += reward[-1]
    print flag

# WhiteHat{S0_many_p4ssw0rd_uhuhu_giveup_already_:<}
