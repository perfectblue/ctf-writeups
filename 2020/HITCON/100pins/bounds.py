import random
import struct

N = 5040
bounds = [-1]
with open('bounds.txt') as f:
	for line in f:
		val, hi, lo = map(int, line.split())
		bounds.append((hi<<32) + (lo&0xffffffff));

def bits_to_double(b):
	buf = struct.pack('<Q', b)
	return struct.unpack('<d', buf)[0]

def rng_to_double(b):
	assert b>>52 == 0
	return bits_to_double(b|0x3FF0000000000000)-1

def to_pin(f):
	return int(f*N)

masks = []
avg_sice = 0
for i in range(N):
	l = bounds[i]+1
	r = bounds[i+1]
	b = 0
	mask = (1<<52)-1
	while (l^r)&mask != 0:
		mask ^= 1<<b
		b += 1

	assert (l^r)&mask == 0
	avg_sice += f'{mask:064b}'.count('1')

	print(f'{i:4} {l:064b} {mask:064b}')
	masks.append((l&mask, mask))

print('average sice:', avg_sice/N)

for _ in range(1000000):
	b = random.getrandbits(64)>>12
	f = rng_to_double(b)
	pin = to_pin(f)
	const, mask = masks[pin]
	assert (b^const)&mask == 0
