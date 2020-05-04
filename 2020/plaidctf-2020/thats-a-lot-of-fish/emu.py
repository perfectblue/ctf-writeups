#!/usr/bin/env python3

def toNum(n):
    ret = 0
    for i,v in enumerate(n):
        ret += (1 << i) * v
    return ret

def insn(ip, size, insn, *ops):
    hexd = ' '.join([f'{x:02x}' for x in code[ip:ip+size]])
    if hexd: hexd += ':'
    head = f'{ip:02x}: {hexd}'
    opsstr = ", ".join(map(getop, ops))
    print(f'{head.ljust(16)} {insn} {opsstr}')

def getop(num):
    val = num >> 2
    typ = num & 3
    if typ == 0:
        return hex(val)
    elif typ == 1:
        return 'r' + str(val)
    elif typ == 2:
        return f'[0x{val:x}]'
    else:
        return f'[r{val & 3} + {val >> 2}]'
    
regs = [0, 0, 0, 0]
def readSrcOp(num):
    val = num >> 2
    typ = num & 3
    if typ == 0:
        return val
    elif typ == 1:
        return regs[val]
    elif typ == 2:
        return code[val] 
    else:
        return code[regs[val & 3] + (val >> 2)]

def writeDstOp(num, out):
    val = num >> 2
    typ = num & 3
    if typ == 0:
        assert(False)
    if typ == 1:
        regs[val] = out
    elif typ == 2:
        code[val] = out
    else:
        code[regs[val & 3] + (val >> 2)] = out

def print_op(ip):
    opc = code[ip]
    if opc == 0:
        insn(ip, 2, 'hlt', code[ip+1])
    elif opc == 1:
        insn(ip, 3, 'mov', code[ip+1], code[ip+2])
    elif opc == 2:
        insn(ip, 3, 'add', code[ip+1], code[ip+2])
    elif opc == 3:
        insn(ip, 3, 'mult', code[ip+1], code[ip+2])
    elif opc == 4:
        insn(ip, 3, 'and', code[ip+1], code[ip+2])
    elif opc == 5:
        insn(ip, 3, 'or', code[ip+1], code[ip+2])
    elif opc == 6:
        insn(ip, 3, 'xor', code[ip+1], code[ip+2])
    elif opc == 7:
        insn(ip, 3, 'cmpandset', code[ip+1], code[ip+2])
    elif opc == 8:
        insn(ip, 3, 'neg', code[ip+1], code[ip+2])
    elif opc == 9:
        if (code[ip + 1] & 3) == 0:
            insn(ip, 3, f'jmp 0x{(ip + 2 + (code[ip + 1] >> 2))&0xffff:x}')
        else:
            insn(ip, 3, f'jmp 0x{ip + 2:x} +', code[ip + 1])
    elif opc == 10:
        if (code[ip + 1] & 3) == 0:
            insn(ip, 3, f'jz 0x{ip + 3 + (code[ip + 1] >> 2):x}', code[ip+2])
        else:
            insn(ip, 3, f'jz 0x{ip + 3:x} +', code[ip + 1], code[ip+2])
    elif opc == 11:
        insn(ip, 4, 'writetree', code[ip+1], code[ip+2], code[ip+3])
    elif opc == 12:
        insn(ip, 4, 'readtree', code[ip+1], code[ip+2], code[ip+3])
    elif opc == 13:
        insn(ip, 3, 'mov16', code[ip+1], code[ip+2])
    elif opc == 14:
        insn(ip, 2, f'call', code[ip+1])
    elif opc == 15:
        insn(ip, 1, 'ret')
    else:
        insn(ip, 0, f'db 0x{code[ip]:x}')
    return ip

heap = []
stack = []
breaks = []
def run_op(ip):
    global runip
    runip += 1
    opc = code[ip]
    if opc == 0: # return
        print('Return ' + str(readSrcOp(code[ip+1])))
        quit()
    elif opc == 1: # mov
        writeDstOp(code[ip+1], readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 2: # add
        writeDstOp(code[ip+1], readSrcOp(code[ip+1]) + readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 3: # mult
        writeDstOp(code[ip+1], readSrcOp(code[ip+1]) * readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 4: # and
        writeDstOp(code[ip+1], readSrcOp(code[ip+1]) & readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 5: # or
        writeDstOp(code[ip+1], readSrcOp(code[ip+1]) | readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 6: # xor
        writeDstOp(code[ip+1], readSrcOp(code[ip+1]) ^ readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 7: # cmpandsetne
        if readSrcOp(code[ip+1]) == readSrcOp(code[ip+2]):
            writeDstOp(code[ip+1], 0)
        else:
            writeDstOp(code[ip+1], 1)
        ip+=3
    elif opc == 8: # neg
        writeDstOp(code[ip+1], -readSrcOp(code[ip+2]))
        ip+=3
    elif opc == 9: # jmp
        ip = (ip + readSrcOp(code[ip+1]) + 2) & 0xffff
    elif opc == 10: # jz
        off = readSrcOp(code[ip+1])
        if readSrcOp(code[ip+2]) == 0:
            ip = (off + ip + 3) & 0xffff
        else:
            ip += 3
    elif opc == 11: # writetree
        key = readSrcOp(code[ip+2])
        heap.append(key)
        heap.sort()
        ip += 4
    elif opc == 12: # readtree
        writeDstOp(code[ip+1], heap[0])
        del heap[0]
        ip += 4
    elif opc == 13:
        writeDstOp(code[ip+1], readSrcOp(code[ip+2]) & 0xffff)
        ip += 3
    elif opc == 14:
        stack.append(ip + 2)
        ip = readSrcOp(code[ip+1])
    elif opc == 15:
        ip = stack.pop()
    else:
        print('BAD OPCODE')
        ip += 1
    return ip

code = list(map(toNum, eval(open('code').read())))
inp = [0,9,15,2,1,4,3,8,10,5,13,11,14,6,7,12,0]
#inp = [0,9,1,2,3,4,5,6,7,8,10,11,12,13,14,15,0]
code = [0, 0] + inp + code

runip = 0
printed = -1
ip = 19
prev = -1
#ip = 0x81 - 19
while ip < len(code): 
    if printed != runip: 
        print('Zero: ', hex(code[0]))
        print('Stack:', stack)
        print('Registers:', regs)
        print('IP: ' + hex(ip))
        print_op(ip)
        printed = runip

    inp = input('> ').strip().lower().split()
    if not len(inp):
        if not prev: continue
        inp = prev 
    else:
        prev = inp

    if inp[0] == 'si':
        ip = run_op(ip) 
        continue
    elif inp[0] == 'fin':
        if len(stack) == 0: 
            print('Already at bottom stack frame')
            continue
        stck_exp = len(stack) - 1
        ip = run_op(ip)
    elif inp[0] == 'ni':
        stck_exp = len(stack)
        ip = run_op(ip)
    elif inp[0] == 'c':
        while True:
            ip = run_op(ip)
            if ip in breaks: break
        continue
    elif inp[0] == 'b':
        try:
            bp = int(inp[1], 0)
            breaks.append(bp)
            print(f'break 0x{bp:x}')
        except:
            print('Failed')
        continue
    elif inp[0] == 'x':
        try:
            addr = int(inp[1], 0)
            print(f'0x{addr}: {code[addr]}')
        except:
            print('Failed')
        continue
    else:
        print('Bad choice')
        continue

    while len(stack) != stck_exp:
        ip = run_op(ip)
        if ip in breaks: break

