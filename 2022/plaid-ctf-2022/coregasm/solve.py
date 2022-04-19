from pwn import *
import itertools

elf = ELF('./coregasm')
core = ELF('./core')

def read_otp():
    for x in core.search(p16(0xfbad)):
        if x & 0xff0000000000 == 0x550000000000:
            addr = u64(core.read(x - 2 + 0x18, 8))
            return core.read(addr, 128)
    else:
        raise ValueError()

def xorwith64(buf, lst):
    xorstr = b''.join(p64(x) for x in lst)
    for i, x in enumerate(xorstr):
        buf[i] ^= x


elf.address = core.address

# Flag 1
buf = list(core.read(elf.symbols.globalbuf, 64))
for i in range(len(buf)):
    buf[i] ^= 0xa5

flag1 = str(bytes(buf), 'utf8')
print(f'Flag 1: {flag1}')

xorwith64(buf, [0x80083ED7E794313B, 0x75136EBBBF60734F, 0x6C46A704AF4D8380,
        0xC1991AB8C1674BBF, 0xDC0B819132401105, 0xAF4464465D7D4DC0,
        0x9EAD54BD51956632, 0xC4D2C981312F974])

# Flag 2
otp = read_otp()
for i, x in enumerate(otp[0x40:]):
    buf[i] ^= x
flag2 = str(bytes(buf), 'utf8')
print(f'Flag 2: {flag2}')

xorwith64(buf, [0x6301641F2866C34B, 0x1EB4DEF5AC740DCF, 0x4F490B1C93DF4671,
    0x9F82C6EC691CA0B0, 0xC2D142FCAF5DCA6B, 0xFA68305EB42FCB00,
    0x62212646A9E04B61, 0xBB73AD9A9992C6B])

for i, x in enumerate(otp[:0x40]):
    buf[i] ^= x

# Flag 3
after = struct.unpack('<' + 'I' * 16, bytes(buf))
ending = b'nbnanbnanbnabanananananba}'
ending = b'\x00' * (60 - len(ending)) + ending + b'\x00\x00\x00\x00'
before = list(struct.unpack('<' + 'I' * 16, ending))

def brute(tmp3):
    for poss in itertools.product(b'bna', repeat=8):
        a = bytes(poss[:4])
        b = bytes(poss[4:])
        if (u32(a) * u32(b)) & 0xffffffff == tmp3:
            yield (a, b)

#assert after[15] == 0x12345678
#tmp1 = after[11]
#tmp2 = after[5]
#tmp3 = after[8]
#tmp4 = after[14]
#tmp5 = after[10] ^ tmp1
#assert tmp5 == after[2]
#assert (tmp3 | tmp2) == after[1]
#assert (tmp4 * tmp1) == after[4]
#assert (tmp3 % tmp1) == after[3]
#assert (tmp4 // tmp5) == after[6]
#assert (tmp2 + tmp4) == after[7]
## tmp4 = before[12] ^ before[13]
#assert tmp4 == before[12] ^ before[13]
## tmp1 = before[10] / before[9]
#assert tmp1 == before[10] // before[9]
## tmp3 = before[6] * before[7]
#a, b = next(brute(tmp3))
#before[6] = u32(a)
#before[7] = u32(b)
## tmp5 = before[0] + before[1]
#before[0] = u32(b'PCTF')
#before[1] = (tmp5 - before[0]) & 0xffffffff
#before[2] = u32(b'anan')
#before[3] = u32(b'nanb')
## tmp2 = before[4] - before[3]
#before[4] = (tmp2 + before[3]) & 0xffffffff
#
#before[5] = u32(b'----')
#before[8] |= u32(b'--\x00\x00')
#
#buff = list(b''.join(p32(x) for x in before))

buff = [249, 94, 36, 142, 140, 180, 96, 65] * 8

xorwith64(buff, [0x2F01D6F7C8701DA9, 0x230ED5E2EC453098, 0x2F01DAE2EF4A3F97,
    0x2301DAE2EC45309B, 0x230ED5E2EC4A3F97, 0x2002D5E2EC4A3F97,
    0x200ED5E2EF4A3F97, 0x6140948CF3453C97])
flag3 = str(bytes(buff), 'utf8')
print(f'Flag 3: {flag3}')

final = [249, 94, 36, 142, 140, 180, 96, 65]
x = struct.unpack('<d', bytes(final))

print(x)
