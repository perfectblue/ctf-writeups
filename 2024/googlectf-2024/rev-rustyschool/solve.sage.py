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




def solve_(solve_for, m):

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
        variety[a0].to_integer(),
        variety[a1].to_integer(),
        variety[a2].to_integer(),
        variety[a3].to_integer(),
        variety[a4].to_integer(),
        variety[a5].to_integer()
    ] for variety in my_variety]
    return fuckshit

def solve2_(rv0, rv1):

    R.<x> = PolynomialRing(GF(2))   
    irreducible_poly = x^16 + x^5 + x^3 + x + 1
    F = GF(2^16, modulus=irreducible_poly, name='a')

    rv0 = [F.from_integer(x) for x in rv0]
    rv1 = [F.from_integer(x) for x in rv1]

    G.<a0, a1, a2, a3, a4, a5> = F[]
    my_id = Ideal(
        a0 * a1 + a4 - rv0[0],
        a1 * a2 + a5 - rv0[1],
        a2 * a3 + a0 - rv0[2],
        a3 * a4 + a1 - rv0[3],
        a4 * a5 + a2 - rv0[4],
        a5 * a0 + a3 - rv0[5],
        a2 * a3 + a5 - rv1[0],
        a3 * a4 + a0 - rv1[1],
        a4 * a5 + a1 - rv1[2],
        a5 * a0 + a2 - rv1[3],
        a0 * a1 + a3 - rv1[4],
        a1 * a2 + a4 - rv1[5],
    )
    assert my_id.dimension() == 0
    my_variety = my_id.variety()
    fuckshit = [[
        variety[a0].to_integer(),
        variety[a1].to_integer(),
        variety[a2].to_integer(),
        variety[a3].to_integer(),
        variety[a4].to_integer(),
        variety[a5].to_integer()
    ] for variety in my_variety]
    return fuckshit

def solve(rv, m):
    possible_solution = solve_([u16(rv[i * 2 : i * 2 + 2]) for i in range(6)], m)
    possible_solution = [b"".join(p16(x) for x in y) for y in possible_solution]
    return possible_solution

def solve2(rv0,rv1):
    possible_solution = solve2_([u16(rv0[i * 2 : i * 2 + 2]) for i in range(6)], [u16(rv1[i * 2 : i * 2 + 2]) for i in range(6)])
    possible_solution = [b"".join(p16(x) for x in y) for y in possible_solution]
    return possible_solution

def to_int(x):
    return int.from_bytes(x, "little")

N_ROUNDS=12

def do_one_round(output,rv0,rv1,n):
    shits = []
    b2, cb1, bs, cb2 = output[:12],output[12:24],output[24:36],output[36:48]
    b1 = xor(cb2, hashlib.sha1(rv1 + b2).digest()[:12])
    b0 = xor(cb1, hashlib.md5(rv0 + b2).digest()[:12])
    b3 = (((((to_int(bs) - pow(to_int(b2), to_int(b1), P) + P) % P) * pow(to_int(b0), -1, P)) % P - to_int(b1) + P) % P).to_bytes(12, "little")
    for OLD_rv0 in solve2(rv0, rv1):
        if n == N_ROUNDS-1:
            return [(b"".join([b0,b1,b2,b3]), OLD_rv0, b'',n+1)]
        for OLDEST_rv0 in solve(OLD_rv0, m=0):
            OLD_rv1 = derive(OLDEST_rv0, m=1)
            shits.append((b"".join([b0,b1,b2,b3]), OLD_rv0, OLD_rv1))
    return shits


def do_chunk(output):
    assert len(output) == 60

    POSSIBLE_OUTPUTS = []
    rv1 = output[48:60]
    for pot_old_rv0 in solve(rv1, m=1):
        POSSIBLE_OUTPUTS.append((output[:48], derive(pot_old_rv0,m=0), rv1))

    for n in range(N_ROUNDS):
        # print(f'\n====== ROUND {n} =====\n')
        POSSIBLE_OLD_INPUTS = []
        for output,rv0,rv1 in POSSIBLE_OUTPUTS:
            POSSIBLE_OLD_INPUTS.extend(do_one_round(output,rv0,rv1,n))

        POSSIBLE_OLD_INPUTS = list(set(POSSIBLE_OLD_INPUTS))
        # for x in POSSIBLE_OLD_INPUTS:
        #     print(x[0].hex(), x[1].hex(), x[2].hex())
        POSSIBLE_OUTPUTS = POSSIBLE_OLD_INPUTS

    for orig_input, _, _, _ in POSSIBLE_OLD_INPUTS:
        if all((c >= 0x20 and c < 0x7f) or c in [0xa, 0xd] for c in orig_input):
            return orig_input
    return b'[CHUNK FAILED TO DECRYPT]'


if __name__ == '__main__':
    import multiprocessing as mp
    mp.set_start_method('spawn')
    from tqdm import tqdm

    import sys
    with open(sys.argv[1], "rb") as fp:
        output = fp.read()

    chunks = []
    for i in range(0,len(output),60):
        chunks.append(output[i:i+60])

    with mp.Pool(32) as p:
        plains = tqdm(p.imap(do_chunk, chunks),total=len(chunks))
        result = b''.join(plains)
        print(result)
        with open(sys.argv[1] + '.dec', "wb") as fp:
            fp.write(result)
