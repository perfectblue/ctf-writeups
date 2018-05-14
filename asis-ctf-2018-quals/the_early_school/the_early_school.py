#!/usr/bin/python

from Crypto.Util.number import *
round=10
FLAG='ASISFuck'

def encrypt(msg):
    assert set(msg) == set(['0', '1'])
    print msg
    enc = [msg[i:i+2] + str( int(msg[i]) ^ int(msg[min(i+1, len(msg)-1)]) ) for i in range(0, len(msg), 2)]
    print enc
    return ''.join(enc)

ENC = bin(bytes_to_long(FLAG))[2:]

for _ in xrange(round):
    ENC = encrypt(ENC)

print ENC

fp = open('succ.enc', 'w')
fp.write(long_to_bytes(int(ENC, 2)))
fp.close()
