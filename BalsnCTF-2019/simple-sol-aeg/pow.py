from pwn import *
import hashlib
import sys

difficulty = ''
zeros = ''

def is_valid(digest):
    if sys.version_info.major == 2:
        digest = [ord(i) for i in digest]
    bits = ''.join(bin(i)[2:].zfill(8) for i in digest)
    return bits[:difficulty] == zeros


def pow(r):
    global difficulty
    global zeros
    r.recvuntil('(')
    prefix = r.recvuntil(' + ')[:-3]
    r.recvuntil('(')
    difficulty = int(r.recvuntil(')')[:-1])
    print("Solving POW")
    # print "Prefix -> {}\nDifficuly -> {}".format(prefix, difficulty)
    zeros = '0' * difficulty
    i = 0
    while True:
        i += 1
        s = prefix + str(i).encode()
        if is_valid(hashlib.sha256(s).digest()):
            r.sendlineafter(' = ', str(i))
            return



