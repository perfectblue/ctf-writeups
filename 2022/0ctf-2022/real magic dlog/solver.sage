import os
from Crypto.Util.number import *
from hashlib import *
from binascii import unhexlify
from tqdm import tqdm
from pwn import *

LEN = 17
def solve(magic_num):
    best = (2 ** 100, -1)
    
    BF_LEN = 16
    for v in tqdm(range(2 ** BF_LEN)):
        N = (magic_num * 2 ** BF_LEN + v) << (384 - LEN*8 - BF_LEN)
        N += 1
        
        if not is_prime(N):
            continue
        
        t = max(map(lambda x: x[0], factor(magic_num * 2 ** BF_LEN + v)))
        if t < best[0]:
            print("Best:", t, int(t).bit_length())
            best = (t, N)
    
    _, N = best
    factors = factor(N - 1)

    for _ in tqdm(range(5000)):

        data = os.urandom(384 // 8)
        data2 = sha384(data.hex().encode()).digest()
        num1 = bytes_to_long(data)
        num2 = bytes_to_long(data2)

        if num2 >= N:
            continue

        flag = True
        crts = [[], []]
        for p, count in factors:
            rem = (N - 1) // p^count
            n1 = pow(num1, rem, N)
            n2 = pow(num2, rem, N)

            try:
                ans = discrete_log(n2, n1, p^count)
                crts[0].append(int(ans))
                crts[1].append(p^count)
            except:
                flag = False
                break
        
        if not flag:
            continue
        
        res = crt(crts[0], crts[1])
        if pow(num1, res, N) == num2 % N:
            print(f"{num1=}")
            print(f"{num2=}")
            print(f"{res=}")
            print(f"{N=}")
            return data, N, res

#sha256(XXXX + !N6gvJQyeg&QXPhb) == 18742ecd74771d44704d23f64f06abb2daa8e319d0c4eec7c3e9e9f51ac6130f
from hashlib import sha256
from itertools import product
import string
alphabet = (string.ascii_letters + string.digits + '!#$%&*-?').encode()
def solve_pow(r):
    pow = r.recvlineS().strip()
    rest, target = pow.split(" == ")
    suffix = rest.split(" + ")[1][:-1].encode() # skip last parens
    for prefix in product(alphabet, repeat=4):
        if sha256(bytes(prefix)+suffix).hexdigest() == target:
            print("Solved PoW")
            r.sendlineafter(b'Give me XXXX:', bytes(prefix))
            _ = r.recvline()
            return
    else:
        assert False, "PoW failed?"

while True:
    r = remote('202.120.7.219', 15555)
    # r = remote('10.0.0.8', 15555)
    solve_pow(r)
    magic_num = int(r.recvlineS().strip(), 16)

    res = solve(magic_num)
    if res is None:
        r.close()
        continue

    data, N, E = res
    print(N, E, data.hex(), )
    r.sendlineafter(b'P:>', hex(N).encode())
    r.sendlineafter(b'E:>', hex(E).encode())
    r.sendlineafter(b'data:>', data.hex().encode())
    r.interactive()

    break
