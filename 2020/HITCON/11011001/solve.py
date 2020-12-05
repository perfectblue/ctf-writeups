from z3 import *

data = """0x00081002 == 0x00001000
0x00029065 == 0x00029061
0x00000000 == 0x00000000
0x00016c40 == 0x00016c00
0x00020905 == 0x00000805
0x00010220 == 0x00000220
0x00098868 == 0x00080860
0x00021102 == 0x00021000
0x00000491 == 0x00000481
0x00031140 == 0x00001000
0x00000801 == 0x00000000
0x00060405 == 0x00000400
0x0000c860 == 0x00000060
0x00000508 == 0x00000400
0x00040900 == 0x00000800
0x00012213 == 0x00010003
0x000428c0 == 0x00000840
0x0000840c == 0x0000000c
0x00043500 == 0x00002000
0x0008105a == 0x00001000""".split("\n")

s = Solver()
cons = []

for i in data:
	temp = i.split(" == ")
	cons.append((int(temp[0], 16), int(temp[1], 16)))

bits = []
for i in range(20):
	a = []
	for j in range(20):
		test = BitVec("f" + str(i).zfill(2) + str(j).zfill(2), 8)
		s.add(Or(test == 0, test == 1))
		a.append(test)
	bits.append(a)
print(bits)

for i in range(len(cons)):
	for j in range(20):
		mask = (cons[i][0] >> j) & 1
		bit = (cons[i][1] >> j) & 1
		if mask == 1:
			# print(bits[i][j])
			s.add(bits[i][j] == BitVecVal(bit, 8))

for i in range(20):
	tot = 0
	tot2 = 0
	for j in range(20):
		tot += bits[i][j]
		tot2 += bits[j][i]
	s.add(tot == BitVecVal(10, 8))
	s.add(tot2 == BitVecVal(10, 8))

for i in range(20):
	for j in range(i + 1, 20):
		conds = []
		conds2 = []
		for k in range(20):
			conds.append(bits[i][k] != bits[j][k])
			conds2.append(bits[k][i] != bits[k][j])
		s.add(reduce(Or, conds))
		s.add(reduce(Or, conds2))

for i in range(18):
	for j in range(20):
		cur = bits[i][j] + bits[i + 1][j] + bits[i + 2][j]
		cur2 = bits[j][i] + bits[j][i + 1] + bits[j][i + 2]
		s.add(cur != BitVecVal(3, 8))
		s.add(cur != BitVecVal(0, 8))
		s.add(cur2 != BitVecVal(3, 8))
		s.add(cur2 != BitVecVal(0, 8))

print(s.check())
m = s.model()
print(m)

sices = []
for i in range(20):
	sice = ""
	for j in range(20):
		sice += str(m.eval(bits[i][j]))
	sices.append(int(sice[::-1], 2))
	# print(bin(sices[-1])[2:].zfill(20))
	print(sices[-1])
for i in range(20):
	print(sices[i] & cons[i][0] == cons[i][1])


