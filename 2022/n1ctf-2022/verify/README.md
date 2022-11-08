# Verify

I found out that there's a custom module named `nu1l` inside the binary.
By setting breakpoints on the functions `do1`, `do2` and `key`,
I could find out that it's doing RC4 encryption.

After reading the yara code a bit, I also found out that it's running with some kind of VM
defined in `exec.c`. I could search opcodes of calling functions, and then I found the opcodes
that compare the encrypted result and some constants.

So I could recover the flag:
```py
from ctypes import *

lib = CDLL("api-ms-win-crt-utility-l1-1-0.dll")
rand, srand = lib.rand, lib.srand

with open("n1Verify", "rb") as f:
    key = int.from_bytes(f.read(4), 'little')
    data = f.read()

srand(key)
data = bytes(v ^ (rand() & 0xFF) for v in data)

for _ in range(9):
    rand()

S = list(range(256))
j = 0
for i in range(256):
    res = rand() & 0xFF
    j = (j + S[i] + res) & 0xFF
    S[i], S[j] = S[j], S[i]

i, j = 0, 0
stream = []
for _ in range(32):
    i = (i + 1) % 256
    j = (j + S[i]) % 256
    S[i], S[j] = S[j], S[i]
    stream.append(S[(S[i] + S[j]) % 256])

output = [data[0x66F + 0x1F * i] for i in range(32)]
res = [x ^ y for x, y in zip(stream, output)]
res = [res[i] ^ i for i in range(32)]
print(bytes(res))
```

The flag is `n1ctf{6d1b9556e048a4f8d30c2857c25ea8c6}`.