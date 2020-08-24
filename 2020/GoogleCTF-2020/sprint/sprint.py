instrs = [
'%1$00038s%3$hn%1$65498s%1$28672s%9$hn',
'%1$00074s%3$hn%1$65462s%1$*8$s%7$hn',
'%1$00108s%3$hn%1$65428s%1$1s%6$hn',
'%1$00149s%3$hn%1$65387s%1$*8$s%1$2s%7$hn',
'%1$00183s%3$hn%1$65353s%1$1s%6$hn',
'%1$00218s%3$hn%1$65318s%1$2s%11$hn',
'%1$00264s%3$hn%1$65272s%1$*10$s%1$*10$s%17$hn',
'%1$00310s%3$hn%1$65226s%1$28672s%1$*16$s%7$hn',
'%1$00347s%3$hn%1$65189s%1$*5$s%15$hn',
'%14$c%1$00419s%2$c%4$s%1$65499s%3$hn',
'%1$00430s%3$hn%1$65106s%1$*10$s%1$*10$s%13$hn',
'%1$00468s%3$hn%1$65068s%1$65519s%7$hn',
'%1$00505s%3$hn%1$65031s%1$*12$s%6$hn',
'%1$00543s%3$hn%1$64993s%1$65520s%7$hn',
'%1$00580s%3$hn%1$64956s%1$*5$s%15$hn',
'%14$c%1$00186s%2$c%4$s%1$00429s%3$hn',
'%1$00663s%3$hn%1$64873s%1$*12$s%1$*12$s%17$hn',
'%1$00709s%3$hn%1$64827s%1$28672s%1$*16$s%7$hn',
'%1$00743s%3$hn%1$64793s%1$1s%6$hn',
'%1$00789s%3$hn%1$64747s%1$*12$s%1$*10$s%13$hn',
'%1$00430s%3$hn',
'%1$00847s%3$hn%1$64689s%1$*10$s%1$1s%11$hn',
'%10$c%1$64869s%2$c%4$s%1$01549s%3$hn',
'%1$00922s%3$hn%1$64614s%1$57344s%9$hn',
'%1$00957s%3$hn%1$64579s%1$0s%11$hn',
'%1$00993s%3$hn%1$64543s%1$*8$s%7$hn',
'%1$01030s%3$hn%1$64506s%1$*5$s%13$hn',
'%12$c%1$00014s%2$c%4$s%1$01051s%3$hn',
'%1$01185s%3$hn',
'%1$01129s%3$hn%1$64407s%1$*10$s%1$65535s%11$hn',
'%1$01170s%3$hn%1$64366s%1$*8$s%1$1s%9$hn',
'%1$00957s%3$hn',
'%1$01232s%3$hn%1$64304s%1$*10$s%1$00254s%17$hn',
'%16$c%1$00014s%2$c%4$s%1$01253s%3$hn',
'%1$01334s%3$hn',
'%1$01319s%3$hn%1$64217s%1$5s%23$hn',
'%1$05081s%3$hn',
'%1$01368s%3$hn%1$64168s%1$0s%9$hn',
'%1$01403s%3$hn%1$64133s%1$0s%11$hn',
'%1$01441s%3$hn%1$64095s%1$61696s%7$hn',
'%1$01478s%3$hn%1$64058s%1$*5$s%13$hn',
'%1$01513s%3$hn%1$64023s%1$1s%15$hn',
'%1$01548s%3$hn%1$63988s%1$0s%23$hn',
'%1$01593s%3$hn%1$63943s%1$57344s%1$*8$s%7$hn',
'%1$01630s%3$hn%1$63906s%1$*5$s%17$hn',
'%16$c%1$00014s%2$c%4$s%1$01651s%3$hn',
'%1$03479s%3$hn',
'%1$01723s%3$hn%1$63813s%1$*8$s%1$1s%9$hn',
'%1$01770s%3$hn%1$63766s%1$*16$s%1$65419s%19$hn',
'%18$c%1$00053s%2$c%4$s%1$01752s%3$hn',
'%1$01846s%3$hn%1$63690s%1$65520s%17$hn',
'%1$02373s%3$hn',
'%1$01908s%3$hn%1$63628s%1$*16$s%1$65422s%19$hn',
'%18$c%1$00049s%2$c%4$s%1$01894s%3$hn',
'%1$01980s%3$hn%1$63556s%1$1s%17$hn',
'%1$02373s%3$hn',
'%1$02042s%3$hn%1$63494s%1$*16$s%1$65436s%19$hn',
'%18$c%1$00050s%2$c%4$s%1$02027s%3$hn',
'%1$02115s%3$hn%1$63421s%1$16s%17$hn',
'%1$02373s%3$hn',
'%1$02177s%3$hn%1$63359s%1$*16$s%1$65428s%19$hn',
'%18$c%1$00053s%2$c%4$s%1$02159s%3$hn',
'%1$02253s%3$hn%1$63283s%1$65535s%17$hn',
'%1$02373s%3$hn',
'%1$02303s%3$hn%1$63233s%1$0s%15$hn',
'%1$02338s%3$hn%1$63198s%1$0s%17$hn',
'%1$02373s%3$hn%1$63163s%1$1s%23$hn',
'%1$02419s%3$hn%1$63117s%1$*12$s%1$*16$s%13$hn',
'%1$02457s%3$hn%1$63079s%1$65519s%7$hn',
'%1$02494s%3$hn%1$63042s%1$*12$s%6$hn',
'%1$02532s%3$hn%1$63004s%1$65520s%7$hn',
'%1$02569s%3$hn%1$62967s%1$*5$s%17$hn',
'%16$c%1$00822s%2$c%4$s%1$01782s%3$hn',
'%1$02652s%3$hn%1$62884s%1$61440s%1$*12$s%7$hn',
'%1$02689s%3$hn%1$62847s%1$*5$s%17$hn',
'%1$02727s%3$hn%1$62809s%1$65519s%7$hn',
'%1$02764s%3$hn%1$62772s%1$*16$s%6$hn',
'%1$02802s%3$hn%1$62734s%1$65520s%7$hn',
'%1$02836s%3$hn%1$62700s%1$0s%6$hn',
'%1$02874s%3$hn%1$62662s%1$65519s%7$hn',
'%1$02911s%3$hn%1$62625s%1$*5$s%17$hn',
'%1$02957s%3$hn%1$62579s%1$*16$s%1$*16$s%17$hn',
'%1$03003s%3$hn%1$62533s%1$28672s%1$*16$s%7$hn',
'%1$03040s%3$hn%1$62496s%1$*5$s%17$hn',
'%16$c%1$00266s%2$c%4$s%1$02809s%3$hn',
'%1$03120s%3$hn%1$62416s%1$*10$s%1$1s%17$hn',
'%1$03166s%3$hn%1$62370s%1$61698s%1$*16$s%7$hn',
'%1$03203s%3$hn%1$62333s%1$*5$s%17$hn',
'%1$03249s%3$hn%1$62287s%1$*16$s%1$*12$s%17$hn',
'%16$c%1$00042s%2$c%4$s%1$03242s%3$hn',
'%1$03329s%3$hn%1$62207s%1$*10$s%1$1s%11$hn',
'%1$01548s%3$hn',
'%1$03379s%3$hn%1$62157s%1$0s%15$hn',
'%1$03414s%3$hn%1$62122s%1$2s%23$hn',
'%1$01548s%3$hn',
'%1$03464s%3$hn%1$62072s%1$4s%23$hn',
'%1$65534s%3$hn',
'%14$c%1$00014s%2$c%4$s%1$03500s%3$hn',
'%1$05081s%3$hn',
'%1$03578s%3$hn%1$61958s%1$*10$s%1$65527s%17$hn',
'%16$c%1$00014s%2$c%4$s%1$03599s%3$hn',
'%1$03680s%3$hn',
'%1$03665s%3$hn%1$61871s%1$3s%23$hn',
'%1$05081s%3$hn',
'%1$03714s%3$hn%1$61822s%1$0s%9$hn',
'%1$03749s%3$hn%1$61787s%1$0s%11$hn',
'%1$03795s%3$hn%1$61741s%1$*8$s%1$65497s%13$hn',
'%12$c%1$00014s%2$c%4$s%1$03816s%3$hn',
'%1$04987s%3$hn',
'%1$03882s%3$hn%1$61654s%1$4s%15$hn',
'%1$03917s%3$hn%1$61619s%1$0s%13$hn',
'%1$03963s%3$hn%1$61573s%1$*12$s%1$*12$s%13$hn',
'%1$04009s%3$hn%1$61527s%1$*12$s%1$*12$s%13$hn',
'%1$04055s%3$hn%1$61481s%1$57344s%1$*10$s%7$hn',
'%1$04092s%3$hn%1$61444s%1$*5$s%17$hn',
'%1$04139s%3$hn%1$61397s%1$*16$s%1$65419s%19$hn',
'%18$c%1$00014s%2$c%4$s%1$04160s%3$hn',
'%1$04632s%3$hn',
'%1$04238s%3$hn%1$61298s%1$*16$s%1$65422s%19$hn',
'%18$c%1$00057s%2$c%4$s%1$04216s%3$hn',
'%1$04318s%3$hn%1$61218s%1$*12$s%1$1s%13$hn',
'%1$04632s%3$hn',
'%1$04380s%3$hn%1$61156s%1$*16$s%1$65436s%19$hn',
'%18$c%1$00057s%2$c%4$s%1$04358s%3$hn',
'%1$04460s%3$hn%1$61076s%1$*12$s%1$2s%13$hn',
'%1$04632s%3$hn',
'%1$04522s%3$hn%1$61014s%1$*16$s%1$65428s%19$hn',
'%18$c%1$00057s%2$c%4$s%1$04500s%3$hn',
'%1$04602s%3$hn%1$60934s%1$*12$s%1$3s%13$hn',
'%1$04632s%3$hn',
'%1$05081s%3$hn',
'%1$04675s%3$hn%1$60861s%1$*10$s%1$1s%11$hn',
'%1$04722s%3$hn%1$60814s%1$*14$s%1$65535s%15$hn',
'%14$c%1$64693s%2$c%4$s%1$05600s%3$hn',
'%1$04804s%3$hn%1$60732s%1$61708s%1$*8$s%7$hn',
'%1$04841s%3$hn%1$60695s%1$*5$s%15$hn',
'%1$04886s%3$hn%1$60650s%1$59392s%1$*8$s%7$hn',
'%1$04931s%3$hn%1$60605s%1$*14$s%1$*12$s%6$hn',
'%1$04972s%3$hn%1$60564s%1$*8$s%1$1s%9$hn',
'%1$03749s%3$hn',
'%1$05032s%3$hn%1$60504s%1$59392s%1$*8$s%7$hn',
'%1$05066s%3$hn%1$60470s%1$0s%6$hn',
'%1$65534s%3$hn',
'%1$05119s%3$hn%1$60417s%1$59392s%7$hn',
'%1$05153s%3$hn%1$60383s%1$0s%6$hn',
'%1$65534s%3$hn',
]

code = {}

class Microinstruction(object):
	def __init__(self):
		self.acc_delta = 0
		self.opcode = ''
		self.op1 = ''
		self.op2 = ''

operand_names = [
	'',
	'&nullstr',
	'0LL',
	'&pc',
	'&buffer',
	'*r1',
	'r1',
	'&r1',
	'r2',
	'&r2',
	'r3',
	'&r3',
	'r4',
	'&r4',
	'r5',
	'&r5',
	'r6',
	'&r6',
	'r7',
	'&r7',
	'r8',
	'&r8',
	'r9',
	'&r9'
]

def parse_microinstr(micro):
	# print(micro)
	i = micro.index('$')
	operand, operation = int(micro[:i]), micro[i+1:]
	operand_name = operand_names[operand]
	# print(operand_names[operand] + '.' + operation)
	mi = '?'
	if operand == 1: # &nullstr
		assert operation[-1] == 's'
		operation = operation[:-1]
		if operation[0] == '*': # register operand
			assert operation[-1] == '$'
			src_reg = int(operation[1:-1])
			src_name = operand_names[src_reg]
			mi = '+!' + src_name
		else:
			imm_val = operation[:]
			mi = '+#' + str(imm_val)
	elif operand == 2: # 0
		assert operation == 'c'
		mi = 'writechar 0'
	elif operand == 3: # &pc
		mi = 'set pc'
	elif operand == 4: # &buffer
		mi = 'writebuffer'
	elif operand == 5: # *r1
		assert False
	elif operand % 2 == 0: # 'rX'
		if operation.endswith('hn'): # write to virtual memory
			mi = 'store ' + operand_name
		elif operation.endswith('c'): # write reg as char
			mi = 'writechar ' + operand_name
		else:
			assert(False)
	elif operand % 2 == 1: # '&rX'
		assert operation.endswith('hn')
		assert operand_name[0] == '&'
		operand_name = operand_name[1:]
		mi = 'set ' + operand_name
		pass
	return mi
	# print(mi)

def parse_instr(instr):
	microinstrs = map(parse_microinstr, instr.split('%')[1:])
	assert len(microinstrs) >= 2
	macro = ''
	buffer_contents = []
	def calc_acc():
		result = ''
		acc_concrete = 0
		acc_symbolic = []
		for elemtype, elemval in buffer_contents:
			if elemtype == 'pad_concrete':
				acc_concrete += elemval
			elif elemtype == 'pad_variable':
				acc_symbolic.append(elemval)
			elif elemtype == 'charlit':
				acc_concrete += 1
			else:
				assert False
		acc_concrete = acc_concrete % 65536
		if acc_concrete >= 32768:
			acc_concrete = -(65536 - acc_concrete)
		if acc_symbolic:
			result += '+'.join(acc_symbolic)
		if acc_concrete:
			if acc_concrete > 0 and result:
				result += '+'
			result += str(acc_concrete)
		if not result:
			result = '0'
		return result

	for micro in microinstrs:
		if micro.startswith('+#'): # accumulate immediate
			acc_val = int(micro[2:], 10)
			buffer_contents.append(('pad_concrete', acc_val))
		elif micro.startswith('+!'): # accumulate variable
			acc_src = micro[2:]
			buffer_contents.append(('pad_variable', acc_src))
		elif micro.startswith('set '):
			dst = micro.split(' ')[1]
			if dst == 'pc' and calc_acc() == '-2':
				macro += 'halt; '
			else:
				macro += '%s=%s; ' % (dst, calc_acc())
		elif micro.startswith('store '):
			dst = micro.split(' ')[1]
			macro += '*%s=%s; ' % (dst, calc_acc())
		elif micro.startswith('writechar '):
			src = micro.split(' ')[1]
			buffer_contents.append(('charlit', src))
			# macro += micro + '; '
		elif micro == 'writebuffer':
			assert len(buffer_contents) == 3 
			assert buffer_contents[0][0] == 'charlit'
			assert buffer_contents[1][0] == 'pad_concrete'
			assert buffer_contents[2][0] == 'charlit' and buffer_contents[2][1] == '0'
			strlen_expr = '(' + buffer_contents[0][1] + '?' + str(int(calc_acc())-1) +  ':0)'
			buffer_contents.append(('pad_variable', strlen_expr))
			# macro += 'writebuffer; '
	# print(microinstrs)
	# print(macro)
	macro = macro.rstrip()
	return macro

pc = 0
for instr in instrs:
	code[pc] = parse_instr(instr)
	print(pc, instr, code[pc])
	pc += len(instr) + 1
