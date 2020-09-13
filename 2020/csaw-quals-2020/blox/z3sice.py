from z3 import *
import sys

# col-wise sums
xorsum_y = [
	[3, 2, 3, 2, 2],
	[0, 1, 3, 1, 0],
	[0, 2, 2, 2, 2],
	[0, 3, 0, 1, 0],
]
numminos_y = [
	[2, 2, 2, 2, 2],
	[3, 1, 2, 1, 3],
	[3, 1, 1, 1, 1],
	[3, 1, 3, 1, 3],
]

# row-wise sums
xorsum_x = [
	[1,2,3],
	[1,7,4],
	[1,1,1],
	[3,7,5]
]
numminos_x = [
	[5,2,3],
	[5,3,2],
	[1,5,1],
	[4,3,4]
]

board = [ [ Bool('board_%d_%d' % (y,x)) for x in range(12) ] for y in range(5) ]

s = Solver()

for i in range(4):
	for y in range(0, 5):
		xor_sum = BitVecVal(0, 2)
		num_minos = IntVal(0)
		for x in range (0, 3):
			xor_sum   = If(board[y][3*i + x], xor_sum ^ BitVecVal(x+1, 2), xor_sum)
			num_minos = If(board[y][3*i + x], num_minos+1, num_minos)
		s.add(xor_sum == xorsum_y[i][y])
		s.add(num_minos == numminos_y[i][y])
	for x in range(0, 3):
		xor_sum = BitVecVal(0, 3)
		num_minos = IntVal(0)
		for y in range (0, 5):
			xor_sum   = If(board[y][3*i + x], xor_sum ^ BitVecVal(y+1, 3), xor_sum)
			num_minos = If(board[y][3*i + x], num_minos+1, num_minos)
		s.add(xor_sum == xorsum_x[i][x])
		s.add(num_minos == numminos_x[i][x])

print s.check()
m = s.model()

for y in range(5):
	for x in range(12):
		if str(m.eval(board[y][x])) == 'True':
			sys.stdout.write('#')
		else:
			sys.stdout.write(' ')
	sys.stdout.write('\n')

