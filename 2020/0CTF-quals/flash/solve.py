from Crypto.Util.number import inverse
import struct

stuff = [0x72a9, 0x97e, 0x5560, 0x4ca1, 0x37, 0xaa71, 0x122c, 0x4536, 0x11e8,
        0x1247, 0x76c7, 0x96d, 0x122c, 0x87cb, 0x9e4]
stuff = stuff[::-1]

stuff2 = [struct.pack('>H', (inverse(0x11, 0xb248) * x) % 0xb248) for x in stuff]
stuff2 = b''.join(stuff2)
print(stuff2)

print("flag{it's_time_to_pwn_this_machine!}")
