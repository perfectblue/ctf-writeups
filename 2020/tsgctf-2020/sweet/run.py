from decimal import *
getcontext().prec = 300

def pi():
	lasts, t, s, n, na, d, da = 0, Decimal(3), 3, 1, 0, 0, 24
	while s != lasts:
		lasts = s
		n, na = n + na, na + 8
		d, da = d + da, da + 32
		t = (t * n) / d
		s += t
	return s

PI = pi()

def sin(x):
	x = Decimal(x) % PI
	p, factor = 0, x
	for n in range(10000):
		p += factor
		factor *= - (x ** 2) / ((2 * n + 2) * (2 * n + 3))
		if factor == 0:
			break
	return p

with open('output.txt') as f:
	y = Decimal(f.read().strip())
print(y)

#flag = int.from_bytes(open('flag.txt', 'rb').read(), byteorder='big')
#assert(flag < 2 ** 500)
#print(sin(flag))


if True:
	l = Decimal(0)
	r = PI/2

	while l != r:
		m = l + (r-l)/2
		ym = sin(m)
		print('range:', r-l)
		print('value:', m)
		print('error:', ym-y)
		if ym <= y:
			l = m
		else:
			r = m

x = Decimal('0.163175637602740964490722062267061389696088139158230600899046968672190506743495294736990774853241661073016774001982145726962910253737719770054606991776546791738735108712813938709131029475508398263190389434698312411911642837531652804269120745335974869150072258589701323425678679477710769757658218467270')
print(PI-x)
print(x)
print(sin(x))
print(sin(PI-x))
print(int(x*10**300))
print(int(PI*10**300))
