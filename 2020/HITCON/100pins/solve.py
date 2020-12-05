from braindead import *
log.enable()
import struct
import mastermind
import xorshit

args = Args()
args.parse()

def bits_to_double(b):
	buf = struct.pack('<Q', b)
	return struct.unpack('<d', buf)[0]

def double_to_bits(d):
	buf = struct.pack('<d', d)
	return struct.unpack('<Q', buf)[0]

def float_from_base36(s):
	div = 36**len(s)
	return int(s, 36) / div

N = 5040

masks = []
with open('masks.txt') as f:
	for val in range(N):
		_, const, mask = f.readline().split()
		masks.append((int(const, 2), int(mask, 2)))

def rng_test():
	log.info("self-test 1")
	r = io.process(['node', 'test.js'])
	n = int(r.rl().decode().strip())
	fs = []
	for _ in range(n):
		fs.append(float(r.rl().decode().strip()))

	cs = [(double_to_bits(f+1)&0x000fffffffffffff)<<12 for f in fs]
	ms = [0xfffffffffffff000]*len(cs)
	xs_seed = xorshit.solve_masks(cs, ms)

def rng_test2():
	log.info("self-test 2")
	r = io.process(['node', 'test2.js'])
	n = int(r.rl().decode().strip())
	pins = []
	for _ in range(n):
		pins.append(int(r.rl().decode().strip()))

	cs = []
	ms = []
	for pin in pins:
		c, m = masks[pin]
		cs.append(c<<12)
		ms.append(m<<12)
	xs_seed = xorshit.solve_masks(cs, ms)

def nonce_to_bits(s):
	return (double_to_bits(float_from_base36(s)+1)<<12)&0xffffffffffffffff

def rng_test3():
	log.info("self-test 3")
	r = io.process(['node', 'test3.js'])
	npins = 100
	pins = []
	for _ in range(npins):
		pins.append(mastermind.candidate_to_int[r.rl().decode().strip()])
	nonce = r.rl().decode().strip()
	if '.' in nonce:
		nonce = nonce[1:] + '0'
	log.info("nonce: %s", nonce)

	cs = []
	ms = []
	for i, pin in enumerate(pins):
		c, m = masks[pin]
		if i >= 7:
			c, m = 0, 0
		cs.append(c<<12)
		ms.append(m<<12)
	cs.append(nonce_to_bits(nonce))
	ms.append(0xfffffffffffff000)
	xs_seed = xorshit.solve_masks(cs, ms)
	if xs_seed is not None:
		success('seed = %s', hex(xs_seed))
		return 1
	else:
		return 0

#rng_test()
#rng_test2()
good = 0
for _ in range(100):
	good += rng_test3()
	print(_)
print('good:', good)

#r = io.process(['node', '100pins.js'])

#r.ru('Show me sha256("')
#pow_leak = r.ru('"').decode()[:-1]

#info('PoW leak: %s', pow_leak)
