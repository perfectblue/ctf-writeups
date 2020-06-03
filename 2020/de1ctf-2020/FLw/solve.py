enc = open('code5', 'rb').read()
trans = b'0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm+/=' 
rev_trans = {}
for i, c in enumerate(trans):
    rev_trans[c] = i

def decode(data):
    ret = []
    for i in range(0, len(data), 3):
        x, y, z = data[i:i+3]
        x ^= z
        z -= y
        y += x

        x, y, z = [rev_trans[a & 0xff] for a in [x,y,z]]
        q2 = x * 0x3a ** 2 + y * 0x3a + z
        ret += [q2 >> 8, q2 & 0xff]

    return bytes(ret)

print(b'De1CTF{' + decode(enc) + b'}')
