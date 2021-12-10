import os
from Crypto.Util.number import *
from hashlib import *
from binascii import unhexlify
from tqdm import tqdm
from pwn import *

LEN = 17
def solve(magic_num):
    best = (100, -1)
    for v in range(2 ** 8):
        t = magic_num * 2 ** 8 + v
        t = list(factor(t))
        cnt = 0
        for p, _ in t:
            tmp = p - 1
            while tmp % 2 == 0:
                cnt += 1
                tmp >>= 1
        t = max(map(lambda x: x[0], t))

        if int(t).bit_length() <= 60 and cnt < best[0]:        
            best = cnt, v
            print(v, int(t).bit_length(), cnt)

    N = (magic_num * 2 ** 8 + best[1]) << (384 - LEN*8 - 8)
    factors = list(factor(N))

    for _ in tqdm(range(5000)):

        data = os.urandom(384 // 8)
        data2 = sha384(data).digest()
        num1 = bytes_to_long(data)
        num2 = bytes_to_long(data2)

        if num2 >= N or GCD(num1, N) != 1 or GCD(num2, N) != 1:
            continue

        flag = True
        crts = [[], []]
        for p, count in factors:
            F = Zmod(p ^ count)
            try:
                ans = F(num2).log(F(num1))
                crts[0].append(int(ans))
                crts[1].append(p^(count - 1) * (p - 1))
            except:
                flag = False
                break
        
        if flag:
            try:
                res = crt(crts[0], crts[1])
                mod = lcm(crts[1])
                print("FOUND")
                while res < N:
                    if pow(num1, res, N) == num2:
                        print(pow(num1, res, N))
                        print(num1)
                        print(num2)
                        print(N)
                        print(res)
                        return data, N, res
                    res += mod
            except:
                pass

# while True:
#     magic = os.urandom(LEN)
#     magic_num = bytes_to_long(magic)
#     print(magic)
#     print(solve(magic_num))

while True:
    r = remote('35.72.139.70', 31337)
    r.recvuntil(b'Magic: ')
    magic_num = int(r.recvline().strip(), 16)

    res = solve(magic_num)
    if res is None:
        r.close()
        continue
    
    data, N, E = res
    r.sendlineafter(b'N:>', str(N).encode())
    r.sendlineafter(b'E:>', str(E).encode())
    r.sendlineafter(b'data:>', data.hex().encode())
    r.interactive()

    break
