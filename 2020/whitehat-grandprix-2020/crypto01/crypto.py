from pwn import *

p = remote('15.164.159.194', 8006)


p.recvuntil('key: ')
key = p.recvline().strip().split(' ')

timedelay = .3
chunks = 10
def bulk_enc(msgs):
    p.recvuntil('choice: ')

    ret = []
    for off in range(0, len(msgs), chunks):
        tmp = msgs[off:off+chunks]
        for m in tmp:
            print(m)
            p.sendline('1')
            sleep(timedelay)
            p.sendline(m)
            sleep(timedelay)

        for m in tmp:
            p.recvuntil('message: ')
            ret.append(p.recvline().strip().split(' '))
    return ret
        

def enc(msg):
    p.recvuntil('choice: ')
    p.sendline('1')
    p.recvuntil('message: ')
    p.sendline(msg)

def getflag(key):
    p.recvuntil('choice: ')
    p.sendline('2')
    p.recvuntil('flag: ')
    p.sendline(key)
    p.interactive()


syms = 0
upper = 6
lower = 12
numbr = 12

syms_len = 28
let_len = 22
num_len = 16

m_syms = [{} for i in range(64)]
m_uppers = [{} for i in range(64)]
m_lowers = [{} for i in range(64)]
m_numbs = [{} for i in range(64)]

def tabular(tbl, loc, lets):
    encs = bulk_enc([x * 64 for x in lets])
    for chaos, x in zip(encs, lets):
        y = [v[loc:loc+2] for v in chaos]
        for i in range(64):
            tbl[i][y[i]] = x

tabular(m_uppers, upper, 'AAAABCDEFGHIJKLMNOPQRSTUVWXYZ')
tabular(m_lowers, lower, 'aaaaaaabcdefghijklmnopqrstuvwxyz')
tabular(m_syms, syms, '~`!@#$%^&*()_-+=<,>.?|~') 
tabular(m_numbs, numbr, '1234567890')

def decode(pos, codepoint):
    if len(codepoint) == syms_len:
        return m_syms[pos][codepoint[syms:syms+2]]
    elif len(codepoint) == num_len:
        return m_numbs[pos][codepoint[numbr:numbr+2]]
    else:
        assert len(codepoint) == let_len
        up = codepoint[upper:upper+2]
        low = codepoint[lower:lower+2]
        if int(codepoint[18:20], 16) & 0x20 != 0: # lowercase
            return m_lowers[pos][low]
        else:
            return m_uppers[pos][up]


key2 = ''.join([decode(i, cp) for i, cp in enumerate(key)])
print(key2)

getflag(key2)


