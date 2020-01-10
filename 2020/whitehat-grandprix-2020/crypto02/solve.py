# from Crypto.Cipher import AES
import itertools
import random
from base64 import b64encode, b64decode
import os
from pwn import xor
import string
import json

# key = "A" * 16
# nonce = os.urandom(16)
# nonce = 'Ewst\x00n\xbf\xbe\x8c?\x1f=\x1c\x8d\xed\xfa'
# msg = "The quick brown fox jumped over the lazy dog. Lorem ipsum dolor sit amet."
# print b64encode(msg)
# ctrkey = map(ord, AES.new(key, AES.MODE_CTR, counter=lambda: nonce).encrypt("\x00" * 16))
# print ctrkey

charset = '=+/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
charset2 = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[]^_`{|}~ '

def encrypt(s):
    s = b64encode(s)
    crypto = AES.new(key, AES.MODE_CTR, counter=lambda: nonce)
    return crypto.encrypt(s)

def decrypt(s):
    crypto = AES.new(key, AES.MODE_CTR, counter=lambda: nonce)
    return b64decode(crypto.decrypt(s))

# enc = encrypt(msg)
# enc = b64decode("DoYgtr6+k1wmoikbCt8Y0zryLK++sY8bIrYlGCfPY90Clhm9lcWPASScJVki3wfNOoYO7JKllwYlxwQcCt0q3DusHq6+sbkaJMYxHQrfANw6hnGjvr6bHSO2JQEhzwSaFKZ15w==")
enc = b64decode("iMeec1JxJBSHe4zO8wdMmrTXnS1UTw4UhlW6yvcqUJqi1JEpVl8sFIRsl4ncF3LFpNC4dlZfHVSBRqrQ6S1yxaDqhS5VSDxMkXeQ0PEtcZuP0JooQUMCHJF8rdj3KgvO")
# '{"a":59400,"b":91578,"y":16085,"tm":"yf05j","Z":1495,"as":"answer=a*Z"}'
print len(enc)
assert len(enc) == 96

key_sice = []

for i in range(16):
    sice = []
    for j in range(256):
        corr = True
        for k in range(i, len(enc), 16):
            if xor(enc[k], chr(j)) not in charset:
                corr = False
                break
            # if xor(enc[k], chr(j)) == '=' and k < len(enc)-2:
            #     corr = False
            #     break
        if corr:
            sice.append(j)
    print sice
    key_sice += [sice]

opts = []
for i in range(0, 16, 4):
    curr_opts = []
    print i
    curr_keys = key_sice[i:i+4]
    for comb in itertools.product(*curr_keys):
        corr = True
        for j in range(i, len(enc)/16 * 16, 16):
            curr_block = enc[j:j+4]
            curr_dec = None
            try:
                curr_dec = b64decode(xor(curr_block, ''.join(map(chr, comb))))
            except TypeError:
                corr = False

            if corr == False:
                break

            corr_2 = True
            for c in curr_dec:
                if c not in charset2:
                    corr_2 = False
                    break
            if j == 0 and curr_dec[:2] != '{"':
                corr_2 = False
            if j == 92 and curr_dec[-2:] != '"}':
                corr_2 = False
            if not corr_2:
                corr = False
                break
        if corr:
            curr_opts.append(comb)
    print len(curr_opts)
    opts.append(curr_opts)
    print ""

total_ways = 1
for i in range(4):
    total_ways *= len(opts[i])
print "Total: ", total_ways

for key_comb in itertools.product(*opts):
    test_key = []
    for i in range(4):
        test_key += list(key_comb[i])
    dec_b64 = xor(enc, ''.join(map(chr, test_key)))
    dec = b64decode(dec_b64)
    if '"answer=' in dec:
        try:
            json.loads(dec)
            print repr(dec)
        except ValueError:
            pass

#  Right! Here is your flag: w0rk_sm4ter_n0t_h4rd3r_!@&#^!!!
# 55b6569df49d7f82ff66c1cad0d03c97bd3da30d
