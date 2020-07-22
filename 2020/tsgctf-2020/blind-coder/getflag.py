from braindead import *
log.enable()
args = Args()
args.parse()

remote = io.connect(('35.221.81.216', 65532))

from random import randrange, shuffle
from math import log2
from interpreter import interpret

QUERY_CNT = 0
def oracle(selector):
	global QUERY_CNT
	QUERY_CNT += 1
	print('query', QUERY_CNT)

	remote.sla('Choice: ', '1')
	remote.sla('here: ', selector)
	return int(remote.rla('passed').decode().split()[0])

def single_oracle(s):
	return oracle(f'{s.l} <= N && N < {s.m} ? N%10 : 99')

def double_oracle(s, t, sm, tm):
	x = []
	for s, m in zip((s, t), (sm, tm)):
		if m == 0:
			x.append(f'{s.l} <= N && N < {s.m}')
		else:
			x.append(f'{s.m} <= N && N < {s.r}')
	x = ' || '.join(x) + '? N%10 : 99'
	return oracle(x)

class Span:
	def __init__(self, l, r, n):
		self.l = l
		self.r = r
		self.n = n
		self.is_dead = False

	def points(self): return self.r - self.l

	@property
	def m(self): return (self.r+self.l)//2

	def __repr__(self): return f'Span({self.l}, {self.r}, {self.n})'

	def in_half(self, x, mode):
		if mode == 0:
			return self.l <= x and x < self.m
		else:
			return self.m <= x and x < self.r

entangled = []

q = [Span(0, 1<<32, 50)]
recov = set()
while True:
	nq = []
	for s in q:
		if s.is_dead:
			continue
		assert s.n <= s.r-s.l
		if s.n == s.r-s.l:
			print('Saturated', s)
			for i in range(s.l, s.r):
				print('FOUND', i)
				recov.add(i)
		elif s.n > 0:
			nq.append(s)
	q = nq
	if len(q) == 0:
		break

	print(len(q), 50-len(recov), sum((s.points() for s in q)))
	assert sum((s.n for s in q))+len(recov) == 50
	shuffle(q)
	q.sort(key=lambda s: s.n)

	if q[-1].n > 1 or len(q) == 1:
		# single query
		s = q.pop()
		print('single', s)
		ans = single_oracle(s)
		q.append(Span(s.l, s.m, ans))
		q.append(Span(s.m, s.r, s.n-ans))
	else:
		update = []

		# double query
		s = q.pop()
		t = q.pop()
		assert s.n == 1 and t.n == 1
		print('double', s, t)
		s_flip = randrange(2)
		t_flip = randrange(2)
		#ans = oracle(lambda x: s.in_half(x, s_flip) or t.in_half(x, t_flip))
		ans = double_oracle(s, t, s_flip, t_flip)
		print(' =>', ans)
		assert ans in (0, 1, 2)
		if ans == 0:
			update.append((0^s_flip, s))
			update.append((0^t_flip, t))
		elif ans == 2:
			update.append((1^s_flip, s))
			update.append((1^t_flip, t))
		else:
			q.append(s)
			q.append(t)
			entangled.append((set((s, t)), s_flip^t_flip))

		def split(s, ans):
			print('split', s, 'by', ans)
			if ans == 0:
				q.append(Span(s.m, s.r, 1))
			else:
				q.append(Span(s.l, s.m, 1))

		while len(update):
			ans, s = update.pop()
			if s.is_dead:
				continue
			s.is_dead = True
			split(s, ans)
			new_entangled = []
			for pair, mode in entangled:
				if s not in pair:
					new_entangled.append((pair, mode))
					continue
				pair.remove(s)
				t = next(iter(pair))
				print('were entangled:', s, t)
				update.append((mode^1^ans, t))
			entangled = new_entangled

remote.sla('Choice: ', '2')
remote.sla('what: ', ' '.join(map(str, recov))))
io.interactive(remote)
