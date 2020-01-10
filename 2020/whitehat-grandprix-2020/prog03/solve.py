from pwn import *
from z3 import *

bool_vals = {}

for c in string.uppercase:
    bool_vals[c] = Bool(c)
bool_vals['1'] = True
bool_vals['0'] = False

ops = ['+', '*', '~']

# def parse_expr(e):
#     if e[0] == '~' and e[1] == '(':
#         assert e[-1] == ')'
#         return Not(parse_expr(e[1:-1]))
#     curr_val = None
#     if e[0] == '~' and e[1] in bool_vals.keys():
#         curr_val = Not(bool_vals[e[1]])
#     elif e[0] in bool_vals:
#         curr_val = bool_vals[e[0]]

def calc(op, num1, num2):
    if op == '~':
        assert num1 is None
        return Not(num2)
    if op == '+':
        return Or(num1, num2)
    if op == '*':
        return And(num1, num2)
    assert False

def parse_expr(expr):
    expr = list(expr)
    stackChr = list() # character stack
    stackNum = list() # number stack
    while len(expr) > 0:
        c = expr.pop(0)
        if c in bool_vals:
            stackNum.append(bool_vals[c])
        elif c in ops:
            while True:
                if len(stackChr) > 0: top = stackChr[-1]
                else: top = ""
                if top in ops:
                    if c != "~":
                        num2 = stackNum.pop()
                        op = stackChr.pop()
                        num1 = None
                        if op == '+' or op == '*':
                            num1 = stackNum.pop()
                        stackNum.append(calc(op, num1, num2))
                    else:
                        stackChr.append(c)
                        break
                else:
                    stackChr.append(c)
                    break
        elif c == "(":
            stackChr.append(c)
        elif c == ")":
            while len(stackChr) > 0:
                c = stackChr.pop()
                if c == "(":
                    break
                elif c in ops:
                    num2 = stackNum.pop()
                    num1 = None
                    if c == '+' or c == '*':
                        num1 = stackNum.pop()
                    stackNum.append(calc(c, num1, num2))

    while len(stackChr) > 0:
        c = stackChr.pop()
        if c == "(":
            break
        elif c in ops:
            num2 = stackNum.pop()
            num1 = None
            if c == '+' or c == '*':
                num1 = stackNum.pop()
            stackNum.append(calc(c, num1, num2))

    return stackNum.pop()


# import ipdb
# ipdb.set_trace()
# print parse_expr("~(A*~A)")
# exit()

proc = remote('52.78.36.66', 82)
proc.recvuntil("[YES/NO]\n")

while True:
    e1 = proc.recvline().strip().split(": ")[1]
    e2 = proc.recvline().strip().split(": ")[1]
    print e1
    print e2

    z1 = parse_expr(e1)
    z2 = parse_expr(e2)
    print z1
    print z2
    s = Solver()
    s.add(z1 != z2)
    if s.check() == unsat:
        print "YES"
        proc.sendline("YES")
    else:
        print "NO"
        proc.sendline("NO")
    print proc.recvline()

