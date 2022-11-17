from Crypto.Util.Padding import unpad, pad
from pwn import *

r = remote('witches-symmetric-exam.seccon.games', 8080)
r.recvuntil(b'ciphertext: ')
secret_spell_ct = bytes.fromhex(r.readline().decode().strip())

def xor(a, b): return bytes((a^b for a,b in zip(a, b)))

def blocks(xs, n):
    for i in range(0, len(xs), n):
        yield xs[i:i+n]

def decrypt(data):
    r.sendlineafter(b'ciphertext: ', data.hex().encode())
    return r.readline().decode().strip()

ENC_CACHE = {}
def blk_encrypt(pt):
    pt = bytes(pt)
    assert len(pt) == 16
    if pt in ENC_CACHE:
        return ENC_CACHE[pt]

    buf = bytearray(32)
    buf[:16] = pt
    ct = bytearray(16)

    for i in range(15, -1, -1):
        print('decrypting block' + '.'*(16-i))
        for j in range(i+1, 16):
            buf[16+j] = ct[j] ^ (16-i)
        for x in range(256):
            buf[16+i] = x
            if decrypt(buf) != "b'ofb error'":
                ct[i] = buf[16+i] ^ (16-i)
                #print(i, x)
                break

    ENC_CACHE[pt] = ct
    return ct

def ofb_decrypt(ct):
    pt = bytearray()
    iv = ct[:16]
    for b in blocks(ct[16:], 16):
        iv = blk_encrypt(iv)
        pt += xor(b, iv)
    return unpad(pt, 16)

def ofb_encrypt(pt, iv=bytes(16)):
    ct = bytearray()
    pt = pad(pt, 16)
    s = iv
    for b in blocks(pt, 16):
        s = blk_encrypt(s)
        ct += xor(b, s)
    return iv + ct

def ctr_decrypt(ct, ctr):
    pt = bytearray()
    for b in blocks(ct, 16):
        t = b + bytes((16-len(b))%16)
        t = xor(b, blk_encrypt(ctr.to_bytes(16, 'big')))
        pt += t[:len(b)]
        ctr += 1
    return pt

def gf_2_128_mul(x, y):
    assert x < (1 << 128)
    assert y < (1 << 128)
    res = 0
    for i in range(127, -1, -1):
        res ^= x * ((y >> i) & 1)  # branchless
        x = (x >> 1) ^ ((x & 1) * 0xE1000000000000000000000000000000)
    assert res < 1 << 128
    return res

def ghash(data):
    assert len(data)%16 == 0

    y = 0
    for x in blocks(data, 16):
        x = int.from_bytes(x, 'big')
        y = gf_2_128_mul(x ^ y, ghash_key)
    return y

ghash_key = int.from_bytes(blk_encrypt(bytes(16)), 'big')
print('H = %x' % ghash_key)

secret_spell_gcm = ofb_decrypt(secret_spell_ct)

gcm_tag = secret_spell_gcm[:16]
gcm_iv = secret_spell_gcm[16:32]
gcm_ct = secret_spell_gcm[32:]

j0 = ghash(gcm_iv + bytes(8) + (128).to_bytes(8, 'big'))

secret_spell = ctr_decrypt(gcm_ct, j0+1)

print('spell: %s' % secret_spell)

ct = ctr_decrypt(b'give me key', j0+1)
tag = ghash(ct + bytes((-len(ct))%16) + (len(ct)*8).to_bytes(16, 'big')).to_bytes(16, 'big')
tag = ctr_decrypt(tag, j0)

gcm_msg = tag + gcm_iv + ct
ofb_msg = ofb_encrypt(gcm_msg)

r.sendlineafter(b'ciphertext: ', ofb_msg.hex().encode())
r.sendlineafter(b'spell:', secret_spell)

r.interactive()
