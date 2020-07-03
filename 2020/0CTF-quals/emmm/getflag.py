from struct import pack,unpack
import sys

P = 247359019496198933
C = 223805275076627807
M = 2**60
iC = pow(C, -1, M)

# not a bijection? can be adjusted but I'm lazy
def encrypt_block(x):
	print('in  ', x)
	tmp = x * K0 % P
	print('pre  ', tmp)
	tmp = tmp * C % M
	print('perm ', tmp)
	tmp = tmp * K1 % P
	print('post ', tmp)
	return tmp

def decrypt_block(x):
	#print('post ', x)
	tmp = x * iK1 % P
	for lift in range(tmp, M, P):
		#print('perm ', lift)
		tmp = lift * iC % M
		if tmp < P:
			#print('pre  ', tmp)
			tmp = tmp * iK0 % P
			for lift in range(tmp, 1<<64, P):
				#print('in   ', tmp)
				yield lift

with open("key") as f:
	K0, K1 = map(int, f.read().split())
	iK0 = pow(K0, -1, P)
	iK1 = pow(K1, -1, P)

if False:
	with open("res") as f:
		for line in f:
			p, c = map(int, line.split())
			assert encrypt_block(p) == c

flag = 'b1b8024cb0079102693cb3a3d8441600201266ef3899e2001bd2c7ed52d45c01f6de2d911b04bc00971842482a650900'
flag = bytes.fromhex(flag)
nblocks = len(flag)//8
blocks = [int.from_bytes(flag[i*8:i*8+8], 'little') for i in range(0, nblocks)]

p = int.from_bytes(b'hellowor', 'big')
c = encrypt_block(p)

flag = bytearray(b'flag{')
for c in blocks:
	for x in decrypt_block(c):
		p = x.to_bytes(8, 'little')
		if all(map(lambda k: 32 <= k and k < 128, p)):
			print(c, p)
			flag += p
	else:
		print(c, '???')

flag += b'}'
print(flag)
