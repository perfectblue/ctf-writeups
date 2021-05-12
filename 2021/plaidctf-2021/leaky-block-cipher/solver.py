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
