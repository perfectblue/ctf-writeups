import random
import socket
import time
import string

class InvalidExpressionError(ValueError):
    pass

subtract = lambda x,y: x-y
def add(x,y):
    return x+y
def multiply(x,y):
    return x*y
def divide(x,y):
    if y == 0:
        raise InvalidExpressionError
    return float(x)/y

add.display_string = '+'
multiply.display_string = '*'
subtract.display_string = '-'
divide.display_string = '/'

standard_operators = [ add, subtract, multiply, divide ]

class Expression(object): pass

class TerminalExpression(Expression):
    def __init__(self,value,remaining_sources):
        self.value = value
        self.remaining_sources = remaining_sources
    def __str__(self):
        return str(self.value)
    def __repr__(self):
        return str(self.value)

class BranchedExpression(Expression):
    def __init__(self,operator,lhs,rhs,remaining_sources):
        self.operator = operator
        self.lhs = lhs
        self.rhs = rhs
        self.value = operator(lhs.value,rhs.value)
        self.remaining_sources = remaining_sources
    def __str__(self):
        return '('+str(self.lhs)+self.operator.display_string+str(self.rhs)+')'
    def __repr__(self):
        return self.__str__()

def ValidExpressions(sources,operators=standard_operators,minimal_remaining_sources=0):
    for value, i in zip(sources,range(1)):
        yield TerminalExpression(value=value, remaining_sources=sources[:i]+sources[i+1:])
    if len(sources)>=2+minimal_remaining_sources:
        for lhs in ValidExpressions(sources,operators,minimal_remaining_sources+1):
            for rhs in ValidExpressions(lhs.remaining_sources, operators, minimal_remaining_sources):
                for f in operators:
                    try: 
                        yield BranchedExpression(operator=f, lhs=lhs, rhs=rhs, remaining_sources=rhs.remaining_sources)
                    except InvalidExpressionError: pass

def TargetExpressions(target,sources,operators=standard_operators):
    for expression in ValidExpressions(sources,operators):
        #if abs((expression.value - target) / float(target)) < 0.00000001:
        if expression.value == target:

            l = 0
            r = 0
            while r < len(str(expression)):
                if str(expression)[r:].startswith(str(sources[l])):
                    r += len(str(sources[l])) - 1
                    l += 1
                    if l == len(sources):
                        break
                r += 1
            if l == len(sources):
                print "RET"
                print str(expression)
                return expression

#TargetExpressions(627, [11, 56, 1])
#exit()

s = socket.socket()
s.connect(("ppc-01.v7frkwrfyhsjtbpfcppnu.ctfz.one", 2445))
while True:
    firstsol = ""
    a = s.recv(1024).strip()
    print a
    a = a.split("\n")[-1]
    dicc = []
    for i in a.split(" "):
        if "." in i:
            dicc.append(float(i))
        else:
            dicc.append(int(i))
    orig = a.split(" ")[:-1]
    target = dicc[-1]
    numbers = dicc[:-1]
    #print target
    #print numbers
    print target
    print numbers
    sice = ""
    sice = TargetExpressions(target, numbers)
    if sice == "":
        sice = TargetExpressions(target, numbers[::-1])
    #print sice
    l = 0
    r = 0
    sol = ""
    while r < len(str(sice)):
        nextval = ""
        temp = ""
        for i in str(sice)[r:]:
            if i in (string.digits + "."):
                temp += i
            else:
                break
        if l < len(numbers) and temp != "" and float(temp) == float(orig[l]):
            r += len(temp)
            sol += str(orig[l])
            l += 1
        else:
            if str(sice)[r] not in (string.digits + "."):
                sol += str(sice)[r]
            r += 1
    sol = sol[1:-1]
    print sol
    if sice == "":
        sice = raw_input()
    s.send(str(sol) + "\n")
    time.sleep(1)

