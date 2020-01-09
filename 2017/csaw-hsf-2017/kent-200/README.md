there seems to be some destroyed control flow with the switch instructions. this is not a big deal since we can just 
keep track of the switch values and the contro flow paths.

we also notice that in the functon doPlay that a counter is incremented whenever we win.
when this counte reaches 1000 the flag is displayed. so we must win 1000 times in a row.

inspecting the main input loop, we can notice a 'clan selection' menu if 0 is entered.
if we choose kent yu the gambler (0) then we play (6), we seem to always win.
so we simply dump this down the tcp stream with python and stop when we see the flag.

<dank.py>
```python
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

```


it takes a while, but `flag{Y0U_just_B3AT_R0ya1_K3nt_FAM1Ly_1n_Gambl1ng}`