# leaky block cipher

The challenge implements AES-GCM.

There are total 20 stages, and for each stage, it'll give you IV and you can put your own plaintext, then it'll encrypt it with AES-GCM give you the auth tag. After that, it will give the AES-encrypted value if IV except the last nibble, and ask the value of the last nibble.

```py
class LeakyBlockCipher:
    def __init__(self, key = None):
        if key is None:
            key = secrets.token_bytes(16)
        self.key = key
        self.aes = AES.new(key, AES.MODE_ECB)
        self.H = self.aes.encrypt(bytes(16))
    def encrypt(self, iv, data):
        assert len(iv) == 16
        assert len(data) % 16 == 0
        ivi = int.from_bytes(iv, "big")
        cip = bytes()
        tag = bytes(16)
        for i in range(0,len(data),16):
            cntr = ((ivi + i // 16 + 1) % 2**128).to_bytes(16, byteorder="big")
            block = data[i:i+16]
            enced = self.aes.encrypt(xor(cntr, block))
            cip += enced
            tag = xor(tag, enced)
            tag = gf128(tag, self.H)
        tag = xor(tag, self.aes.encrypt(iv))
        return cip, tag
```

Because we know the IV value, we can make `xor(cntr, block)` to 0 easily, then `enced` will be same as `self.H`.

Therefore, we can get `H^k + H^{k-1} + ... + H + enc(iv)` as the tag. It can be written as `(H^{k+1} + 1) / (H + 1) + 1 + enc(iv) = tag`.

We tried some brute-force with polynomials `X * x^k + tag * x + tag + X` for `X = tag + part of enc(iv)`. It seems `k = 256` usually have 1~2 roots. So we write the solver like this:

`solver.sage`:
```py
print("start")
F.<x> = GF(2)[]
G = GF(2^128, name='a', modulus=x^128+x^7+x^2+x+1)
R.<t>=PolynomialRing(F)

while True:
    tag = G.fetch_int(int(input("tag = "), 16))
    partial = G.fetch_int(int(input("partial enc iv = "), 16) << 4)
    ans = []

    for i in range(16):
        X = G.fetch_int(i) + partial
        f = X * t^256 + tag * t + tag + X

        if len(f.roots()) > 1:
            ans.append(i)
    print(ans)
```

`solver.py`:
```py
from pwn import *
import subprocess
import random

context.log_level = 'debug'

r2 = process(['sage', 'solver.sage'])

while True:
    r = remote('leaky.pwni.ng', 1337)
    target = r.recvuntil('\n').strip().decode()
    t = subprocess.check_output(['hashcash', '-mb21', target])
    r.send(t)

    for _ in range(20):
        r.recvuntil('iv = ')
        iv = bytes.fromhex(r.recv(32).decode())
        ivi = int.from_bytes(iv, "big")

        pt = b''
        for i in range(256 - 1):
            pt += ((ivi + i + 1) ^ ivi).to_bytes(16, byteorder="big")

        r.recvuntil('plaintext = ')
        r.sendline(pt.hex())

        r.recvuntil('tag = ')
        tag = r.recv(32).decode()
        r.recvuntil('It looks like  ')
        enc_iv_partial = r.recv(31).decode()

        r2.sendlineafter('tag = ',tag)
        r2.sendlineafter('partial enc iv = ',enc_iv_partial)
        ans = eval(r2.recvline().decode().strip())
        ans = random.choice(ans)
        r.sendline(f"{ans:x}")

        r.recvline()
        if b'Sorry,' in r.recvline():
            break
        
        if _ == 19:
            exit(0)
    
    r.close()
```

The flag is `PCTF{you_found_the_residues!_db2f6ade22d73a90b15e8d1b06167393}`.