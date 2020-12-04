from pysmt.shortcuts import *
import logging
from braindead import io

M64 = (1<<64)-1
u64 = BVType(64)

_log = logging.getLogger(__name__)

def MurmurHash3(s):
	s = BVXor(s, BVLShr(s, 33))
	s = BVMul(s, BV(0xFF51AFD7ED558CCD, 64))
	s = BVXor(s, BVLShr(s, 33))
	s = BVMul(s, BV(0xC4CEB9FE1A85EC53, 64))
	s = BVXor(s, BVLShr(s, 33))
	return s

class XS128:
	def __init__(self, state0, state1):
		self.state0 = state0
		self.state1 = state1

	def state_update(self):
		s1 = self.state0
		s0 = self.state1
		self.state0 = s0
		s1 = BVXor(s1, BVLShl(s1, 23))
		s1 = BVXor(s1, BVLShr(s1, 17))
		s1 = BVXor(s1, s0);
		s1 = BVXor(s1, BVLShr(s0, 26))
		self.state1 = s1

	def next64(self):
		self.state_update()
		return self.state0

class Cached:
	def __init__(self, gen):
		self.cache = [0]*64
		self.index = 0
		self.gen = gen

	def _refill(self):
		for i in range(64):
			self.cache[i] = self.gen.next64()
		self.index = 64

	def next64(self):
		if self.index == 0:
			self._refill()
		self.index -= 1
		return self.cache[self.index]


class XS128_Concrete:
	def __init__(self, state0, state1):
		self.state0 = state0
		self.state1 = state1

	def state_update(self):
		s1 = self.state0
		s0 = self.state1
		self.state0 = s0
		s1 = s1 ^ (s1 << 23) & M64
		s1 = s1 ^ (s1 >> 17) & M64
		s1 = s1 ^ s0 & M64
		s1 = s1 ^ (s0 >> 26) & M64
		self.state1 = s1

	def next64(self):
		self.state_update()
		return self.state0

def solve_masks(cs, ms):
	assert len(cs) == len(ms)
	tot_bits = 0
	for m in ms:
		tot_bits += (f'{m:b}').count('1')
	_log.info('solving %s iterations of XS128 with %s bitleaks', len(ms), tot_bits)
	if 1:
		seed = Symbol('seed', u64)
		s0 = MurmurHash3(seed)
		s1 = MurmurHash3(BVNot(seed))
	else:
		s0 = Symbol('state0', u64)
		s1 = Symbol('state1', u64)
	xs = Cached(XS128(s0, s1))
	problem = TRUE()
	z = BVZero(64)
	for c, m in zip(cs, ms):
		out = xs.next64()
		assert c>>64 == 0
		if m == 0:
			continue
		c = BV(c, 64)
		m = BV(m, 64)
		problem = And(problem, Equals(z, BVAnd(m, BVXor(c, out))))

	write_smtlib(problem, "problem.smt")
	r = io.process([
		'boolector',
			'-SE', 'cms',
			'--smt2',
			'-v',
			'-m',
			'-t', '10',
			'-o', 'solver.out',
			'problem.smt'
	], stderr='pass')
	r.recv_until_eof()
	with open('solver.out') as f:
		sat = f.readline().strip()
		if sat == 'sat':
			_, seed, _ = f.readline().split()
			_log.info('solved! seed = %s', seed)
			return int(seed, 2)
		else:
			#_log.info('could not solve')
			return None

if 0 and __name__ == '__main__':
	import random
	xs = XS128_Concrete(random.getrandbits(64), random.getrandbits(64))
	cs = []
	ms = []
	m = 0xfffffffffffff000
	for _ in range(3000):
		cs.append(xs.next64() & m)
		ms.append(m)
	solve_masks(cs, ms)

if __name__ == '__main__':
	xs = XS128_Concrete(0xdeadbeef13371337, 0x4141414141414141)
	for i in range(20):
		print('bits', i, xs.next64(), 0xffff00f0f05555)
	print('end')
