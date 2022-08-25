#!/usr/bin/python3

from mp import *
import string

# flag = bytearray(b'sctf{!!!!!!!!!!!!!!!!!!!!!!!!!}')
flag = bytearray(b'sctf{time_attack_prequel}')

for i in range(len(flag)):
    if flag[i] != ord('!'):
        continue
    res = []
    for v in string.ascii_uppercase[:13] + string.digits:
        print(v)
        r = remote('0', 31337)
        # r = process('./AttackMe.py')
        payload = chr(0) * (i - 1) + v
        r >> b'input>'
        r.sendline(payload)
        try:
            r >> b'value: '
            res.append(int(r.recv().strip().decode()))
            # print(res)
        except:
            res.append(-1)
        r.close()

    print(res)
    
    for t in string.ascii_lowercase + string.digits + '_' + '}':
        for j, p in enumerate(string.ascii_uppercase[:13] + string.digits):
            if res[j] == -1:
                continue
            p = ord(p)
            d = (flag[i - 1] ^ p) * ord(t)
            e = (d << p) % 500009
            for pad in range (0, 6-len(str(e))): e*=10
            o = pow(p, e, 100003)
            if (o % 100003) % 2 != res[j]:
                break
        else:
            print(i, t)
            flag[i] = ord(t)
            break
    
    print(flag[:i+1])


