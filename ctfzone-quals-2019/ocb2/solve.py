import base64

from Crypto.Util.number import bytes_to_long, long_to_bytes
from Crypto.Util.strxor import strxor

from pwn import *

from ocb.aes import AES
from ocb import OCB

p = remote('crypto-ocb2.ctfz.one', 4444)

p.recvuntil('Session nonce: ')
session = base64.b64decode(p.recvuntil('\n'))

def encrypt(nonce, plaintext):
	p.recvuntil('> ')
	p.sendline('encrypt')
	p.recvuntil('> ')
	p.sendline(base64.b64encode(nonce + plaintext))
	result = base64.b64decode(p.recvline())
	ciphertext, tag = result[16:-16], result[-16:]
	return tag, ciphertext

def decrypt(nonce, ciphertext, tag):
	p.recvuntil('> ')
	p.sendline('decrypt')
	p.recvuntil('> ')
	p.sendline(base64.b64encode(nonce + ciphertext + tag))
	result = base64.b64decode(p.recvline())
	plaintext = result
	return plaintext

def command(payload=None):
	p.recvuntil('> ')
	p.sendline('command')
	p.recvuntil('Example for "help" command:')
	result = base64.b64decode(p.recvline())
	p.recvuntil('> ')
	if payload:
		p.sendline(base64.b64encode(payload))
		print(p.recvline())
	else:
		p.sendline(base64.b64encode(result))
	ciphertext, tag = result[16:-16], result[-16:]
	return tag, ciphertext

size = 16

b2n = lambda x: bytes_to_long(x)
n2b = lambda x: long_to_bytes(x, blocksize=size)
split = lambda x: [b2n(x[i:i+size]) for i in range(0, len(x), size)]
merge = lambda x: b''.join([n2b(x[i]) for i in range(len(x))])
encode = lambda x: n2b(x*8)

key = b'\xacE\xbe]\xcf\xba\xc5~\x13\xc9\x9b\x97\xd0\x94-J'
nonce = b'\x1b\x97Z:WgJ\x84\x9cf\x1bV\x02\x1a\xa1\x9c'
# session = b'\xef\x85\xd8z\x0f\x83\x17P\x1cy\x08\xa7\x03\x10\x0e\xf7'

ocb = OCB(AES(128))
ocb.setKey(key)
double = ocb._times2
triple = ocb._times3

plaintext = encode(size) + b'A'*size

tag, ciphertext = encrypt(nonce, plaintext)
p1 = split(plaintext)
c1 = split(ciphertext)
c2 = n2b(c1[0] ^ size*8)
t2 = n2b(p1[1] ^ c1[1])
leak = decrypt(nonce, c2, t2)
offset = strxor(leak, encode(size))

block = encrypt(nonce, strxor(session, offset) + b'A')[1][:-1]
sl = strxor(block, offset)

# def forge(plaintext):
# 	plaintext = [plaintext[i:i+size] for i in range(0, len(plaintext), size)]
# 	ciphertext = []
# 	tmp = sl
# 	checksum = '\x00'*16
# 	for plain in plaintext[:-1]:
# 		tmp = double(tmp)
# 		inp = strxor(plain, tmp)
# 		block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
# 		out = strxor(block, offset)
# 		cipher = strxor(out, tmp)
# 		ciphertext.append(cipher)
# 		checksum = strxor(checksum, plain)
# 	plain = plaintext[-1]
# 	tmp = double(tmp)
# 	inp = strxor(encode(len(plain)), tmp)
# 	block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
# 	out = strxor(block, offset)
# 	cipher = strxor(plain, out[:len(plain)])
# 	ciphertext.append(cipher)
# 	checksum = strxor(checksum, plain + out[len(plain):])
# 	inp = strxor(checksum, triple(tmp))
# 	block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
# 	tag = strxor(block, offset)
# 	return b''.join(ciphertext), tag

TAG, ciphertext = command()
head, tail = ciphertext[:64], ciphertext[64:]
tmp = sl
for _ in range(5): tmp = double(tmp)
inp = strxor(encode(len(tail)), tmp)
block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
pad = strxor(block, offset)

diff = b'\x00'*16
diff = strxor(diff, strxor(tail, pad[:len(tail)]) + pad[len(tail):])
diff = strxor(diff, triple(tmp))
diff = strxor(diff, triple(double(tmp)))

known1 = b'":"flag","a":"'
known2 = b'"}'

plain1 = known1 + strxor(known2, diff[14:])
plain2 = strxor(known1, diff[:14]) + known2

inp = strxor(plain1, tmp)
ocb.setNonce(nonce)
block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
out = strxor(block, offset)
cipher1 = strxor(out, tmp)

inp = strxor(encode(16), double(tmp))
block = encrypt(nonce, strxor(inp, offset) + b'A')[1][:-1]
out = strxor(block, offset)
cipher2 = strxor(out, plain2)

CIPHERTEXT = head + cipher1 + cipher2

command(payload=session+CIPHERTEXT+TAG)

p.interactive()

# ctfzone{e3d9a9f4e44ee2ad850bef3d5a19b86f}
