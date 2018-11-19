from z3 import *
wow=[1, 0, 5, 8, 3, 0x35, 4, 2, 5, 8, 3, 0x1A, 4, 2, 5, 8, 3, 0x28, 4, 2, 5, 8, 3, 0x0E, 4, 2, 3, 0xD305D17C482B0422, 2, 3, 0xD305D17C10126448, 6, 1, 0, 5, 8, 3, 0x27, 4, 2, 5, 8, 3, 0x19, 4, 2, 5, 8, 3, 0x1C, 4, 2, 5, 8, 3, 0x13, 4, 2, 3, 0xD202F9023DB7D10E, 2, 3, 0xD202F90265D99D20, 6, 1, 0, 5, 8, 3, 0x32, 4, 2, 5, 8, 3, 0x22, 4, 2, 5, 8, 3, 0x31, 4, 2, 5, 8, 3, 0x17, 4, 2, 3, 0xCBC9CB73CC0C9B2C, 2, 3, 0xCBC9CB738575B951, 6, 1, 0, 5, 8, 3, 0x26, 4, 2, 5, 8, 3, 0x2C, 4, 2, 5, 8, 3, 0x23, 4, 2, 5, 8, 3, 0x25, 4, 2, 3, 0xFF4A3497F543CB12, 2, 3, 0xFF4A3497947FAB44, 6, 1, 0, 5, 8, 3, 0x0D, 4, 2, 5, 8, 3, 0x37, 4, 2, 5, 8, 3, 5, 4, 2, 5, 8, 3, 0x30, 4, 2, 3, 0x4B14AC742FC2716, 2, 3, 0x4B14AC771FC0567, 6, 1, 0, 5, 8, 3, 0x24, 4, 2, 5, 8, 3, 4, 4, 2, 5, 8, 3, 0x1F, 4, 2, 5, 8, 3, 8, 4, 2, 3, 0xB7E2F67C78709172, 2, 3, 0xB7E2F67C2022DD19, 6, 1, 0, 5, 8, 3, 0x1E, 4, 2, 5, 8, 3, 0x2D, 4, 2, 5, 8, 3, 0x29, 4, 2, 5, 8, 3, 0x16, 4, 2, 3, 0xA6362BDF7263FF6B, 2, 3, 0xA6362BDF452ADB1C, 6, 1, 0, 5, 8, 3, 0x2A, 4, 2, 5, 8, 3, 0x33, 4, 2, 5, 8, 3, 0x14, 4, 2, 5, 8, 3, 0x0A, 4, 2, 3, 0x5F852A92E1E19E02, 2, 3, 0x5F852A92938BD275, 6, 1, 0, 5, 8, 3, 7, 4, 2, 5, 8, 3, 0x18, 4, 2, 5, 8, 3, 0x2E, 4, 2, 5, 8, 3, 0x1D, 4, 2, 3, 0x0F5007E1FAB6338A, 2, 3, 0x0F5007E1A2E47FD7, 6, 1, 0, 5, 8, 3, 0x10, 4, 2, 5, 8, 3, 0x11, 4, 2, 5, 8, 3, 0x2B, 4, 2, 5, 8, 3, 0x15, 4, 2, 3, 0x39D98CFD990BC965, 2, 3, 0x39D98CFDEC36AA49, 6, 1, 0, 5, 8, 3, 0x1B, 4, 2, 5, 8, 3, 0x0F, 4, 2, 5, 8, 3, 0x36, 4, 2, 5, 8, 3, 0x20, 4, 2, 3, 0x72BF4CB8C184E70A, 2, 3, 0x72BF4CB8A8D6D57F, 6, 1, 0, 5, 8, 3, 0x0C, 4, 2, 5, 8, 3, 6, 4, 2, 5, 8, 3, 9, 4, 2, 5, 8, 3, 0x2F, 4, 2, 3, 0xFBF4642FA8238B1B, 2, 3, 0xFBF4642FF05ACD56, 6, 1, 0, 5, 8, 3, 0x34, 4, 2, 5, 8, 3, 0x0B, 4, 2, 5, 8, 3, 0x21, 4, 2, 5, 8, 3, 0x12, 4, 2, 3, 0x412A1140866F3EC8, 2, 3, 0x412A1140B4571DBE, 6, 7]
# wow=[1, 0, 5, 8, 3, 0x35, 4, 2, 5, 8, 3, 0x1A, 4, 2, 5, 8, 3, 0x28, 4, 2, 5, 8, 3, 0x0E, 4, 2, 3, 0xD305D17C482B0422, 2, 3, 0xD305D17C10126448, 6, 1, 0, 5, 8, 3, 0x27, 4, 2, 5, 8, 3, 0x19, 4, 2, 5, 8, 3, 0x1C, 4, 2, 5, 8, 3, 0x13, 4, 2, 3, 0xD202F9023DB7D10E, 2, 3, 0xD202F90265D99D20, 6, 1, 0, 5, 8, 3, 0x32, 4, 2, 5, 8, 3, 0x22, 4, 2, 5, 8, 3, 0x31, 4, 2, 5, 8, 3, 0x17, 4, 2, 3, 0xCBC9CB73CC0C9B2C, 2, 3, 0xCBC9CB738575B951, 6, 1, 0, 5, 8, 3, 0x26, 4, 2, 5, 8, 3, 0x2C, 4, 2, 5, 8, 3, 0x23, 4, 2, 5, 8, 3, 0x25, 4, 2, 3, 0xFF4A3497F543CB12, 2, 3, 0xFF4A3497947FAB44, 6, 7]
pc = 0
crash_cond = 1 # sigfpe
opchode = 0

d = {}
n = {}
def makereg(r):
	global d, n
	if not r in n:
		n[r] = 0
	ver = n[r]
	n[r] += 1
	name = r + '_' + str(ver)
	var = BitVec(name, 64)
	d[name] = var
	return var
bv8_sort = BitVec('_',8).sort()
bv64_sort = BitVec('__',64).sort()
def makereg_k(r='key'):
	global d, n
	if not r in n:
		n[r] = 0
	ver = n[r]
	n[r] += 1
	name = r + '_' + str(ver)
	var = Array(name, bv64_sort, bv8_sort)
	d[name] = var
	return var
def getreg(r):
	global d,n
	return d[r + '_' + str(n[r] - 1)]

def getopchode():
	global pc
	opc = wow[pc]
	pc += 1
	return opc


makereg('rax') # initial junk
key = makereg_k()
s = Solver()
s.add(makereg('field1') == BitVecVal(0, 64))
s.add(makereg('field2') == BitVecVal(0, 64))
while True:
	# print 'step1', pc, crash_cond
	# step1
	if crash_cond == 2:
		# field1 ^= field2
		rhs = getreg('field1') ^ getreg('field2')
		s.add(makereg('field1') == rhs)
		# print 'field1 ^= field2'
	elif crash_cond == 6:
		# print 'check fail'
		s.add(getreg('field1') == getreg('field2'))
		# if field1 != field2:
		# 	print 'FAIL!'
		# 	break
	elif crash_cond == 5:
		# field1 <<= rax
		# print 'field21 <<= rax'
		rhs = getreg('field1') << getreg('rax')
		s.add(makereg('field1') == rhs)
	elif crash_cond == 3:
		# field2 = rdi
		s.add(makereg('field2') == getreg('rdi'))
		# print 'field2 = rdi'
	elif crash_cond == 1:
		# field1 = rax
		s.add(makereg('field1') == getreg('rax'))
		# print 'field1 = rax'
	elif crash_cond == 4:
		# print 'doing key xor'
		# keyIdx = field2 & 0x3f;
		s.add(makereg('keyIdx') == getreg('field2') & BitVecVal(0x3f, 64))
		# field2 = key[keyIdx]
		s.add(makereg('field2') == SignExt(64-8,Select(getreg('key'), getreg('keyIdx'))))
		# if field2: # TODO
			# key[keyIdx] ^= (pc ^ 0x1f)
		rhs = getreg('key')
		lhs = makereg_k()
		# s.add( lhs == Store(rhs, getreg('keyIdx'), Select(rhs, getreg('keyIdx')) ^ BitVecVal((pc & 0x1f)&0xff, 8)) )
		s.add( Or(And(lhs == Store(rhs, getreg('keyIdx'), Select(rhs, getreg('keyIdx')) ^ BitVecVal((pc & 0x1f)&0xff, 8)), getreg('field2') != BitVecVal(0, 64)), And(getreg('field2') == BitVecVal(0, 64), lhs == rhs) ) )
	else:
		print 'BAD CRASH COND ' + hex(crash_cond)
		break

	# step2
	crash_cond = -1
	opchode = getopchode()
	# print 'step2', opchode
	if opchode == 1:
		# rax = getopchode()
		s.add(makereg('rax') == BitVecVal(getopchode(), 64))
		# rdi = checked
		makereg('rdi')
		# print 'rax = ' + hex(rax)
		crash_cond = opchode
	elif opchode == 3:
		# rax = 0x5647455347495300 # "SIGSEGV"
		s.add(makereg('rax') == BitVecVal(0x5647455347495300, 64))
		# rdi = getopchode()
		s.add(makereg('rdi') == BitVecVal(getopchode(), 64))
		# print 'rax = rdi = ' + hex(rax)
		crash_cond = 3
	elif opchode == 2:
		# rax = freedBuf
		makereg('rax')
		# rdi = rax
		makereg('rdi')
		crash_cond = 2
	elif opchode == 5:
		# print 'rax = ' + hex(rax)
		# rax = getopchode()
		s.add(makereg('rax') == BitVecVal(getopchode(), 64))
		# rdi = checked
		makereg('rdi')
		crash_cond = 5
	elif opchode == 4:
		makereg('rdi')
		makereg('rax')
		crash_cond = 4
	elif opchode == 6:
		makereg('rdi')
		makereg('rax')
		crash_cond = 6
	elif opchode == 7:
		print 'WINNER!!!!'
		# print ''.join(map(chr, key))
		break
	else:
		print 'BAD OPCODE ' + hex(opchode)
		break
print s
print s.check()
m = s.model()
print m
# open('log','w').write(str(m[getreg('key')]))

k = d['key_0']
shit = ''
for i in range(0, 64): shit += chr(int(str(m.eval(k[i]))))
print 'key=' + shit  + '}'

kk = getreg('key')
shit = ''
for i in range(0, 64): shit += chr(int(str(m.eval(kk[i]))))
print 'flag{' + shit  + '}'
#key=R"yXkFw8X3jRu=v.L,w}Rn9iL]7Lu#y`XVaX`$rc<ILMq"Ij2X2}
#flag{_1t_rUn5_4s_r0o7_5nd_c4n_D0_l0ts_Of_s7up1D_Th1Ng5_!}