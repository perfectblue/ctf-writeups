def print_op(insn, *ops):
    global pc, code

    line = insn
    ops2 = []
    size = 1;
    for optype in ops:
        if optype == 'imm':
            op = hex(code[pc + size])
            size += 1
        elif optype == '[imm]':
            op = '[' + hex(code[pc + size]) + ']'
            size += 1
        elif optype == 'rel':
            op = hex(pc - code[pc+size])
            size += 1
        else:
            op = optype
        ops2.append(op)
    oldpc = pc
    pc += size
    if ops2: ops = ','.join(ops2)
    else: ops = ''
    print(f'{oldpc:03x}: {insn} {ops}')

def step1():
    global pc, code
    o = code[pc]
    if o == 0x14: print_op('QUE', 'imm')
    elif o == 0x15: print_op('REM')
    elif o == 0x20: print_op('REM', '[imm]')
    elif o == 0x2a: print_op('QUE', '[imm]')
    elif o == 0x2b: print_op('QUE', '[bot]')
    elif o == 0x2c: print_op('REM', '[REM]')
    elif o == 0x30: print_op('REM', 'q2')
    elif o == 0x31: print_op('DIVMOD', 'q2', 'imm')
    elif o == 0x32: print_op('QUE', 'bot_b64')
    elif o == 0x33: print_op('ADD')
    elif o == 0x34: print_op('SUB')
    elif o == 0x35: print_op('MULT')
    elif o == 0x36: print_op('QUE', 'q2')
    elif o == 0x37: print_op('XOR')
    elif o == 0x3a: print_op('READ')
    elif o == 0x40: print_op('JNE', 'rel')
    elif o == 0x41: print_op('COPY')
    elif o == 0xab: print_op('EXIT_0')
    elif o == 0xff: print_op('EXIT_IFNE')

pc = 0
code = open('code2', 'rb').read()
while pc < len(code):
    step1()
