import base64
from pwn import *
from Crypto.Util.strxor import strxor

p = remote('crypto-agents.ctfz.one', 9543)

def sample():
	global p
	p.clean()
	p.sendline('1')
	p.recvuntil('"')
	name = p.recvuntil('"')[:-1]
	p.recvuntil('message: \r\n\r\n')
	enc = base64.b64decode(p.recvuntil('\n'))
	return name, enc

def query(name, enc):
	global p
	p.clean()
	p.sendline('2')
	p.recvuntil('name')
	p.sendline(name)
	p.recvuntil('HQ')
	p.sendline(base64.b64encode(enc))
	try:
		p.recvuntil('Choose')
		return False
	except:
		p.close()
		p = remote('crypto-agents.ctfz.one', 9543)
		return True

length = 337
nums = '0123456789'

known = '{"trusted":0,"n":'

while True:
	for c in [0, 8, 64, 72, 80, 88, 96, 16, 24, 32, 40, 48, 56, 104, 112, 120]:
		name, enc = sample()
		new = strxor(strxor(enc[:len(known)], known), ' '*len(known))
		new += strxor(enc[len(known)], chr(c))
		if query(name, new):
			thing = c
			break
		print 'global', c

	weird = []
	for c in sorted(list(range(0, 128, 2)), key=lambda x: abs(x - thing)):
		name, enc = sample()
		new = strxor(strxor(enc[:len(known)], known), ' '*len(known))
		new += strxor(enc[len(known)], chr(c))
		if query(name, new):
			weird.append(c)
			weird.append(c + 1)
			if len(weird) == 10:
				break
		print 'local', c, weird
	print 'weird', weird

	possible = []
	for x in range(128):
		if all([chr(x ^ c) in nums for c in weird]):
			possible.append(x)
	print 'possible', [chr(x) for x in possible]

	fail = True
	for x in possible:
		name, enc = sample()
		new = strxor(strxor(enc[:len(known)], known), ' '*(len(known) - 1) + '"')
		new += strxor(enc[len(known)], chr(x ^ ord('"')))
		if query(name, new):
			assert fail
			fail = False
			known += chr(x)

	if fail:
		print('No matches!')
		break

	print 'known', repr(known)

# p.interactive()
