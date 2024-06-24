import os
import hashlib
import struct

P = 79160129948973046149879599747


def p16(x):
    return struct.pack("<H", x)


def u16(x):
    return struct.unpack("<H", x)[0]


def xor(a: bytes, b: bytes) -> bytes:
    assert len(a) == len(b)
    return bytes([x ^^ y for x, y in zip(a, b)])


def random_bytes(n: int) -> bytes:
    return os.urandom(n)


def derive(seed: bytes, *, m: int) -> bytes:
    assert len(seed) == 12
    arr = [u16(seed[i * 2 : i * 2 + 2]) for i in range(6)]
    out = []
    for i in range(6):
        key = 0
        c0, c1 = arr[(i + 2 * m) % 6], arr[(i + 2 * m + 1) % 6]
        while c0 and c1:
            key ^^= c0 & -(c1 & 1)
            v17 = (c0 << 1) ^^ 0x2B
            if (c0 & 0x8000) == 0:
                v17 = c0 << 1
            c0 = v17 & 0xFFFF
            c1 >>= 1
        out.append(arr[(i + 4 + m) % 6] ^^ key)
    return b"".join(p16(x) for x in out)


def process_block(block: bytes, *, rounds=12) -> bytes:
    assert len(block) == 48
    rv0, rv1 = random_bytes(12), b"\x00"
    b = [block[i * 12 : (i + 1) * 12] for i in range(4)]
    for _ in range(rounds):
        i = [int.from_bytes(x, "little") for x in b]
        rv0, rv1 = derive(rv0, m=0), derive(rv0, m=1)
        cb1 = xor(hashlib.md5(rv0 + b[2]).digest()[:12], b[0])
        bs = ((i[1] + i[3]) * i[0] + pow(i[2], i[1], P)) % P
        cb2 = xor(hashlib.sha1(rv1 + b[2]).digest()[:12], b[1])
        b = b[2], cb1, bs.to_bytes(12, "little"), cb2


        
    return b"".join(list(b) + [rv1])


if __name__ == "__main__":
    random_bytes = lambda n: bytes(
        [0x9B, 0x07, 0x81, 0x5F, 0x04, 0x49, 0x7E, 0x2E, 0x05, 0xD2, 0x2C, 0xAC]
    )
    with open("random.bin", "rb") as fp:
        data = fp.read()
    assert len(data) == 47
    data += b"\x01"
    with open("random.bin.reimpl", "wb") as fp:
        fp.write(process_block(data, rounds=12))
