import sys
import heapq
import re

def info(*a):
	print('[*]', *a, file=sys.stderr)

def lcp(a, b):
	n = 0
	while n < len(a) and n < len(b):
		if a[n] != b[n]:
			return n
		n += 1
	return n

def check(old, new):
	n = 0
	for x in new:
		if n == len(old):
			return True
		if old[n] == x:
			n += 1
	return False

def diff(old, new):
	q = []
	l = lcp(old, new)
	q.append((0, -l, l))
	cache = {}
	cache[(l, l)] = (0, 0, 0)
	last_hops = -1

	while len(q) > 0:
		hops, om, nm = heapq.heappop(q)
		om = -om
		assert hops  >= last_hops
		last_hops = hops

		if om == len(old) and nm == len(new):
			info('patch found in', hops, 'hops')
			insertions = []
			while nm != 0:
				om, nm, jump = cache[om, nm]
				if jump > 0:
					info('insert', repr(new[nm:nm+jump]), 'at', nm)
					insertions.append((nm, jump))
			return insertions

		for jump in range(1, 1+len(new)-nm - (len(old)-om)):
			l = lcp(old[om:], new[nm+jump:])
			if l > 0:
				key = (om+l, nm+jump+l)
				if key not in cache:
					cache[key] = (om, nm, jump)
					heapq.heappush(q, (hops+1, -(om+l), nm+jump+l))

def cksum(s):
	x = 1
	for s in s:
		x = (x+ord(s))*40934553968048535861605823663048498355%275206153406265540195899882023086804979
	return x

WS_RE = re.compile(r'[ \n\t]+')
def minify(s): return WS_RE.sub(' ', s)

def enc(s): return str(list(map(ord, s))).replace(' ', '')

with open(sys.argv[1]) as f:
	old = f.read()
with open(sys.argv[2]) as f:
	new = f.read()

if check(old, new):
	info('new is not a supersequence of old')
	sys.exit(1)
else:
	ins = diff(old, new)

suffix = ''
suffix += '''
__tohru_fmt(x) {
	__tohru_o = "[";
	__tohru_i = 1;
	__tohru_n = len(x);
	__tohru_o = __tohru_o+int2str(x[0]);
	while (__tohru_i < __tohru_n) {
		__tohru_o = __tohru_o+","+int2str(x[__tohru_i]);
		__tohru_i = __tohru_i + 1;
	}
	return __tohru_o+"]";
}

__tohru_fmt2(x) {
	return "["+__tohru_fmt(x[0])+","+__tohru_fmt(x[1])+"]";
}

__tohru_expand(x, y) {
	return x[0]+__tohru_fmt2(y)+x[1];
}

__tohru_self(q) {
	return __tohru_expand(q, q);
}

__tohru_read() {
	if (__tohru_ofs >= 0) {
		__tohru_t = __tohru_buffer[__tohru_ofs];
		__tohru_ofs = __tohru_ofs+1;
		if (__tohru_ofs >= len(__tohru_buffer)) {
			__tohru_ofs = -1;
		}
	} else {
		__tohru_t = read();
		if (__tohru_flag && __tohru_t == 59) {
			__tohru_ofs = 0;
			__tohru_buffer = "write(flag);";
			__tohru_state = 0;
		}
	}
	__tohru_state = (__tohru_t+__tohru_state)*40934553968048535861605823663048498355%275206153406265540195899882023086804979;
'''

full_sum = cksum(new)

flag_trigger = cksum('flag; main(){ flag = "')
flag_trigger2 = cksum(' write(')

for (pos, n) in ins:
	s = cksum(new[:pos])
	payload = [ord(x) for x in new[pos:pos+n]]
	suffix += (f'if (__tohru_state == {s}) {{ __tohru_ofs = 0; __tohru_buffer = {payload}; }}\n')

suffix += (f'if (__tohru_state == {flag_trigger}) {{ __tohru_flag = 1; }}\n')
suffix += (f'if (__tohru_state == {full_sum}) {{ __tohru_ofs = 0; __tohru_buffer = __tohru_self(DEEP_MAGIC); }}\n')

suffix += '''
	return __tohru_t;
}
'''

suffix = minify(suffix);
info('minified: ', repr(suffix))
l = suffix.index('DEEP_MAGIC')
r = l+len('DEEP_MAGIC')
t = "[" + enc(suffix[:l]) + "," + enc(suffix[r:]) + "]"
suffix = suffix[:l] + t + suffix[r:]

sys.stdout.write(new)
sys.stdout.write(suffix)
