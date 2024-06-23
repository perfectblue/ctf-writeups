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

    def solve_derive(solve_for, m):

        R.<x> = PolynomialRing(GF(2))   
        irreducible_poly = x^16 + x^5 + x^3 + x + 1
        F = GF(2^16, modulus=irreducible_poly, name='a')

        F_solve_for = [F.from_integer(x) for x in solve_for]

        G.<a0, a1, a2, a3, a4, a5> = F[]
        if m == 0:
            my_id = Ideal(
                a0 * a1 + a4 - F_solve_for[0],
                a1 * a2 + a5 - F_solve_for[1],
                a2 * a3 + a0 - F_solve_for[2],
                a3 * a4 + a1 - F_solve_for[3],
                a4 * a5 + a2 - F_solve_for[4],
                a5 * a0 + a3 - F_solve_for[5],
            )
        elif m == 1:
            my_id = Ideal(
                a2 * a3 + a5 - F_solve_for[0],
                a3 * a4 + a0 - F_solve_for[1],
                a4 * a5 + a1 - F_solve_for[2],
                a5 * a0 + a2 - F_solve_for[3],
                a0 * a1 + a3 - F_solve_for[4],
                a1 * a2 + a4 - F_solve_for[5],
            )
        assert my_id.dimension() == 0
        my_variety = my_id.variety()
        fuckshit = [[
            variety[a0].integer_representation(),
            variety[a1].integer_representation(),
            variety[a2].integer_representation(),
            variety[a3].integer_representation(),
            variety[a4].integer_representation(),
            variety[a5].integer_representation()
        ] for variety in my_variety]
        return fuckshit

    possible_solution = solve_derive([u16(rv1[i * 2 : i * 2 + 2], m=1) for i in range(6)])
    possible_solution = [b"".join(p16(x) for x in possible_solution)]
    possible_rv0s = [derive(x, m=0) for x in possible_solution]

    b2, cb1, bs, cb2, rv1 = data[:12],data[12:24],data[24:36],data[36:48],data[48:60]
    b1 = xor(hashlib.sha1(rv1 + b2).digest()[:12], cb2)
    b0 = xor(hashlib.md5(rv0 + b2).digest()[:12], cb1)
    i = [int.from_bytes(x, "little") for x in [b0,b1,b2]]
    i3 = ((((bs - pow(i[2], i[1], P) % P) * pow(i[0],-1,P)) % P) - i[1]) % P
    b3 = i3.to_bytes(12,'little')
    b = b0 + b1 + b2 + b3
    print(b.hex())