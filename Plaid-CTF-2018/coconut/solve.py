from pwn import *
import hashlib
r = remote("coconut.chal.pwning.xxx", 6817)
threshold = 0
while True:
	try:
		print r.recvuntil("threshold required <=")
		threshold = int(r.recvline().strip())
		print r.recvuntil("Function to optimize:")
	except:
		r.interactive()
	r.recvline()
	code = r.recvuntil("<<<EOF>>>").strip().strip("<<<EOF>>>").strip()

	r.recvuntil("only be >=")
	le = int(r.recvuntil("and").strip("and").strip())
	ri = int(r.recvuntil(":").strip().strip(":").strip("<="))
	print le
	print ri
	print threshold
	data = code
	keeptrack = {}
	important = []
	start = True
	splitted = data.split("\n")
	temp = splitted[::-1][2:]
	c = 0
	keeptrack["%eax"] = 0
	for i in temp:
		c += 1
		command = i.split()[1:]
		
		if len(command) >= 3 and command[2].strip(",") in keeptrack:
			keeptrack[command[2].strip(",")] += 1
			if command[0] == "movl" or command[0] == "leal":
				#print command
				while command[2].strip(",") in keeptrack:
					#keeptrack.remove(command[2].strip(","))
					del keeptrack[command[2].strip(",")]
			if command[1][0] != "$":
				if command[1][0] == "(":
					fucc = command[1].strip().strip(",").strip("(").strip(")").split(",")
					if len(fucc) > 2:
						print command
						print "oh..."
						exit()
					keeptrack[fucc[0].strip(")").strip("(").replace("r", "e")] = 0
					keeptrack[fucc[1].strip(")").strip("(").replace("r", "e")] = 0
					#keeptrack[command[1].strip(",")] = 0
					#pass
				else:
					keeptrack[command[1].strip(",")] = 0
			#keeptrack.append(command[1].strip(","))
			#print command
			important.append(int(i.split()[0]))
		
		'''if start:
			start = False
			#print command
			keeptrack[command[1].strip(",")] = 0
			#keeptrack.append(command[1].strip(","))
			important.append(int(i.split()[0]))'''
	print keeptrack
	print "finished analyzing"
	c = 0
	remleft = -1
	for i in range(1, int(splitted[-1].split()[0]) + 1):
		if i >= le and i <= ri and i not in important:
			#r.sendline(str(i))
			if remleft == -1:
				remleft = i
		else:
			if remleft != -1:
				r.sendline(str(remleft) + "-" + str(i - 1))
				c += i - remleft
			remleft = -1
	print len(splitted) - c
	print threshold
	r.sendline("#")
r.interactive()
