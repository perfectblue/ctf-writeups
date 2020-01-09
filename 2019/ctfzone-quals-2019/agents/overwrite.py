import base64
from pwn import *
from Crypto.Util.strxor import strxor

p = remote('crypto-agents.ctfz.one', 9543)

def sample():
    p.clean()
    p.sendline('1')
    p.recvuntil('"')
    name = p.recvuntil('"')[:-1]
    p.recvuntil('message: \r\n\r\n')
    enc = base64.b64decode(p.recvuntil('\n'))
    return name, enc

def query(name, enc):
    p.clean()
    p.sendline('2')
    p.recvuntil('name')
    p.sendline(name)
    p.recvuntil('HQ')
    p.sendline(base64.b64encode(enc))
    return p.recvuntil('Choose')

length = 337
old = '65537'
pad = strxor(old, '1    ')

for i in range(length - len(old), 0, -1):
    name, enc = sample()
    enc = enc[:11] + strxor(enc[11:12], strxor('0', '1')) + enc[12:]
    enc = enc[:i] + strxor(enc[i:i + len(old)], pad) + enc[i + len(old):]
    try:
        thing = query(name, enc)
        print(i, repr(thing))
    except:
        print(i, 'WEIRD!')
        p.close()
        p = remote('crypto-agents.ctfz.one', 9543)

# ctfzone{0FB_M0d3_C4n7_$4V3_A3$_K3Y}
