
from z3 import *

s = Solver()
flag = [None]*30
for i in range(30):
	flag[i] = BitVec('flag' + str(i), 32)
	s.add(ULE(flag[i] , 63))

# def SMORBOLL():
# 	num = BitVecVal(16, 32);
# 	for num2 in range(30):
# 		if (num2 != len(flag) - 2):
# 			num += flag[num2];
# 			num += If(URem(num2, 2) == 0, flag[num2], 0)
# 			# if (num2 % 2 == 0):
# 			# 	num += flag[num2];
# 			num += If(URem(num2, 3) == 0, 4294967294 * flag[num2], 0)
# 			# if (num2 % 3 == 0):
# 			# 	num += -2 * flag[num2];
# 			num += If(URem(num2, 5) == 0, 4294967293 * flag[num2], 0)
# 			# if (num2 % 5 == 0):
# 			# 	num += -3 * flag[num2];
# 			num += If(URem(num2, 7) == 0, 4 * flag[num2], 0)
# 			# if (num2 % 7 == 0):
# 			# 	num += 4 * flag[num2];
# 	s.add(flag[len(flag) - 2] == (num & 63));
# SMORBOLL()

# HEROISK check (z3 food)

# VAXMYRA checks distinct
s.add(Distinct(flag))

# more of heroisk
s.add(Not(flag[1] != 25))
s.add(Not(flag[2] != 23))
s.add(Not(flag[9] != 9))
s.add(Not(flag[20] != 45))
s.add(Not(flag[26] != 7))
s.add(Not(ULT(flag[8] , 15)))
s.add(Not(UGT(flag[12] , 4)))
s.add(Not(ULT(flag[14] , 48)))
s.add(Not(ULT(flag[29] , 1)))


num = flag[4];
num2 = flag[3];
num3 = flag[2];
num4 = flag[1];
s.add(ULE(flag[0] + num4 + num + num3 + num2 - 130, 10))
num4 = flag[9];
num5 = flag[8];
num6 = flag[7];
num7 = flag[6];
s.add(ULE(flag[5] + num7 + num6 + num5 + num4 - 140, 10))
num8 = flag[14];
num9 = flag[13];
num10 = flag[12];
num11 = flag[11];
s.add(ULE(flag[10] + num11 + num10 + num9 + num8 - 150, 10))
num12 = flag[19];
num13 = flag[18];
num14 = flag[17];
num15 = flag[16];
s.add(ULE(flag[15] + num15 + num14 + num13 + num12 - 160, 10))
num16 = flag[24];
num17 = flag[23];
num18 = flag[22];
num19 = flag[21];
s.add(ULE(flag[20] + num19 + num18 + num17 + num16 - 170, 10))
num20 = flag[25];
num21 = flag[20];
num22 = flag[15];
num23 = flag[10];
num24 = flag[5];
s.add(ULE(flag[0] + num24 + num23 + num22 + num21 + num20 - 172 , 6))
num25 = flag[26];
num26 = flag[21];
num27 = flag[16];
num28 = flag[11];
num29 = flag[6];
s.add(ULE(flag[1] + num29 + num28 + num27 + num26 + num25 - 162 , 6))
num30 = flag[27];
num31 = flag[22];
num32 = flag[17];
num33 = flag[12];
num34 = flag[7];
s.add(ULE(flag[2] + num34 + num33 + num32 + num31 + num30 - 152 , 6))
num35 = flag[23];
num36 = flag[18];
num37 = flag[13];
num38 = flag[8];
s.add(ULE(flag[3] + num38 + num37 + num36 + num35 - 142 , 6))
num39 = flag[29];
num40 = flag[24];
num41 = flag[19];
num42 = flag[14];
num43 = flag[9];
s.add(ULE(flag[4] + num43 + num42 + num41 + num40 + num39 - 132 , 6))


num44 = flag[27] * 3;
num45 = (flag[7] + num44) * 3 - flag[5] * 13;
s.add(Not(UGT(num45 - 57 , 28)))
num44 = flag[20] * 5;
num44 = (flag[14] << 2) - num44;
num45 = flag[22] * 3 + num44;
s.add(Not(UGT(num45 - 12 , 70)))
num44 = flag[18] * 2;
num44 = (flag[15] - num44) * 3;
num46 = flag[16] * 2;
num46 = (flag[14] + num46) * 2 + num44 - flag[17] * 5;
s.add(Not(flag[13] + num46 != 0))
num46 = flag[6] * 2;
s.add(Not(flag[5] != num46))
s.add(Not(flag[29] + flag[7] != 59))
num47 = flag[17] * 6;
s.add(Not(flag[0] != num47))
num47 = flag[9] * 4;
s.add(Not(flag[8] != num47))
num47 = flag[13] * 3;
s.add(Not(flag[11] << 1 != num47))
s.add(Not(flag[13] + flag[29] + flag[11] + flag[4] != flag[19]))
num48 = flag[12] * 13;
s.add(Not(flag[10] != num48))

s.add(flag[28] == 47) # checksum shit?

# solve
print s.check()
m = s.model()
flag_val = [0]*30
for i in range(30):
	flag_val[i] = int(str(m.eval(flag[i])))
print flag_val

# assert checksum correct (SMORBOLL)
def checksum():
	num = 16;
	for num2 in range(30):
		if (num2 != len(flag) - 2):
			num += flag_val[num2];
			if (num2 % 2 == 0):
				num += flag_val[num2];
			if (num2 % 3 == 0):
				num += -2 * flag_val[num2]
			if (num2 % 5 == 0):
				num += -3 * flag_val[num2]
			if (num2 % 7 == 0):
				num += 4 * flag_val[num2]
	return (num & 63)
assert checksum() == flag_val[len(flag) - 2]

# assert this soln is unique!!
def soln_unique():
	cond = flag[0] == flag_val[0]
	for i in range(1,30):
		cond = And(cond, flag[i] == flag_val[i])
	s.add(Not(cond))
	return s.check()
# assert str(soln_unique()) == 'unsat'

# from ctypes import cdll
# cdll.msvcrt.srand(572)
# assert cdll.msvcrt.rand() == 1906
# cdll.msvcrt.srand(572)

def unshuffle(arr):
	# ehh  fuck this im not reimplementing their exact fisher yates
	# from debugger
	# before
	# 0094D7F0  00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
	# 0094D800  10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 00 00
	# after
	# 0094D7F0  0C 02 04 15 00 16 0F 0B 17 05 1B 0A 13 06 14 10  ................  
	# 0094D800  09 18 01 08 07 11 1A 19 0D 03 12 0E 1C 1D 00 00  ................  
	perm = [ 0x0C, 0x02, 0x04, 0x15, 0x00, 0x16, 0x0F, 0x0B, 0x17, 0x05, 0x1B, 0x0A, 0x13, 0x06, 0x14, 0x10, 0x09, 0x18, 0x01, 0x08, 0x07, 0x11, 0x1A, 0x19, 0x0D, 0x03, 0x12, 0x0E, 0x1C, 0x1D ]
	assert len(arr) == len(perm)
	result = [0] * len(perm)
	for i,from_idx in enumerate(perm):
		result[from_idx] = arr[i]
	return result

def unswap(arr):
	#before
	# 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
	# 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 00 00
	#after
	# 01 00 02 04 03 05 07 06 08 0A 09 0B 0D 0C 0E 10
	# 0F 11 13 12 14 16 15 17 19 18 1A 1B 1C 1D
	for i in range(0, len(arr)-3, 3):
		tmp = arr[i]
		arr[i] = arr[i+1]
		arr[i+1] = tmp
	return arr

def dechode(arr):
	result = ''
	for c in arr:
		if c <= 9:
			result += chr(ord('0')-1 + c)
		elif c <= 9+26:
			result += chr(ord('A')-1 + c-9)
		elif c <= 9+26+26:
			result += chr(ord('a')-1 + c-9-26)
		elif c == 62:
			result += '{'
		elif c == 63:
			result += '}'
		else:
			assert False
	return result

flag_val = [48, 25, 23, 19, 15, 26, 13, 57, 36, 9, 52, 27, 4, 18, 49, 6, 41, 8, 43, 62, 45, 55, 37, 32, 1, 0, 7, 28, 47, 2]
print('z3 soln:')
print(flag_val)
for c in flag_val:
	print('%02x' % (c,)),
print

flag_val = unswap(flag_val)
print('unswapped:')
print(flag_val)
for c in flag_val:
	print('%02x' % (c,)),
print

flag_val = unshuffle(flag_val)
print('unshuffled:')
print(flag_val)
for c in flag_val:
	print('%02x' % (c,)),
print

xor_key = [ 0x1F, 0x23, 0x3F, 0x3F, 0x1B, 0x7, 0x37, 0x21, 0x4, 0x33, 0x9, 0x3B, 0x39, 0x28, 0x30, 0x0C, 0x0E, 0x2E, 0x3F, 0x25, 0x2A, 0x27, 0x3E, 0x0B, 0x27, 0x1C, 0x38, 0x31, 0x1E, 0x3D]
for i in range(len(flag_val)):
	flag_val[i] ^= xor_key[i]
print('unxored:')
print(flag_val)
for c in flag_val:
	print('%02x' % (c,)),
print

flag = dechode(flag_val)
print(flag)
