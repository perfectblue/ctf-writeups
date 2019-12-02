import socket
import random
import copy
import time
from sage.all import *
from telnetlib import Telnet

def sub(str1, str2, N):
    res = ""
    for i in range(len(str1)):
        val = ord(str2[i]) - ord(str1[i])
        if val < 0:
            val += N
        res += chr(val)
    return res

proc = socket.socket()
proc.connect(('ppc-fridge.ctfz.one', 31337))

SOLVED = False

def grid_to_str(shitter=None):
    if shitter is not None:
        data = shitter.strip().split("\n")
    else:
        data = proc.recv(4096).strip().split("\n")
    # print data
    # print data

    N = len(data)
    chal = []
    for i in data:
        cur = i.split()
        temp = []
        for j in cur:
            temp.append(int(j, 16))
        chal.append(temp)
    grid = chal
    ans = ''
    for i in range(N):
        for j in range(N):
            ans += chr(grid[i][j])
    return (ans, N)

def interacc():
    print "INTERACTIVE"
    t = Telnet()
    t.sock = proc
    t.interact()

proc.recv(1024)
proc.send("1,1\n")


level = 0
last = ""
while True:
    if "solved!" in last:
        last = last.split("solved!\n")[1]
        start, N = grid_to_str(last)
    else:
        start, N = grid_to_str()

    if level <= 2:
        gf = 2
    elif level == 3:
        gf = 8
    elif level == 4:
        gf = 16

    print "GF ", gf

    mapping = [0 for i in range(N*N)]

    for i in range(N):
        for j in range(N):
            proc.send("{},{}\n".format(i, j))
            curr = grid_to_str()[0]
            mapping[N*i + j] = sub(start, curr, gf)
            start = curr
            # proc.interactive()
            # proc.interactive()
    start = list(start)
    for i in range(len(start)):
        start[i] = ord(start[i])
    A = []
    for i in mapping:
        temp = []
        for j in i:
            temp.append(ord(j))
        A.append(temp)
    B = start
    for i in range(len(B)):
        B[i] = gf - B[i]

    print "PROBLEM"

    R = IntegerModRing(gf)

    A = matrix(R, A)
    B = vector(R, B)
    A = A.transpose()
    print A
    print B
    solution = A.solve_right(B)
    print solution
    print "SOLVING"

    last = ""

    for i in range(len(solution)):
        if solution[i] != 0:
            for _ in range(solution[i]):
                col, row = i % N, i / N
                print row, col
                proc.send("{},{}\n".format(row, col))
                last = proc.recv(2048)
                if level == 4:
                    print last
    if level == 4:
        interacc()
    level += 1

proc.interactive()
