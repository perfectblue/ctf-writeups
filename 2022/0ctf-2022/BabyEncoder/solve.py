from pwn import *
import struct
import numpy as np

context.log_level = 'DEBUG'

r = remote('202.120.7.212', 20001)

r.recvuntil(b'2^(2^')
v = int(r.recvuntil(b') mod ')[:-6].decode())
m = int(r.recvuntil(b' ')[:-1].decode())
print(v, m)

res = pow(2, 2 ** v, m)

r.sendlineafter(b'answer: ', str(res).encode())

r.recvuntil(b'========START=======\n')
res = b''
while len(res) < 0x2000:
    res += r.read(0x2000 - len(res))

res = [struct.unpack('<d', res[i:i+8])[0] for i in range(0, 0x2000, 8)]

ans = []
for i in range(0, 0x400, 128):
    fft_res = np.fft.ifft(res[i:i+128])
    for j in range(8):
        ans.append(round(abs(fft_res[j + 1]) + abs(fft_res[-j - 1])))

ans = bytes(ans)

r.recvuntil(b'=========END========\n')
r.send(ans)

r.interactive()