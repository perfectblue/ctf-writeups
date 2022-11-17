from pwn import *
import intervals as I
import random
from Crypto.Util.number import *

proc = remote('this-is-not-lsb.seccon.games', 8080)

proc.recvuntil(b' = ')
n = int(proc.recvline().decode().strip())
proc.recvuntil(b' = ')
e = int(proc.recvline().decode().strip())
proc.recvuntil(b' = ')
flag_length = int(proc.recvline().decode().strip())
proc.recvuntil(b' = ')
c = int(proc.recvline().decode().strip())

padding_pos = n.bit_length() - 2

LOWER_BOUND = 0xFF << (padding_pos - 8)
UPPER_BOUND = (0x100 << (padding_pos - 8)) - 1

def ceil(a, b): return  a // b + (a % b > 0)
def floor(a,b): return  a // b

st = ceil(LOWER_BOUND, 1 << flag_length)
ed = floor(UPPER_BOUND, 1 << (flag_length - 1))

def oracle(c):
    proc.sendlineafter(b'c = ', str(c).encode())
    l = proc.recvline()
    if b'False' in l:
        return False
    else:
        return True

while True:
    t = random.randint(st, ed)
    c2 = c * pow(t, e, n) % n
    if oracle(c2):
        break

wow = t
ed = wow

while st < ed:
    print(ed - st)
    md = (st + ed) // 2
    c2 = c * pow(md, e, n) % n
    if oracle(c2):
        ed = md
    else:
        st = md + 1

print(st)
print(LOWER_BOUND // st)
print(long_to_bytes(LOWER_BOUND // st))