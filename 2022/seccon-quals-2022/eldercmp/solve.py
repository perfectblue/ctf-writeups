s = '11 45 14 19 19 81 09 31 88 94 64 51 28 10 93 15'
s = [int(v) for v in s.replace(' ', '')]
sbox = '0C 00 0F 0A 02 0B 09 05 08 03 0D 07 01 0E 06 04'
sbox = bytes.fromhex(sbox)

k = bytes.fromhex('01 02 04 08 10 20 03 06 0C 18 30 23 05 0A 14 28')
k += bytes.fromhex('13 26 0F 1E 3C 3B 35 29 11 22 07 0E 1C 38 33 25')
k += bytes.fromhex('0912240b')

subkeys = []

for i in range(0, 406-126, 8):
    subkeys.extend([s[31], s[28], s[18], s[17], s[15], s[12], s[3], s[2]])

    s[1] ^= sbox[s[30]]
    s[4] ^= sbox[s[16]]
    s[23] ^= sbox[s[0]]

    s[19] ^= k[i//8] >> 3
    s[7] ^= k[i//8] & 0x7

    s = s[4:] + [s[1], s[2], s[3], s[0]]

subkeys.extend([s[3], s[2], s[15], s[12], s[18], s[17], s[31], s[28]])

print(len(subkeys))

targets = [
    0x5894A5AF7F7693B7,
    0x94706B86CE8E1CCE,
    0x98BA6F1FF3CC98,
    0xAE6575961AF354C,
    0xD853F981DF45AB41,
    0xE1FEFD554E662F7F,
    0x3CA11FB09E498AB4
]

def to_block(v):
    v = v.to_bytes(8, 'little')
    b = []
    for i in range(8):
        b += [v[i] >> 4, v[i] & 0xF]
    return b

forw = [
    1, 2, 11, 6, 3, 0, 9, 4,
    7, 10, 13, 14, 5, 8, 15, 12
]

back = [None for _ in range(16)]

for i in range(16):
    back[forw[i]] = i

def enc(b):
    b = b[:]
    for i in range(0, len(subkeys), 8):
        s = subkeys[i:i+8]

        for j in range(8):
            b[2*j+1] ^= sbox[b[2*j] ^ s[j]]
        
        if i == len(subkeys) - 8:
            break
        
        b = [ b[forw[i]] for i in range(16) ]
    return b

def dec(b):
    b = b[:]
    for i in reversed(range(0, len(subkeys), 8)):
        s = subkeys[i:i+8]

        for j in range(8):
            b[2*j+1] ^= sbox[b[2*j] ^ s[j]]
        
        if i == 0:
            break
        
        b = [ b[back[i]] for i in range(16) ]
    return b


res = b''
for v in targets:
    b = to_block(v)
    b2 = dec(b)
    b3 = enc(b2)
    res += bytes.fromhex(''.join(map(lambda x: f"{x:x}", b2)))
print(res)
