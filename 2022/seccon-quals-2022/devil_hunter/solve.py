values = [
    0x739e80a2,
    0x3aae80a3,
    0x3ba4e79f,
    0x78bac1f3,
    0x5ef9c1f3,
    0x3bb9ec9f,
    0x558683f4,
    0x55fad594,
    0x6cbfdd9f
]

buf = []
for v in values:
    v ^= 0xacab3c0
    b = v.to_bytes(4, 'little')
    buf += [b[0], b[3], b[2], b[1]]

print(bytes(buf))