#!/usr/bin/env python

from pwn import *
import time
import random

hostname = 'misc.hsf.csaw.io'
port = 9012

def own():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((hostname, port))
    print s.recv(4096) # clear shit at start
    s.sendall('0\n')
    print s.recv(4096)
    s.sendall('0\n')
    print s.recv(4096)
    for x in range(0,2000):
        s.sendall('6\n')
        data = s.recv(4096)
        if 'TAKE YOUR PRIZE' in data:
            print data
            break
        if x % 250 == 0:
            print data
            print x
    while True:
        s.sendall(raw_input() + '\n')
        print s.recv(4096)

    s.shutdown(socket.SHUT_WR)
    s.close()


try:
    own()
except KeyboardInterrupt:
    pass
