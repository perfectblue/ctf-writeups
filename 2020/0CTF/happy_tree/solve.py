def unlsh(val, amt):
    res = 0
    for i in range(0, 32, amt):
        known = val % 2**amt
        res |= (known << i)
        val >>= amt
        val ^= known
    return res & 0xffffffff

def unrsh(val, amt):
    res = 0
    for i in range(0, 32, amt):
        known = val & (-2**32 >> amt)
        res |= (known >> i)
        val = (val << amt) & 0xffffffff
        val ^= known
    return res & 0xffffffff

def unwind(val, xor):
    for i in range(100000):
        val = unlsh(val, 5)
        val = unrsh(val, 0x11)
        val = unlsh(val, 0xd)
    val ^= xor
    return val

nums = [0xa25dc66a, 0xaa0036, 0xc64e001a, 0x369d0854, 0xf15bcf8f, 0x6bbe1965,
        0x1966cd91, 0xd4c5fbfd, 0xb04a9b1b]
import struct

flag = b''
for i, n in enumerate(nums):
    if i & 1 == 1:
        n = unwind(n, 0xaaaaaaaa)
    else:
        n = unwind(n, 0)
    part = struct.pack('<I', n)
    print(part)
    flag += part 
print(flag)
