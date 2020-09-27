import json
import random
import math

with open('output') as f:
	globals().update(json.load(f))

n = int(n)
e1 = int(e1)
e2 = int(e2)
enc = int(enc)

print(n)

r = 2*e2*e1 - (e1 - e2)
d = pow(e1, -1, r)

msg = pow(enc, d, n)
print(msg.to_bytes(100, 'big'))
