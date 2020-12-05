from math import *
from collections import defaultdict
import pickle
import os
import logging

_log = logging.getLogger(__name__)

candidates = []
allcandidates = []

for i in range(10000):
	code = f'{i:04}'
	if len(set(code)) == 4:
		candidates.append(code)
	allcandidates.append(code)

candidate_to_int = {c: i for i, c in enumerate(candidates)}
#print(log2(len(candidates)))

def match(expected, received):
	a = 0
	b = 0
	for i in range(4):
		j = expected.find(received[i])
		if i == j:
			a += 1
		elif j != -1:
			b += 1
	return a*5 + b

def find_split(universe):
	if len(universe) == 1:
		leaf = tuple(universe)[0]
		return leaf
	besth = -100000000
	bestq = None
	n = len(universe)

	for q in allcandidates:
		split = defaultdict(set)
		for c in universe:
			split[match(c, q)].add(c)

		h = 0

		for _, sub in split.items():
			p = len(sub)/n
			h -= p*log2(p)
		#maxsize = max(len(s) for s in split.values())
		#h = -maxsize*1

		#print(h, q)
		if h > besth:
			besth = h
			bestq = q

	h = besth
	q = bestq
	split = defaultdict(set)
	for c in universe:
		split[match(c, q)].add(c)
	print({k: len(v) for k, v in split.items()})

	#print('best query is', q, 'with entropy', h)
	branch = {}
	for resp, sub in split.items():
		p = len(sub) / n
		branch[resp] = (p, find_split(sub))
	return q, branch

def dump_tree(tree, d):
	if isinstance(tree, str):
		print('  '*d, 'leaf', tree)
	else:
		query, branch = tree
		print('  '*d, 'ask', query)
		for resp, (w, subtree) in sorted(branch.items()):
			print('  '*d, '->', w, resp)
			dump_tree(subtree, d+1)

def avg_len(tree):
	if isinstance(tree, str):
		return 0, 0
	else:
		query, branch = tree
		s = 0
		maxd = 0
		for resp, (w, subtree) in branch.items():
			cost, d = avg_len(subtree)
			s += w*cost
			maxd = max(maxd, d)
		return 1+s, 1+maxd

def solve_pin(oracle):
	t = TREE
	while True:
		if isinstance(t, str):
			return t
		else:
			query, branch = t
			resp = oracle(query)
			t = branch[resp][1]

if not os.path.exists("tree.pickle"):
	#print('precalculating tree... (will take some time)')
	TREE = find_split(candidates)
	with open("tree.pickle", "wb") as f:
		pickle.dump(TREE, f)
else:
	#print('using cached tree')
	with open("tree.pickle", "rb") as f:
		TREE = pickle.load(f)
#dump_tree(tree, 0)
_log.info('average number of queries: %s', avg_len(TREE)[0])

if __name__ == '__main__':
	import random
	qc = 0
	def oracle(q):
		global qc
		qc += 1
		return match(pin, q)
	n = 100000
	for _ in range(n):
		pin = random.choice(candidates)
		qc = 0
		pin_recov = solve_pin(oracle)
		print(qc)
		assert pin == pin_recov
