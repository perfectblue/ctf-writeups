#!/usr/bin/python
import itertools
from Crypto.Util.number import *

def grouper(n, iterable):
    it = iter(iterable)
    while True:
       chunk = tuple(itertools.islice(it, n))
       if not chunk:
           return
       yield chunk

def decrypt(msg):
    assert set(msg) == set(['0', '1'])
    result = ''
    for group in grouper(3, msg):
        if len(group) == 3:
            result += group[0]
            result += group[1]
        elif len(group) == 2:
            result += group[0]
        else:
            assert(False)
    return result


c=bin(bytes_to_long(open('FLAG.enc', 'rb').read()))[2:]
i = 0
while len(c) > 8:
    c = decrypt(c)
    m = long_to_bytes(int(c,2))
    if 'ASIS' in m:
        print m
        break
    i += 1
    print i

