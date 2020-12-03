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

admin_token = b"eyJjaXBoZXIiOiAiOGQ1YzFmNmE3ODliODJiM2I2NTBlZjJiYjAxNDE5YjQzN2UwMzM1NmQxNTljMGZiMjVlMGQxZTRiYWM4ZGUyNjA1NWVhZjEzODg4NjJmMGMzZDUxYmQ3NDZlNWZhOTVkYTZmNmVjYzkxZmU3NzZiMDc2M2YzZjgwNmQ0NDRlMDU0NzEyOGM4ZjZkZjc5MzRhMzUwNjM0NjM5MjE5NDkyY2I3YmMzMzcxYTc5NDk2YmIwZjQyZmZkMDM2MmE2MjNhYWYxZGY2ZWFhNmYyMDU2Zjk0ODkwNDA2M2I5NTRlNGEifQ=="
admin_token = json.loads(base64.b64decode(admin_token).decode())['cipher']
iv, enc = bytearray.fromhex(admin_token[128:160]), bytes.fromhex(admin_token[160:])

iv[0] ^= ord('"') ^ ord('{')
iv[1] ^= ord('0') ^ ord('"')
iv[2] ^= ord('_') ^ ord('"')
iv[3] ^= ord('w') ^ ord(':')
iv[4] ^= ord('o') ^ ord('"')

r = connect()

test = ' {"":"aaaaaaaaaaa}"}'

flag = '0_woNderFul!@##'
for i in range(len(flag) - 4, 11):
    dic = dict()
    to_pick = list(range(1, 128))
    while True:
        tmp = random.choice(to_pick)
        to_pick.remove(tmp)
        print('trying', i, tmp)

        iv[5 + i] ^= tmp
        r.recvuntil('cmd: ')
        r.sendline('login')
        r.recvuntil('token: ')
        res = base64.b64encode(json.dumps({'cipher': enc.hex(), 'iv': iv.hex()}).encode()).decode()
        r.sendline(res)
        iv[5 + i] ^= tmp

        try:
            r.recvuntil('\n')
            dic[tmp] = True
        except:
            dic[tmp] = False
            r = connect()

        print('res', i, tmp, dic[tmp])
        
        pos_chars = []
        for pos_char in range(1, 128):
            is_pos = True
            for xor, tf in dic.items():
                test = test[:5 + i] + chr(pos_char ^ xor) + test[6 + i:]
                try:
                    json.loads(test)
                    res = True
                except:
                    res = False
                
                if res != tf:
                    is_pos = False
                    break
            
            if is_pos:
                pos_chars.append(pos_char)
        
        print('len', len(pos_chars))
        if len(pos_chars) == 1:
            flag += chr(pos_chars[0])
            print(flag)
            break