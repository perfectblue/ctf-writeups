import os
from pwn import *
import threading

#filename = "CTF/smokeme/smokeme420_dist/96667aaad70646abc06a8b44b1016e94e3897dd5a95dff21b6e7a9628a823d06"
def siceme(filename, dic):
	print filename
	os.system("""objdump -d {} | grep 'mov    0x10(%rsp),%rsi' -B 4 | grep 'mov.*,%eax'> temp""".format(filename))

	shits = open("temp", "r").read().strip()

	start = shits.split("\n")[0].strip()

	os.system("""objdump -d {} > temp""".format(filename))
	dump = open("temp", "r").read().strip()

	rec = False

	exitfunc = ""
	for a in dump.split("\n"):
		if start.strip().split()[0] in a:
			rec = True
		if rec and "call" in a:
			exitfunc = a.strip().split()[-2]
			rec = False
			break
	os.system("""objdump -d {} | grep '{}' | grep "call"> temp""".format(filename, exitfunc))

	breakpoints = open("temp", "r").read().strip()
	#print breakpoints

	r = process("gdb", raw=False)
	r.recvuntil("(gdb) ")
	r.sendline("file " + filename)
	r.recvuntil("(gdb) ")
	r.sendline("set pagination off")
	r.recvuntil("(gdb) ")

	for i in breakpoints.split("\n"):
		cur = i.split(":")[0].strip()
		#print cur
		r.sendline("break *0x80" + cur.zfill(5))
		r.recvuntil("(gdb) ")
	flag = ""
	biggest = -1
	biggestchar = "a"
	shortcut = False
	lastbiggest = -2
	while True:
		legitfind = False
		fukked = False
		for i in ' abcdefghijklmnopqrstuvwxyz0123456789`"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ABCDEFGHIJKLMNOPQRSTUVWXYZ!':
			r.sendline("r")
			#r.interactive()
			r.recvuntil("enter code:")
			r.sendline(flag + i)
			recv = r.recvuntil("(gdb) ")
			#print recv
			if "sum" in recv:
				r.close()
				dic[filename] = flag + i
				print filename
				print flag + i
				return flag + i
			if "Breakpoint" not in recv:
				fukked = True
				biggestchar = i
				r.sendline("c")
				continue
			breaknum = int(recv.split("Breakpoint ")[1].split(",")[0])
			r.sendline("c")
			
			if shortcut and breaknum > biggest:
				legitfind = True
				biggest = breaknum
				biggestchar = i
				break
			if breaknum > biggest:
				legitfind = True
				biggest = breaknum
				biggestchar = i
				#if shortcut:
					#break
		if not legitfind and not fukked:
			flag = flag[:-1]
			shortcut = False
			continue
		if legitfind and not shortcut:
			shortcut = True
		lastbiggest = biggest
		flag += biggestchar
		print flag
	r.close()
	return "YOU DONE GOOFED"

#print siceme("./049f800f47043d30b30399df5e6da3788b90032d7e04a93fec70a7e8c5bfcc54")
'''
temp = open("../answers", "r").read().strip()
dic = {}
for i in temp.split("\n"):
	l = i.split(" : ")[0]
	r = i.split(" : ")[1]
	dic[l] = r

print dic

while True:

	p = remote("smokeme.420blaze.in", 42069)
	p.recvuntil("96667aaad70646abc06a8b44b1016e94e3897dd5a95dff21b6e7a9628a823d06")
	p.sendline("""on `nnt dl on ? Some!ne (!ea%d roi' me a""".encode("base64").strip())
	p.recvline()
	file = p.recvline().strip()
	if file in dic:
		print "DEETS"
		p.sendline(dic[file].encode("base64").strip())
	else:
		p.close()
		continue
		dank = siceme("./" + file.strip())
		print dank
		p.sendline(dank.encode("base64").strip())
	p.interactive()'''

temp = open("../passes.txt", "r").read().strip()
dic = {}
for i in temp.split("\n"):
	l = i.split(" : ")[0]
	r = i.split(" : ")[1]
	dic[l] = r

print dic
output = open("../passes.txt", "w")
output.write(temp + "\n")
output.flush()

fucks = os.listdir(".")[::-1]
for i in range(0, len(fucks), 1):
	'''
	threads = []
	for b in range(8):
		filename = fucks[i + b].strip()
		if not filename.endswith(".py") and not filename == "temp" and not filename in dic:
			the = threading.Thread(target=siceme, args=(filename, dic))
			the.start()
			threads.append(the)
	    	#try:
	    	#password = siceme("./" + filename)
	    	#except:
	    		#print "SOMETHING FUCKED UP ON " + str(filename)
	    		#password = "SOMETHING FUCKED"
	    	#output.write(str(filename) + " : " + str(password) + "\n")
	    	#print str(filename) + " : " + str(password) + "\n"
	    	#output.flush()
	for b in threads:
	    b.join()'''
	filename = fucks[i].strip()
	if not filename.endswith(".py") and not filename == "temp" and not filename in dic:
		password = siceme(filename, dic)
		print filename + " : " + password
		output.write(filename + " : " + password + "\n")
		output.flush()
print dic
output.write(str(dic))
output.close()
