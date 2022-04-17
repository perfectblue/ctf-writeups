from pwn import *
import string
import itertools
import hashlib
import time

tries = 0

def main():
    global tries
    tries += 1
    print(f"Try #{tries}")

    r = remote('choreography.chal.pwni.ng', 1337)
    l = r.recvline().split(b' ')
    prefix = l[6]

    for x in itertools.product(string.ascii_letters + string.digits, repeat=8):
        t = ''.join(x).encode()
        if hashlib.sha256(prefix + t).hexdigest()[-6:] == "ffffff":
            print("FOUND")
            r.sendline(prefix + t)
            break

    # For encrypt1
    print("Processing encrypt1...")
    inp = b''
    for i in range(256):
        inp += bytes([0, 0, 0, i])
    r.recvuntil(b': ')
    r.sendline(inp.hex().encode())

    inp = b''
    for i in range(500 - 256):
        inp += bytes([1, 0, 0, i])
    r.recvuntil(b': ')
    r.sendline(inp.hex().encode())

    # For encrypt2
    print("Processing encrypt2...")
    inp = b''
    for i in range(256):
        inp += bytes([0, 0, 2, i])
    r.recvuntil(b': ')
    r.sendline(inp.hex().encode())

    inp = b''
    for i in range(500 - 256):
        inp += bytes([0, 0, 3, i])
    r.recvuntil(b': ')
    r.sendline(inp.hex().encode())

    # Receive (it will take some time)
    print("Receive...")
    r.recvuntil(b'result:')
    st = time.time()
    l = r.recvline()
    res = bytes.fromhex(l.decode().strip())

    pos = []
    for i in range(500):
        t = res[4 * i:4 * i + 4]
        if t[0] == t[2] ^ (i // 256) and t[1] == t[3] ^ (i % 256):
            pos.append((i % 256, i // 256)) # k0^k1, k2^k3
        
        t = res[2000 + 4 * i:2000 + 4 * i + 4]
        if t[0] == t[2] ^ (i // 256 + 2) and t[1] == t[3] ^ (i % 256):
            pos.append((i % 256, i // 256 + 2)) # k0^k1, k2^k3

    ed = time.time()
    th = int(30.0 - ed + st)

    if len(pos) == 0:
        print("Not found")
        r.close()
        return False

    print(f"Processing in {th} seconds")
    for x, y in pos:
        processes = []
        for i in range(0, 256, 8):
            p = process('./solve')
            p.sendline(f"{x} {y} {i}".encode())
            p.sendline(f"{res[0]} {res[1]} {res[2]} {res[3]}".encode())
            processes.append(p)
        
        for i in range(32):
            try:
                key = processes[i].recv(timeout=th)
                if len(key) > 8:
                    r.send(key)
                    r.interactive()
                    return True
            except:
                pass
            
            processes[i].close()
    
    r.close()
    return False

while not main():
    pass
        
