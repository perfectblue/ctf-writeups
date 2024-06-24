# Ilovecrackmes

Solved by: Riatre, cts

Remote gives you a ciphertext and public key under Paillier cryptosystem, you need to send back a new ciphertext that has "ilovecrackmes" added to it

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/9d0a3782-9bd6-40dc-9e91-799451cf0865)

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/b2c2204d-e586-4df1-b0d5-5aa64ea1808e)


```py
from pwn import *

context.log_level = "debug"

# io = process("./chal")
io = remote("ilovecrackmes.2024.ctfcompetition.com", 1337)
io.recvuntil(b"disabled ==\n")
g_str, c_str = io.recvline().decode().split(":")
g, c = int(g_str, 16), int(c_str, 16)
n = g - 1
r = 998244353  # whatever

new_m = int.from_bytes(b"ilovecrackmes", "big") * 2**32
c2 = pow(g, new_m, n * n) * pow(r, n, n * n) % (n * n)

new_c = c * c2 % (n * n)
# gdb.attach(io)
io.sendlineafter(b"> ", f"{new_c:X}")
io.interactive()
```
