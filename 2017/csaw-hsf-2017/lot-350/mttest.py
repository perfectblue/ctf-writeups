#!/usr/bin/env python3

import random
from mt import untemper

def bindump(arr):
	return ''.join(map(lambda v:bin(v)[2:], arr))

values = []
for x in range(0, 1024):
	values.append(random.getrandbits(32))
print(bindump(values[0:5]))

mt_state = tuple(list(map(untemper, values[:624])) + [0])
#print(mt_state)
random.setstate((3, mt_state, None))
#print(random.getrandbits(32))
#print(bindump([random.randint(0,1000) for i in range(0,10)]))
print(bindump([random.getrandbits(int(1000).bit_length()) for i in range(0,10)]))
