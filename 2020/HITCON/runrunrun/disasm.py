from braindead import *
from opcodes import OP_BY_ID, OPSIZE

args = Args()
args.add('LOAD', help='Dumped code section')
args.add('META', help='Dumped metadata')
args.parse()

pc2ln = {}
syms = {}

with open(args.META) as f:
	for line in f:
		if line.startswith('c0de7ab1'):
			for line in f:
				line = line.strip()
				if len(line) == 0:
					break
				filename, symbol, _, pc = line.split()
				pc = int(pc[:-1])
				pc2ln[pc] = (filename, symbol)
		elif line.startswith('5717b015'):
			for line in f:
				line = line.strip()
				if len(line) == 0:
					break
				symid, symname = line.split(': ')
				syms[int(symid)] = symname

prg = util.slurp(args.LOAD)
base = 0x10000000

pc = base

while pc-base < len(prg):
	op = prg[pc-base]
	if op not in OPSIZE:
		print(f'{pc:08}  {op:02x} .. .. .. ..  invalid')
	ops = OPSIZE[op]
	hx = []
	for i in range(min(9, ops)):
		hx.append(f'{prg[pc+i-base]:02x}')
	while len(hx) < 9:
		hx.append('..')

	if op not in OP_BY_ID:
		print('wtf')
		break
	opn = OP_BY_ID[op]


	arg_len = ops-1
	arg_val = int.from_bytes(prg[pc+1-base:pc+1-base+arg_len], 'big')
	if opn == 'SPUSH':
		arg_fmt = syms[arg_val]
	else:
		arg_fmt = f'0x{arg_val:x}'

	if pc in pc2ln:
		print(';', *pc2ln[pc])
	print(f'{pc:08x}  {" ".join(hx)}  {opn} {arg_fmt}')
	pc += ops
