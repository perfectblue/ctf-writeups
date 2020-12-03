from pwn import *
import string
import itertools
import hashlib
import json
import random
import base64

# context.log_level = 'debug'
do_local = False

def connect():
    if not do_local:
        r = remote('54.178.3.192', 9427)
        r.recvuntil('+')
        suffix = r.recv(16)
        r.recvuntil(' == ')
        target = r.recv(64).decode()
        r.recvuntil('Give me XXXX:')

        for x in itertools.product(string.ascii_letters + string.digits, repeat=4):
            if hashlib.sha256(''.join(x).encode() + suffix).hexdigest() == target:
                r.sendline(''.join(x))
                break
    else:
        r = process(['python3', './prob.py'])
    
    return r

r = connect()

r.recvuntil('cmd: ')
r.sendline('register')
r.recvuntil('name: ')
r.sendline('test')

enc = json.loads(base64.b64decode(r.recvuntil('\n')[8:-1]).decode())['cipher']
iv, enc = bytearray.fromhex(enc[:32]), bytes.fromhex(enc[32:64])

def pad(s):
    pad_len = 16-len(s)%16
    return s+chr(pad_len)*pad_len

target = pad('{"cmd":"get_secret","who":"admin","name":"admin","a":"aaaaaa"}')

first_part = 'on{JSON_is_5", "'
for i in range(16):
    iv[i] ^= ord(first_part[i]) ^ ord(target[i])

normal_chars = []
for i in range(32, 128):
    res = json.dumps(chr(i))
    if res == '"{}"'.format(chr(i)):
        normal_chars.append(i)

normal_chars = set(normal_chars)

for i in range(len(enc), len(target), 16):
    print(i)
    count = 0
    while True:
        count += 1
        print(i, count)
        # To change IV 
        r.recvuntil('cmd: ')
        r.sendline('register')
        r.recvuntil('name: ')
        r.sendline('a' * 9)

        enc_ = json.loads(base64.b64decode(r.recvuntil('\n')[8:-1]).decode())['cipher']
        iv_, enc_ = bytearray.fromhex(enc_[96:128]), bytes.fromhex(enc_[128:160])

        iv_[0] ^= ord('"') ^ ord('{')

        r.recvuntil('cmd: ')
        r.sendline('login')
        r.recvuntil('token: ')
        res = base64.b64encode(json.dumps({'cipher': enc_.hex(), 'iv': iv_.hex()}).encode()).decode()
        r.sendline(res)

        # Now let's try
        r.recvuntil('cmd: ')
        r.sendline('register')
        r.recvuntil('name: ')
        r.sendline('a' * 9 + 'a' * 1600000)

        enc_ = json.loads(base64.b64decode(r.recvuntil('\n')[8:-1]).decode())['cipher']
        enc_ = bytes.fromhex(enc_[96:])

        for k in range(100000):
            pt, is_pos = "", True
            for j in range(16):
                if enc_[16 * k + j] ^ ord(target[i + j]) ^ enc[i + j - 16] not in normal_chars:
                    is_pos = False
                    break
                
                pt += chr(enc_[16 * k + j] ^ ord(target[i + j]) ^ enc[i + j - 16])

            if is_pos:
                break
        
        if not is_pos:
            continue

        r.recvuntil('cmd: ')
        r.sendline('register')
        r.recvuntil('name: ')
        r.sendline('a' * 9 + 'a' * (k * 16) + pt)

        enc_ = json.loads(base64.b64decode(r.recvuntil('\n')[8:-1]).decode())['cipher']
        enc += bytes.fromhex(enc_[128 + k * 32:160 + k * 32])

        print(iv.hex(), enc.hex())
        break

r.recvuntil('cmd: ')
r.sendline('login')
r.recvuntil('token: ')
res = base64.b64encode(json.dumps({'cipher': enc.hex(), 'iv': iv.hex()}).encode()).decode()
r.sendline(res)

r.interactive()
