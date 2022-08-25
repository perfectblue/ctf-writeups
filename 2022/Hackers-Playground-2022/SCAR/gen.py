import string
import itertools

values = []

with open('libpd.so', 'rb') as f:
    for c in string.ascii_uppercase + '_':
        # f.seek(0x11800 + 1024 * ord(c))
        f.seek(0x1800 + 1024 * ord(c)) # We found the right offset by debugging
        v1 = int.from_bytes(f.read(4), 'little')
        v2 = int.from_bytes(f.read(4), 'little')
        print(c, hex((v1 ^ v2) & 0xFF))

        values.append((c, (v1 ^ v2) & 0xFF))

for c, val in values:
    found = False
    dic = dict()
    for x in itertools.product(range(1, 256), repeat=2):
        v = 5381
        for j in range(2):
            tmp = (x[j] * val) % 256
            if tmp == 0:
                v = -1
                break
            v = (33 * v + tmp) % 0x186A3

        if v != -1:
            v = v * 33 ** 3 % 0x186A3
            dic[v] = x
    
    for x in itertools.product(range(1, 256), repeat=3):
        v = 0
        for j in range(3):
            tmp = (x[j] * val) % 256
            if tmp == 0:
                v = -1
                break
            v = (33 * v + tmp) % 0x186A3

        if v != -1:
            co = (0x186A3 - v) % 0x186A3
            if co in dic:
                x = dic[co] + x

                v = 5381
                for i in range(5):
                    tmp = (x[i] * val) % 256
                    print(hex(tmp))
                    v = (33 * v + tmp) % 0x186A3
                # print(v)
                print(f"{{{x[0]}, {x[1]}, {x[2]}, {x[3]}, {x[4]}}},")
                found = True
                # break
                exit(0)
    
    if not found:
        # print("FFFFFF")
        print(c, "{-1, -1, -1, -1, -1},")