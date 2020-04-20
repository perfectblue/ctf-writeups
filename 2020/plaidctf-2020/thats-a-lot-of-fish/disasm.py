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
    

code = list(map(toNum, eval(open('code').read())))
code = [0] * 19 + code
ip = 19
#ip = 0x81 - 19
while ip < len(code):
    opc = code[ip]
    if opc == 0:
        insn(ip, 2, 'hlt', code[ip+1])
        ip+=2
    elif opc == 1:
        insn(ip, 3, 'mov', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 2:
        insn(ip, 3, 'add', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 3:
        insn(ip, 3, 'mult', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 4:
        insn(ip, 3, 'and', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 5:
        insn(ip, 3, 'or', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 6:
        insn(ip, 3, 'xor', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 7:
        insn(ip, 3, 'cmpandset', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 8:
        insn(ip, 3, 'dec', code[ip+1], code[ip+2])
        ip+=3
    elif opc == 9:
        if (code[ip + 1] & 3) == 0:
            insn(ip, 3, f'jmp 0x{(ip + 2 + (code[ip + 1] >> 2))&0xffff:x}')
        else:
            insn(ip, 3, f'jmp 0x{ip + 2:x} +', code[ip + 1])
        ip+=2
    elif opc == 10:
        if (code[ip + 1] & 3) == 0:
            insn(ip, 3, f'jz 0x{ip + 3 + (code[ip + 1] >> 2):x}', code[ip+2])
        else:
            insn(ip, 3, f'jz 0x{ip + 3:x} +', code[ip + 1], code[ip+2])
        ip+=3
    elif opc == 11:
        insn(ip, 4, 'writetree', code[ip+1], code[ip+2], code[ip+3])
        ip += 4
    elif opc == 12:
        insn(ip, 4, 'readtree', code[ip+1], code[ip+2], code[ip+3])
        ip += 4
    elif opc == 13:
        insn(ip, 3, 'mov16', code[ip+1], code[ip+2])
        ip += 3
    elif opc == 14:
        insn(ip, 2, f'call', code[ip+1])
        ip += 2
    elif opc == 15:
        insn(ip, 1, 'ret')
        ip += 1
    else:
        insn(ip, 0, f'db 0x{code[ip]:x}')
        ip += 1
