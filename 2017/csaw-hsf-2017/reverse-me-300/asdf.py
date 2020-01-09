from pwn import *

def arr2hex(arr):
    return ' '.join(map(lambda b: '%02x' % b, arr))

def hex2arr(hexstr):
    return ordlist(unhex(hexstr.replace(' ','')))


def trans1(buf):
    result = [0] * len(buf)
    for i in range(0, len(result)):
        result[i] = (buf[i] - i*2) & 0xFF
    return result

def trans2(buf):
    result = [0] * len(buf)
    for i in range(0, len(result)):
        result[i] = buf[i] ^ ((i + 0x66) & 0xFF)
    return result

def ident(buf):
    return buf

def trans1_inv(buf):
    result = [0] * len(buf)
    for i in range(0, len(result)):
        result[i] = (buf[i] + i*2) & 0xFF
    return result

print arr2hex(trans2(trans1(hex2arr('61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 40 70 71 72 73 74 75 76 77 78 79 7A')[::-1])))

ciphertext = hex2arr('1B 5A 53 50 01 0D 49 32 21 4E 27 6A 26 36 2D 67 2F 4A 74 67 29 46 49 43 48')
ciphertext = trans2(ciphertext)
print ciphertext
ciphertext = trans1_inv(ciphertext)
print ciphertext
ciphertext = ciphertext[::-1]
print ciphertext
print unordlist(ciphertext)

