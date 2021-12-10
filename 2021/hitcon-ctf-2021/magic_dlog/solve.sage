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
        data2 = sha384(data).digest()
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
        if pow(num1, res, N) == num2:
            return data, N, res

# while True:
#     magic = os.urandom(LEN)
#     if magic[0] < 128:
#         continue
#     magic_num = bytes_to_long(magic)
#     print(magic)
#     print(solve(magic_num))

while True:
    r = remote('35.72.139.70', 31338)
    r.recvuntil(b'Magic: ')
    magic_num = int(r.recvline().strip(), 16)

    res = solve(magic_num)
    if res is None:
        r.close()
        continue

    data, N, E = res
    r.sendlineafter(b'P:>', str(N).encode())
    r.sendlineafter(b'E:>', str(E).encode())
    r.sendlineafter(b'data:>', data.hex().encode())
    r.interactive()

    break
