
code = open('flash', 'rb').read()
code = code[0x00013d40:0x00014000]
disasms = [None] * len(code)

def disas_one(pc):
    opc = code[pc + 1]
    if code[pc] != 0: opc = 0xff
    if disasms[pc] == False:
        print('WARNING: OVERLAPPING')
    if disasms[pc] != None:
        return []
    if pc >= len(code):
        return []

    simple = {
        0: 'add', 1: 'sub', 2: 'mult', 3: 'mod', 4: 'slt', 5: 'seq', 8: 'read1',
        10: 'get_flagind', 11: 'set_flagind', 12: 'pop', 13: 'exit',
    }

    onearg = {
        6: 'bne', 7: 'beq', 9: 'cns'
    }

    if opc in simple:
        disasms[pc] = simple[opc]
        disasms[pc+1] = False
        if opc == 13:
            return []
        else:
            return [pc + 2]
    elif opc in onearg:
        arg = (code[pc + 2] << 8) + code[pc + 3]
        disasms[pc+1] = False
        disasms[pc+2] = False
        disasms[pc+3] = False
        if opc == 9:
            disasms[pc] = onearg[opc] + ' ' + hex(arg)
            return [pc + 4]
        else:
            arg -= arg % 2
            if arg >= 2**15:
                arg -= 2**16
            nextpc = pc + 4 + arg
            disasms[pc] = onearg[opc] + ' ' + hex(nextpc)
            return [pc + 4, nextpc]
    else:
        print('INVALID OPCODE')
        return []

stack = [0]
while len(stack):
    stack += disas_one(stack.pop())

for pc, insn in enumerate(disasms):
    if insn == None:
        insn = 'db ' + hex(code[pc])
    if insn == False:
        continue
    print(f'{pc:04x}: {insn}')

