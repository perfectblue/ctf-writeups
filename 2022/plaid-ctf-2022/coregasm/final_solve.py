from decimal import *
vals = [Decimal("8758372.44193981720582"), Decimal("4457828.61824004405162"),
        Decimal("1139716.96293101242827"), Decimal("193984.053677134516846"),
        Decimal("24751.5189151917131252"), Decimal("2526.22752352315034186"),
        Decimal("214.831820219884093451"), Decimal("15.6579354707501636756")]
print(vals)
v2 = vals[0] / vals[1]
v3 = vals[1] / vals[2]
v4 = vals[2] / vals[3]
v5 = vals[3] / vals[4]
v6 = vals[4] / vals[5]
v7 = vals[5] / vals[6]
v8 = vals[6] / vals[7]

values = []
values.append(v2)
values.append(v3 - v2)
values.append(v4 - v3)
values.append(v5 - v4)
values.append(v6 - v5)
values.append(v7 - v6)
values.append(v8 - v7)
temp = vals[7]
for i in values:
    temp -= i
values.append(temp)
print(values)

import struct
def get_bytes(a):
    return struct.unpack("L", struct.pack("d", a))[0] - 0x3FFF000000000000

import binascii
flag = b""
for i in values:
    flag += (binascii.unhexlify(hex(get_bytes(i))[2:]))[::-1]
print(flag)
