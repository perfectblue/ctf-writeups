from z3 import *

def yeem_conc(i):
	keys = [
		0xe217a676ac5b66860fb2e6c6eda10197,
		0xaf04d3d44257d14ed2cf461322b9aadd,
		0x352238919e4ebedf683407b8bc88fc49,
		0x6a4471233c9d7dbed0680f717911f892,
		0xd488e246793afb7da0d01ee2f223f124,
		0xc23a5bb5e894eab98c0ab65b1dbc4bbb,
		0xef5f2852cbc8c931d5bfe728c2833e85,
		0xb595cf9c8d708e2166d545cf7cfdd4f9,
	]
	assert i in range(0,256)
	result = 0x00000000000000000000000000000000
	for n in range(0, 8):
		if i & (1 << n):
			result ^= keys[n]
	return result

class Int128(object):
	def __init__(self, value=None, name=None):
		# ordered from low to high
		if name is not None:
			self.bytes = [BitVec(name + '_' + str(i),8) for i in range(0,16)]
		elif value is not None:
			self.bytes = [BitVecVal((value & (0xff << (8*i)))>>(8*i), 8) for i in range(0,16)]
		else:
			self.bytes = None

	def __xor__(self, other):
		result = Int128()
		result.bytes = [self.bytes[i] ^ other.bytes[i] for i in range(0,16)]
		return result

	def shr8(self):
		result = Int128()
		result.bytes = self.bytes[1:] + [BitVecVal(0,8)]
		return result

	def lowest8(self):
		return self.bytes[0]

	def toggle(self, enable):
		result = Int128()
		# result.bytes = [If(enable, self.bytes[i], BitVecVal(0,8)) for i in range(0,16)]
		result.bytes = [SignExt(7,enable)&self.bytes[i] for i in range(0,16)]
		return result

	def join(self):
		return Concat(*reversed(self.bytes))

	def __repr__(self):
		return ','.join(map(str,self.bytes))

	def equate(self, solver, other): # not great design but whatever
		for i in range(0,16):
			s.add(self.bytes[i] == other.bytes[i])

	def evaluate(self, model):
		return [int(str(model.evaluate(self.bytes[i]))) for i in range(0,16)]

	def simplify(self):
		result = Int128()
		result.bytes = map(simplify, self.bytes)
		return result

def yeem(i):
	keys = [
		Int128(value=0xe217a676ac5b66860fb2e6c6eda10197),
		Int128(value=0xaf04d3d44257d14ed2cf461322b9aadd),
		Int128(value=0x352238919e4ebedf683407b8bc88fc49),
		Int128(value=0x6a4471233c9d7dbed0680f717911f892),
		Int128(value=0xd488e246793afb7da0d01ee2f223f124),
		Int128(value=0xc23a5bb5e894eab98c0ab65b1dbc4bbb),
		Int128(value=0xef5f2852cbc8c931d5bfe728c2833e85),
		Int128(value=0xb595cf9c8d708e2166d545cf7cfdd4f9),
	]
	# keys = [ BitVec('L_' + str(n), 128) for n in range(0,8) ]
	i = simplify(i)
	result = Int128(value=0x00000000000000000000000000000000)
	for n in range(0, 8):
		result = result ^ keys[n].toggle(Extract(n,n,i))
		# result = result ^ keys[n].toggle((i & (1 << n)) != 0)
	return result


inputdata = map(lambda c: BitVecVal(ord(c), 8), 'flag{')
reg_init = Int128(value=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
for x in inputdata:
	reg_init = reg_init.shr8() ^ yeem(reg_init.lowest8() ^ x)
reg_init_const = int(str(simplify(reg_init.join())))
print hex(reg_init_const)
reg_init = Int128(value=reg_init_const)
# print hex(int(str(reg_init))) # 0x347b8dfa4b97acb7f1bb2779591da2b6L
# RSI  0x347b8dfa4b97acb7
# R11  0xf1bb2779591da2b6


# R9   0x347b8dfa4b97acb7
# R10  0xf1bb2779591da2b6

unknown = Int128(name='x')
inputdata = unknown.bytes[:16]
inputdata += [ BitVecVal(ord('}'), 8) ]
s = Solver()
reg_ver = 0
reg = Int128(name='reg_' + str(reg_ver))
reg.equate(s, reg_init)
for x in inputdata:
	reg_next = reg.shr8() ^ yeem(reg.lowest8() ^ x)
	reg_next = reg_next.simplify()
	reg_ver += 1
	reg = Int128(name='reg_' + str(reg_ver))
	reg.equate(s, reg_next)
	# print reg_next

unknown.equate(s, reg)
print s.check()
m = s.model()
unk_eval = unknown.evaluate(m)
print ''.join(map(lambda b: '%02x'%(b,), unk_eval[::]))
