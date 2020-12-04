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

def nonce_to_bits(s):
	return (double_to_bits(float_from_base36(s)+1)<<12)&0xffffffffffffffff

class MangleIndices:
	def __init__(self):
		self.base = 0
		self.cur = 0

	def next(self):
		if self.cur == 0:
			self.base += 64
			self.cur = self.base
		self.cur -= 1
		return self.cur

def rng_test():
	log.info("self-test 1")
	r = io.process(['node', 'test.js'])
	n = int(r.rl().decode().strip())
	fs = []
	for _ in range(n):
		fs.append(float(r.rl().decode().strip()))

	cs = [(double_to_bits(f+1)&0x000fffffffffffff)<<12 for f in fs]
	ms = [0xfffffffffffff000]*len(cs)

	mi = MangleIndices()
	solver = io.process(['./solver/target/release/solver'], stderr='pass')

	for i, (c, m) in enumerate(zip(cs, ms)):
		solver.sl(f'bits {mi.next()} {c} {m}')
	solver.sl('end')
	io.interactive(solver)

def rng_test2():
	log.info("self-test 2")
	r = io.process(['node', 'test2.js'])
	n = int(r.rl().decode().strip())
	pins = []
	for _ in range(n):
		pins.append(int(r.rl().decode().strip()))

	solver = io.process(['./solver/target/release/solver'], stderr='pass')
	mi = MangleIndices()
	for pin in pins:
		c, m = masks[pin]
		j = mi.next()
		solver.sl(f'bits {j} {c<<12} {m<<12}')
		solver.sl(f'pin {j} {pin}')
	solver.sl('end')
	io.interactive(solver)

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
	solver = io.process(['./solver/target/release/solver'], stderr='pass')
	mi = MangleIndices()
	for i, pin in enumerate(pins):
		c, m = masks[pin]
		j = mi.next()
		if i < 7:
			solver.sl(f'pin {j} {pin}')
			solver.sl(f'bits {j} {c<<12} {m<<12}')
	c = nonce_to_bits(nonce)
	m = 0xfffffffffffff000
	j = mi.next()
	solver.sl(f'bits {j} {c} {m}')
	solver.sl('end')

	sols = []
	while True:
		l = solver.rl().decode().strip()
		if l == 'end':
			break
		elif l.startswith('init '):
			_, s0, s1 = l.split()
			sols.append((int(s0), int(s1)))
	if len(sols) > 1:
		log.warn('got %s solutions', len(sols))
		return 0
	elif len(sols) == 1:
		return 1
	else:
		return 0

#rng_test()

#rng_test2()

if 0:
	good = 0
	for _ in range(1000):
		good += rng_test3()
		print(_)
	print('good:', good)

#r = io.process(['node', '100pins.js'])
r = io.connect(('18.183.134.249', 1234))

r.ru('Show me sha256("')
pow_leak = r.ru('"').decode()[:-1]

info('PoW leak: %s', pow_leak)

pow_solver = io.process(['./pow', pow_leak])
pow_sol = pow_solver.rl().strip()

r.sl(pow_sol)

first_pins = []

query_cnt = 128
accepted = False

def oracle(q):
	global query_cnt
	global accepted
	query_cnt -= 1
	r.sla('?', q)
	resp = r.rl().decode().strip()
	if 'OK' in resp:
		accepted = True
		return 20
	else:
		accepted = False
		assert 'Hmm' in resp
		_, _, hint = resp.split()
		a = int(hint[0])
		b = int(hint[2])
		info('a = %s', a)
		info('b = %s', b)
		return a*5+b

for pin_i in range(6):
	pin = mastermind.solve_pin(oracle)
	success("pin %s = %s", pin_i, pin)
	if not accepted:
		query_cnt -= 1
		r.sla('?', pin)
	first_pins.append(pin)
info("query count = %s", query_cnt)
if query_cnt < 100-7:
	die("tyra")

info("SoLViNG")

solver = io.process(['./solver/target/release/solver'], stderr='pass')
mi = MangleIndices()

for i in range(100):
	j = mi.next()
	if i < len(first_pins):
		pin = first_pins[i]
		pin = mastermind.candidate_to_int[pin]
		c, m = masks[pin]
		solver.sl(f'pin {j} {pin}')
		solver.sl(f'bits {j} {c<<12} {m<<12}')

c = nonce_to_bits(pow_leak)
m = 0xfffffffffffff000
j = mi.next()
solver.sl(f'bits {j} {c} {m}')
solver.sl('end')

sols = []
while True:
	l = solver.rl().decode().strip()
	if l == 'end':
		break
	elif l.startswith('init '):
		_, s0, s1 = l.split()
		sols.append((int(s0), int(s1)))

if len(sols) > 1:
	log.warn('got %s solutions', len(sols))
elif len(sols) == 1:
	pass
else:
	die("vittu")

for s0, s1 in sols:

	xs = xorshit.Cached(xorshit.XS128_Concrete(s0, s1))

	all_pins = []
	for _ in range(100):
		b = xs.next64()
		b = (b>>12) | 0x3FF0000000000000
		f = bits_to_double(b)-1
		idx = int(f*5040)
		all_pins.append(mastermind.candidates[idx])

	fuck = False
	for real, guessed in zip(first_pins, all_pins):
		if real != guessed:
			fuck = True
	if fuck:
		continue

	for i in range(len(first_pins), 100):
		r.sla("?", all_pins[i])
		resp = r.rl()
		if b'OK' not in resp:
			fuck = True
		else:
			first_pins.append(all_pins[i])
	if fuck:
		continue

	io.interactive(r)
	break
