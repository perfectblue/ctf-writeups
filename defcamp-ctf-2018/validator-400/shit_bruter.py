import sys

binary=map(ord, open('validator','rb').read())
delta=0x5426E0-0x1426E0 # virtual - real = delta => real = virtual - delta
meme="""
0 5426E0 13 13 5426C0 13 13 1A 542F00 24 24
0A 542CC0 19 19 542CE0 19 19 6 543B00 35 35
5 543A80 33 33 543AC0 33 33 35 5424A0 10 10
35 5424B0 10 10 5424C0 10 10 5 542D40 1A 1A
28 542D00 19 19 542D20 19 19 1F 542500 12 12
2A 542720 15 15 542740 15 15 0E 543A00 31 31
18 542D80 1D 1D 542DA0 1D 1D 1A 542760 16 16
2D 542520 12 12 542540 12 12 20 542780 16 16
11 543780 2F 2F 5437C0 2F 2F 0 543A40 32 32
22 542EA0 20 20 542EC0 20 20 26 542D60 1C 1C
0C 5434C0 29 29 543500 29 29 2F 5424E0 11 11
"""

from operator import xor
def to_hex(a):
	return ''.join(map(lambda q: '%02x'%(q,),a))

class Interval(object):
	def __init__(self,a,b,pdata):
		self.a = a
		self.b = b
		self.pdata = pdata

		if pdata:
			self.buf = [0]*70
			pdata = self.pdata-delta
			self.buf[self.a:self.b] = binary[pdata:pdata+len(self)]

	def __contains__(self, x):
		return self.a <= x <= self.b

	def __len__(self):
		return self.b-self.a

	def __and__(self, other):
		a = max(self.a, other.a)
		b = min(self.b, other.b)
		if a >= b:
			return None
		return Interval(a,b,None)

	def __xor__(self, other):
		return map(xor, self.buf, other.buf)

	def __str__(self):
		return '[%d, %d]' % (self.a, self.b)

zemes = []
for shit in meme.split('\n'):
	if not shit: continue
	shit = shit.split(' ')
	shit = map(lambda fuck: int(fuck, 16), shit)
	offset1,pdata1,len1,cap1,pdata_correct,len_correct,cap_correct,offset2,pdata2,len2,cap2 = shit
	assert (len_correct == len1)
	known = Interval(offset1, offset1+len1, pdata1)
	check = Interval(offset1, offset1+len1, pdata_correct)
	correct = known ^ check
	xored = Interval(offset2, offset2+len2, pdata2)
	zemes.append((known,correct,xored))

order_pad = [0x83,0x23,0x42,0x69,0x23,0xB2,0x0E,0x28,0x97,0xDF,0x14,]

import itertools
i = 0
for order in itertools.permutations(range(0,11)):
	i += 1
	if i % 10000 == 0:
		sys.stderr.write(str(i) + ' ')
	solution = []
	output = []
	for q in range(0,70):
		zoom = 0
		for x in order:
			known, correct, xored = zemes[x]
			if q in known:
				zoom ^= correct[q]
				if correct[q] != 0:
					break
			if q in xored:
				zoom ^= xored.buf[q]
		solution.append(zoom)
		if q < 11:
			if (zoom^order_pad[q])%11 != order[q]:
				break

		zoom = solution[q]
		for x in order:
			known, correct, xored = zemes[x]
			if q in known:
				if correct[q] != 0 and correct[q] != zoom:
					break
			if q in xored:
				zoom ^= xored.buf[q]
		else:
			if q < 5 and zoom != ord('DCTF{'[q]):
				break
			if zoom != 0 and (zoom < 32 or zoom > 0x7f):
				break
			output.append(zoom)
			continue
		break
	else:
		print solution
		print ''.join(map(chr,output))
		# print to_hex(output)
