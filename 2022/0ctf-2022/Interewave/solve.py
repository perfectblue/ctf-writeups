from pwn import *
import base64
import os
from sha256 import sha256

with open('tinyelf_header', 'rb') as f:
    ELF_HEADER = f.read()

r = process('./interweave')

# r = remote('101.132.105.41.nip.io', 22022)

# r.send(b"CONNECT 71c44314d2a94b12941ea4d0f0094436 HTTP/1.1\r\n\r\n")
# for _ in range(3):
#     r.recvline()

randoms = []

for idx in range(16):
    data = r.readline()
    data = base64.b64decode(data)
    assert len(data) == 0xC00
    randoms.append(data)

states = b""

for idx in range(16):
    data = ELF_HEADER
    data += b'\xe9\x3b\x0c\x00\x00' # jmp
    data += randoms[idx]
    data += b'\x90' * (64 - 5)
    h = sha256(data)
    assert len(h._buffer) == 0
    state = b''
    for i in range(8):
        state += h._h[i].to_bytes(4, 'little')
    print(state.hex())
    states += state

with open('states.bin', 'wb') as f:
    f.write(states)


for idx in range(16):
    with open('data.bin', 'wb') as f:
        f.write(randoms[idx] + b'\x90' * (64 - 5))
    os.system("nasm -Wall -felf64 main.asm")
    os.system("ld --omagic --strip-all main.o -o main.elf")
    os.system("objcopy -O binary -j .text main.elf main.bin")
    os.system("cat tinyelf_header main.bin > main.elf")

    os.remove('./main.o')
    os.remove('./main.bin')
    os.remove('./data.bin')

    with open('main.elf', 'rb') as f:
        data = f.read()
    data = base64.b64encode(data)
    print(idx, len(data), data[-10:])
    r.sendline(data)

r.interactive()