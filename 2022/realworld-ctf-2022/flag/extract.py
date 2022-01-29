import os
from pwn import *

PROG_BASE = 0x60010000
INDEX_FILE_OFFSET = 0x609A0020

FS = "./fs"


with open("./flag.bin", "rb") as f:
    content = f.read()


def read_int_at(addr):
    start = addr - PROG_BASE
    return u32(content[start : start + 4])


def read_file_at(addr, size):
    start = addr - PROG_BASE
    return content[start : start + size]


def read_string_at(addr):
    start = addr - PROG_BASE
    end = start
    while content[end] != 0:
        end += 1
    return content[start:end].decode()


now = INDEX_FILE_OFFSET

while True:
    path_addr = read_int_at(now)
    if path_addr == 0:
        break

    path = read_string_at(path_addr)
    page_addr = read_int_at(now + 4)
    size = read_int_at(now + 8)

    if page_addr != 0:
        page = read_file_at(page_addr, size)

        real_path = os.path.join(FS, path[1:])
        os.makedirs(os.path.dirname(real_path), exist_ok=True)
        with open(real_path, "wb") as f:
            f.write(page)

    now += 24
