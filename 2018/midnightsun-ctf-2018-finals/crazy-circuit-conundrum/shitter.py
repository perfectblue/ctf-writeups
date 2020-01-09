scope = """5	=	AND(1,2,3,4,6,7,8,9)
1	=	28
28	=	AND(26, 27)
26	=	74
78	=	NOT(73)
73	=	A
27	=	B
2	=	31
31	=	AND(29,30)
29	=	95
95	=	NOT(94)
94	=	M
30	=	G
3	=	24
24	=	AND(22,23)
22	=	E
23	=	O
4	=	21
21	=	AND(19,20)
20	=	K
19	=	90
90	=	NOT(89)
89	=	H
6	=	34
34	=	AND(32, 33)
32	=	74
74	=	NOT(73)
73	=	A
33	=	78
78	=	NOT(77)
77	=	C
7	=	35
35	=	AND(133,134)
133	=	33
134	=	42
8	=	43
43	=	AND(41,42)
41	=	86
86	=	NOT(85)
85	=	D
42	=	105
105	=	NOT(104)
104	=	P
9	=	40
40	=	AND(38,39)
38	=	F
39	=	41"""

unknowns = 'ABCDEFGHIJKLMNOP'
from z3 import *

class AndExpr(object):
	def __init__(self, args):
		self.args = args
		assert(len(self.args) > 1)

	def __str__(self):
		return 'AND(' + ','.join(map(str, self.args)) + ')'

	def z3(self):
		result = self.args[0].z3()
		for i in range(1, len(self.args)):
			result = And(result, self.args[i].z3())
		return result

class ImmExpr(object):
	def __init__(self, imm):
		self.imm = imm

	def __str__(self):
		return 'imm:' + str(self.imm)

	def z3(self):
		return Bool(self.imm)

class VarExpr(object):
	def __init__(self, identifier):
		self.identifier = identifier

	def __str__(self):
		return 'var:' + str(self.identifier)

	def z3(self):
		# assert(False)
		return Bool(self.identifier)

class NotExpr(object):
	def __init__(self, expr):
		self.args = [expr]
		self.expr = expr

	def __str__(self):
		return 'NOT(' + str(self.expr) + ')'

	def z3(self):
		return Not(self.expr.z3())

def evaluate(expr):
	global scope
	if type(expr) == ImmExpr:
		return expr, False
	if type(expr) == VarExpr:
		if expr.identifier in scope:
			return scope[expr.identifier], True
		else:
			return expr, False
	changed = False
	newArgs = []
	# print expr
	for arg in expr.args:
		# print arg
		newArg, changedArg = evaluate(arg)
		newArgs.append(newArg)
		changed = changed or changedArg
	if type(expr) == AndExpr:
		return AndExpr(newArgs), changed
	if type(expr) == NotExpr:
		assert(len(newArgs) == 1)
		return NotExpr(newArgs[0]), changed
	assert(False)

def parse(expr):
	if '(' not in expr:
		if expr in unknowns:
			return ImmExpr(expr)
		return VarExpr(expr)
	op = expr.split('(')[0]
	args = expr.split('(')[1].split(')')[0].split(',')
	args = map(parse, args)
	if op == 'AND':
		return AndExpr(args)
	if op == 'NOT':
		assert(len(args) == 1)
		return NotExpr(args[0])
	assert(False)


scope = scope.split('\n')
scope = dict(map(lambda l: l.replace('\t', '').replace(' ', '').split('='), scope))

for identifier, expr in scope.iteritems():
	scope[identifier] = parse(expr)

# for identifier, expr in scope.iteritems():
	# print '%s = %s' % (identifier, expr)

while True:
	changed = False
	for identifier, expr in scope.iteritems():
		newVal, curChanged = evaluate(expr)
		scope[identifier] = newVal
		changed = changed or curChanged
	if not changed:
		break

# for identifier, expr in scope.iteritems():
# 	print '%s = %s' % (identifier, expr)

# for identifier, expr in scope.iteritems():
	# z3expr = expr.z3()
	# print str(identifier) + '=' + str(expr) + '=' + str(z3expr) + '=' + str(simplify(z3expr))
	# s.add(z3expr)

solved = simplify(scope['5'].z3())
print solved

bits = ''
for var in list(unknowns):
	result = '?'
	if str(simplify(And(Bool(var), solved))) == 'False':
		result = '1'
	if str(simplify(And(Not(Bool(var)), solved))) == 'False':
		result = '0'
	print '%s = %s' % (var, result)
	bits += result
print bits
