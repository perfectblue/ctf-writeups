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
iv, enc = bytearray.fromhex(enc[:32]), enc[32:]

iv[0] ^= ord('o') ^ ord('{')
iv[1] ^= ord('n') ^ ord('"')
iv[12] ^= ord('"') ^ ord(' ')
iv[15] ^= ord('"') ^ ord(' ')
# iv[13] ^= ord(',') ^ ord(' ')

test = {'secret': 'hitcon{local_fla', 'who': 'user', "name": 'test'}
test = json.dumps(test)
test = '{"' + test[18:28] + ' ,  ' + test[32:]

flag = 'hitcon{'
for i in range(9):
    dic = dict()
    to_pick = list(range(1, 128))
    while True:
        tmp = random.choice(to_pick)
        to_pick.remove(tmp)
        print('trying', i, tmp)

        iv[3 + i] ^= tmp
        r.recvuntil('cmd: ')
        r.sendline('login')
        r.recvuntil('token: ')
        res = base64.b64encode(json.dumps({'cipher': enc, 'iv': iv.hex()}).encode()).decode()
        r.sendline(res)
        iv[3 + i] ^= tmp

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
                test = test[:3 + i] + chr(pos_char ^ xor) + test[4 + i:]
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