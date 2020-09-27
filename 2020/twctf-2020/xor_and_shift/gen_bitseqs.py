#!/usr/bin/python3
from braindead import *
log.enable()


s = []
p = 0

def init():
	global s,p
	s = [i for i in range(0,64)]
	p = 0
	return

def randgen():
	global s,p
	a = 3
	b = 13
	c = 37
	s0 = s[p]
	p = (p + 1) & 63
	s1 = s[p]
	#res = (s0 + s1) & ((1<<64)-1)
	s1 ^= (s1 << a) & ((1<<64)-1)
	s[p] = (s1 ^ s0 ^ (s1 >> b) ^ (s0 >> c))	& ((1<<64)-1)
	return s[p]

def jump(to):
	log.info('jumping to %s', to)

	for _ in log.withprogress(range(to)):
		randgen()

	return

def check_jump():
	init()
	jump(10000)
	assert randgen() == 7239098760540678124

	init()
	jump(100000)
	assert randgen() == 17366362210940280642

	init()
	jump(1000000)
	assert randgen() == 13353821705405689004

	init()
	jump(10000000)
	assert randgen() == 1441702120537313559

	init()
	for a in range(31337):randgen()
	for a in range(1234567):randgen()
	buf = randgen()
	for a in range(7890123):randgen()
	buf2 = randgen()
	init()
	jump(31337+1234567)
	print (buf == randgen())	
	jump(7890123)
	print (buf2 == randgen())

init()

prev = randgen()

if False:
	seqs = []
	for i in range(64):
		seqs.append(open(f'{i}.seq', 'w'))

	init()
	for i in range(4096*3):
		x = randgen()
		for j in range(64):
			print(x>>j&1, file=seqs[j])
