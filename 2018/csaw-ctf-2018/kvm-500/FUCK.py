import numpy as fuck
class Tree(object):
	def __init__(self, v, l, r):
		self.v = v
		self.l = l
		self.r = r
tree = {}

rootoototo=0x1300
tree[0x1300] = [0xFF, 0x12e0, 0]
for l in map(lambda l: map(lambda s: int(s, 16), l), map(lambda l: filter(lambda s:s,l), map(lambda s: s.split(' '), open('pussy.txt','r').readlines()))):
	tree[l[0]] = l[1:]
print tree

lmao = ''
def shit(x,p):
	global lmao
	if tree[p][0] != 0xFF:
		return tree[p][0] == x
	if shit(x, tree[p][1]) == 1:
		lmao += '0'
		return 1
	if shit(x, tree[p][2]) == 1:
		lmao += '1'
		return 1
	return 0
# print 'gasgasdg'


bitstream = ''# new wheel shiny and clean
fucker = open('goal.bin', 'rb').read()
for gggg in map(ord, fucker):
	dumbgggg=bin(gggg)[2:]
	zsgd= '0' * (8-len(dumbgggg)) + dumbgggg
	bitstream+=zsgd[::-1]

lmao=''
shit(ord('{'), rootoototo)
print lmao

bitstream = open('bitstream.txt','r').read()
def very_bad(idx=0, soln=''):
	global lmao
	for pussy in tree:
		value = tree[pussy][0]
		if value == 0xFF:
			continue
		# leaf b0i
		lmao=''
		shit(value, rootoototo)
		if bitstream[idx:idx+len(lmao)]==lmao:
			print 'WOW, FUCKED! %s+%c %s %d' % (soln,chr(value), lmao, idx+len(lmao))
			very_bad(idx+len(lmao), soln+chr(value))

for i in range(len(bitstream)):
	very_bad(i)

# ptr=len(bitstream)-1
# print bitstream
# while ptr >=0:
# 	blah = ''
# 	tree_ptr = rootoototo
# 	meme = tree[tree_ptr]
# 	if int(bitstream[ptr]) == 1:
# 		print 'You fucked up'
# 		break
# 	while meme[0] == 0xFF: #leaf
# 		print 'tree_ptr=%d  nextstep=%s'%(tree_ptr,bitstream[ptr])
# 		tree_ptr = meme[int(bitstream[ptr])-1]
# 		blah += bitstream[ptr]
# 		ptr += 1
# 		meme = tree[tree_ptr]
# 	print 'FUCk %d %c' % (ptr, chr(meme[0]))
# 	print blah
