```python
from z3 import *

dic = {}
rbp = [0]*(0x818/8 + 1)

condout = open("cond", "w")

conditions = []

inp = open("dick", "r").read().split("\n")

c = 0
val = -1
off = -1
andval = -1

for i in inp:
	i = i.replace("eax", "rax")

	if c > 0:
		if "QWORD PTR [rbp-" in i:
			off = int(i.split("QWORD PTR [rbp-")[1].split("]")[0], 16) / 8
		if "movabs " in i:
			xorval = int(i.split(",")[1], 16)
			conditions.append([off, val, xorval, andval])

		c -= 1

	if "cmp    " in i:
		l, r = i.split("cmp    ")[1].strip().split(",")
		if "0x" in l:
			val = int(l, 16)
		elif "0x" in r:
			val = int(r, 16)
		elif l != "rdx":
			if "0x" in l:
				val = int(l, 16)
			else:
				val = dic[l]
		elif r != "rdx":
			if "0x" in r:
				val = int(r, 16)
			else:
				val = dic[r]


	if "movabs" in i and "rbp" not in i:
		l, r = i.split("movabs ")[1].strip().split(",")
		if "QWORD PTR [rbp-" in r:
			offset = int(r.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			dic[l] = rbp[offset]
		else:
			dic[l] = int(r, 16)

	if "and" in i:
		l, r = i.split("and    ")[1].strip().split(",")
		if "QWORD PTR [rbp-" in r:
			offset = int(r.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			andval = dic[l]
			dic[l] &= rbp[offset]
		else:
			andval = int(r, 16)
			dic[l] &= int(r, 16)

	if "test   rax,rax" in i:
		val = 0

	if "movzx" in i:
		andval = 0xff

	if "mov    " in i:
		l, r = i.split("mov    ")[1].strip().split(",")
		if "QWORD PTR [rbp-" in r:
			offset = int(r.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			dic[l] = rbp[offset]
		elif "QWORD PTR [rbp-" in l:
			offset = int(l.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			rbp[offset] = dic[r]
		else:
			if "0x" in r:
				dic[l] = int(r, 16)
			else:
				dic[l] = dic[r]

	if "xor    " in i:
		l, r = i.split("xor    ")[1].strip().split(",")
		if "QWORD PTR [rbp-" in r:
			offset = int(r.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			dic[l] ^= rbp[offset]
		elif "QWORD PTR [rbp-" in l:
			offset = int(l.split("QWORD PTR [rbp-")[1].strip().strip("]"), 16) / 8
			rbp[offset] ^= dic[r]
		else:
			if "0x" in r:
				dic[l] ^= int(r, 16)
			else:
				dic[l] ^= dic[r]

	if "jne" in i:
		c = 2

for i in conditions:
	bytenum = -1
	for j in range(8):
		if (i[3] >> (j*8)) & 0xff != 0:
			bytenum = j
	for j in i:
		condout.write(str(j) + " ")
	condout.write(str(bytenum) + "\n")
condout.close()

stage2 = open("dick2", "r").read().strip().split("\n")

xors = open("xors", "w")

for i in range(0, len(stage2), 4):
	xor1 = stage2[i].split("QWORD PTR [rbp-")[1].split("]")[0]
	xor2 = stage2[i + 1].split("QWORD PTR [rbp-")[1].split("]")[0]
	xor1 = int(xor1, 16) / 8
	xor2 = int(xor2, 16) / 8
	xors.write(str(xor1) + " " + str(xor2) + "\n")
xors.close()

```
