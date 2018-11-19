from z3 import *

print "enter the robots' digits in order that they appeared"
vals = raw_input().strip().replace(' ', '')
vals = int(vals[::-1],16)
print hex(vals)

d = {}
n = {}
def makereg(r):
	global d, n
	if not r in n:
		n[r] = 0
	ver = n[r]
	n[r] += 1
	name = r + '_' + str(ver)
	var = BitVec(name, 32)
	d[name] = var
	return var
def getreg(r):
	global d,n
	return d[r + '_' + str(n[r] - 1)]

s = Solver()
def rand():
	global n
	result = BitVecVal(0x19660D, 32) * getreg('seed') + BitVecVal(0x3C6EF35F, 32);
	v = makereg('seed')
	s.add(v == result)
	return v

makereg('seed') # initial seed
cookie = rand()
aslrbase = rand()
robots = rand()
s.add(robots == BitVecVal(vals, 32))

print s.check()
m = s.model()
print m
print 'cookie = ' + hex(int(str(m.eval(cookie))))
print 'aslr base = ' + hex(int(str(simplify(BitVecVal(0x8014, 32) + (m.eval(aslrbase) & BitVecVal(0xfff, 32))))))

