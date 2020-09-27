#!/usr/bin/python3
from braindead import *
log.enable()
args = Args()
args.parse()

backend = io.process('./target/release/xor_and_shit', stderr='pass')
backend.rla("ready")

CACHE = {}
def x_at(pos):
	if pos in CACHE:
		return CACHE[pos]
	backend.sl(str(pos))
	out = int(backend.rl().decode(), 10)
	CACHE[pos] = out
	return out

def randgen_at(pos):
	if pos == 0:
		return 1
	elif pos < 64:
		return (pos+1 + x_at(pos-1))
	elif pos == 64:
		return x_at(pos-1)
	else:
		return (x_at(pos-1) + x_at(pos-64)) & ((1<<64)-1)

POS = 0

def init():
	global POS
	POS = 0
	return

def randgen():
	global POS
	out = randgen_at(POS)
	POS += 1
	return out

def jump(to):
	global POS
	POS += to

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

#check_jump()

init()
#for a in range(31337):randgen()
jump(31337)

#flag = open("flag.txt").read()
enc = util.slurp('enc.dat')
pad = b""

status = open('status.txt', 'a')

for x in range(256):
	buf = randgen()
	sh = x//2
	if sh > 64:sh = 64
	mask = (1 << sh) - 1
	buf &= mask
	jump(buf)
	pad += bytes([ 0 ^ (randgen() & 0xff) ])
	print(POS, pad.hex())
	print(POS, pad.hex(), file=status)
	status.flush()
	print(pretty.hexdump(0, bytes(util.xor(pad, enc))))

