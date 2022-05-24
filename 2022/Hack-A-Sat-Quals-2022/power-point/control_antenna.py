from braindead import *
from braindead.util import xor
import numpy as np
import random
import time
log.enable()
args = Args()
args.parse()

r = io.connect(('power_point.satellitesabove.me', 5100))
r.sla('Ticket please', 'ticket{foxtrot582956papa3:GDEMCSCtCnLdL8Q6itFKoSOVKQkepfca9xcpAK-m_wUb7Wx-CgVi216Bnr92UTfC8A}')
cmd_server = list(r.rla('Antenna pointing TCP server accepts commands at ').decode().strip().split(':'))
cmd_server[1] = int(cmd_server[1])
iq_server = list(r.rla('Sample TCP server will provide samples at ').decode().strip().split(':'))
iq_server[1] = int(iq_server[1])

time.sleep(1)
iq_r = io.connect(iq_server)
r.ru('Sample Server: Client connected')
time.sleep(1)
cmd_r = io.connect(cmd_server)

r.ru('Press Enter')

fout = open('sig.cf32', 'wb')
az, el = 10, 20
old_power = 500
old = az, el
d_az = 0
d_el = 0
for i in range(400):
#for az in np.linspace(8, 12, 5):
    #for el in np.linspace(18, 22, 5):
    az += random.uniform(-0.2, 0.2) + d_az*0.8
    el += random.uniform(-0.2, 0.2) + d_el*0.8
    cmd_r.sl(f'{az},{el}')

    buf = iq_r.recvn(1024 *8)
    fout.write(buf)
    sig = np.frombuffer(buf, dtype=np.complex64)
    power = np.mean(np.abs(sig))
    if power < old_power:
        az, el = old
    else:
        d_az = az - old[0]
        d_el = el - old[1]
        old = az, el
    old_power = power
    print(az, el, np.mean(np.abs(sig)))

    r.ru('Sending 1024')
    print(i*1024/10/8*2, 'bytes done', az, el)

fout.close()

io.interactive(r)
