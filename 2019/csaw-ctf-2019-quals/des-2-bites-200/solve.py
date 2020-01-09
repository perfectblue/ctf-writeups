from Crypto.Cipher import DES
import binascii
from pwn import *

def duck(aChr):
    try:
        return int(aChr)
    except:
        return "abcdef".index(aChr)+11

duck_map = {}
for c in "0123456789abcdef":
    duck_map[duck(c)] = c


def decodeText(plaintext, offset):
    ans = ""
    for i in range(0, len(plaintext), 8):
        cur = int(plaintext[i:i+8]) - offset
        cur_c = duck_map[cur]
        ans += cur_c
    return ans.decode('hex')


ciph = open('FLAG.enc', 'rb').read().strip()
des_2 = decodeText(ciph, 9133337)
des_2 = binascii.unhexlify(des_2)

keys = [
    '0101010101010101'.decode('hex'),
    '1010101010101010'.decode('hex'),
    'FEFEFEFEFEFEFEFE'.decode('hex'),
    'EFEFEFEFEFEFEFEF'.decode('hex'),
    'E0E0E0E0F1F1F1F1'.decode('hex'),
    '0E0E0E0EF1F1F1F1'.decode('hex'),
    'E0E0E0E01F1F1F1F'.decode('hex'),
    '0E0E0E0E1F1F1F1F'.decode('hex'),
    '1F1F1F1F0E0E0E0E'.decode('hex'),
    'F1F1F1F10E0E0E0E'.decode('hex'),
    '1F1F1F1FE0E0E0E0'.decode('hex'),
    'F1F1F1F1E0E0E0E0'.decode('hex'),
    '0000000000000000'.decode('hex'),
    'FFFFFFFFFFFFFFFF'.decode('hex'),
    'E1E1E1E1F0F0F0F0'.decode('hex'),
    '1E1E1E1EF0F0F0F0'.decode('hex'),
    'E1E1E1E10F0F0F0F'.decode('hex'),
    '1E1E1E1E0F0F0F0F'.decode('hex'),
    '1E1E1E1E0F0F0F0F'.decode('hex'),
    'E1E1E1E10F0F0F0F'.decode('hex'),
    '1E1E1E1EF0F0F0F0'.decode('hex'),
    'E1E1E1E1F0F0F0F0'.decode('hex'),
]
keys2 = [
    0x011F011F010E010E,
    0x1F011F010E010E01,
    0x01E001E001F101F1,
    0xE001E001F101F101,
    0x01FE01FE01FE01FE,
    0xFE01FE01FE01FE01,
    0x1FE01FE00EF10EF1,
    0xE01FE01FF10EF10E,
    0x1FFE1FFE0EFE0EFE,
    0xFE1FFE1FFE0EFE0E,
    0xE0FEE0FEF1FEF1FE,
    0xFEE0FEE0FEF1FEF1,
]

keys3 = [
    0x01011F1F01010E0E, 0x1F1F01010E0E0101, 0xE0E01F1FF1F10E0E,
    0x0101E0E00101F1F1, 0x1F1FE0E00E0EF1F1, 0xE0E0FEFEF1F1FEFE,
    0x0101FEFE0101FEFE, 0x1F1FFEFE0E0EFEFE, 0xE0FE011FF1FE010E,
    0x011F1F01010E0E01, 0x1FE001FE0EF101FE, 0xE0FE1F01F1FE0E01,
    0x011FE0FE010EF1FE, 0x1FE0E01F0EF1F10E, 0xE0FEFEE0F1FEFEF1,
    0x011FFEE0010EFEF1, 0x1FE0FE010EF1FE01, 0xFE0101FEFE0101FE,
    0x01E01FFE01F10EFE, 0x1FFE01E00EFE01F1, 0xFE011FE0FE010EF1,
    0xFE01E01FFE01F10E, 0x1FFEE0010EFEF101, 0xFE1F01E0FE0E01F1,
    0x01E0E00101F1F101, 0x1FFEFE1F0EFEFE0E, 0xFE1FE001FE0EF101,
    0x01E0FE1F01F1FE0E, 0xE00101E0F10101F1, 0xFE1F1FFEFE0E0EFE,
    0x01FE1FE001FE0EF1, 0xE0011FFEF1010EFE, 0xFEE0011FFEF1010E,
    0x01FEE01F01FEF10E, 0xE001FE1FF101FE0E, 0xFEE01F01FEF10E01,
    0x01FEFE0101FEFE01, 0xE01F01FEF10E01FE, 0xFEE0E0FEFEF1F1FE,
    0x1F01011F0E01010E, 0xE01F1FE0F10E0EF1, 0xFEFE0101FEFE0101,
    0x1F01E0FE0E01F1FE, 0xE01FFE01F10EFE01, 0xFEFE1F1FFEFE0E0E,
    0x1F01FEE00E01FEF1, 0xE0E00101F1F10101, 0xFEFEE0E0FEFEF1F1,
]

for key in keys2:
    keys.append(p64(key))
    keys.append(p64(key)[::-1])

for key in keys3:
    keys.append(p64(key))
    keys.append(p64(key)[::-1])

IV = '13371337'
N = len(keys)

for i in range(N):
    des_1 = DES.new(keys[i], DES.MODE_OFB, IV).decrypt(des_2)
    for j in range(N):
        ptxt = DES.new(keys[j], DES.MODE_OFB, IV).decrypt(des_1)
        if 'flag' in ptxt:
            print ptxt

# flag{~tak3_0n3_N!bbI3_@t_@_t!m3~}
