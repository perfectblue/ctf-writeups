import struct

orig = bytes.fromhex('AB 2D 00 90 6B 81 27 91 63 79 69 F8')
target = bytes.fromhex('03 6C 84 D2 23 46 A0 F2 E3 FF FF F2')

if len(orig) != len(target):
    exit()

pad = b'\x00' * (-len(orig) % 4)
orig += pad
target += pad

def emit(offset, mask, type):
    print(f"""
    led_{mask}_{offset}_{type} {{
        compatible = "register-bit-led";
        offset = <{offset}>;
        mask = <{mask}>;
        default-state = "{type}";
        label = "hey";
    }};
""")

for i in range(len(orig)>>2):
    offset = i * 4
    a = struct.unpack_from("<L", orig, offset)[0]
    b = struct.unpack_from("<L", target, offset)[0]

    emit(offset, 0xffffffff, 'off')
    emit(offset, b, 'on')