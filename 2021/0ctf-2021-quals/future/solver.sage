import struct
import itertools

vals = 'cc5dab454c3e0146ccb6c2454c49ca4598daf945cc6d0b46ccc0de45e69206460c35ae456e610346aceac545ac9ecd453c02fe455ebe0d464c64e245c6cc08464ce9b045126a05468cf6c8458ccad04572fb004672f20f46ccd9e54526eb0a464c05b44526c107464c79cc458c71d44526410346c67a12464cd8e945265b0d46cc95b64556ae09464c5ccf45cc72d7451621054656911446cc1eed45665d0f46cca9b94546000c46ccd6d2454c11db4546610746c6131746cc14f145e6c61146cc80bc455e230e468c0ad6458c66de45fe7409463e6419464cb8f445a60014464c35bf45062c10468c16d9458c92e145666f0b4666981b46cc2df845261f1646cc3de63f6040a640dc400941244140415b41764188419641a441b141bf41cc41cc3e06407340b040e6400e412941444160417b418b419841a641b441c141cf41333f19408340b940f04013412e414941644180418d419b41a841b641c441d141803f2c408c40c340f940184133414e416941824190419d41ab41b841c641d441a63f40409640cc4001411c41384153416e4184419241a041ad41bb41c841d641cc3f5340a040d640064121413c415841734187419441a241b041bd41cb41d841f33f6640a940e0400b41264141415c41784189419741a441b241c041cd41db410c407940b340e94010412b41464161417c418c419941a741b441c241d041dd41'
vals = bytes.fromhex(vals)

A = [[0.0 for j in range(8)] for i in range(8)]
B = [[0.0 for j in range(8)] for i in range(8)]

for i in range(8):
    for j in range(8):
        B[i][j] = struct.unpack('<f', vals[32 * i + 4 * j:32 * i + 4 * j + 4])[0]
        A[i][j] = struct.unpack('<f', b'\x00\x00' + vals[32 * (8 + i) + 4 * j:32 * (8 + i) + 4 * j + 2])[0]

A = Matrix(RDF, A)
B = Matrix(RDF, B)
C = A.inverse() * B

print(C)

vecs = [ [0 for j in range(8) ] for i in range(8) ]
vecs[1][0] = 1
for i in range(5):
    for j in range(8):
        vecs[i + 2][j] = C[i][j].round()

print(vecs)

mat = [
    [0, 1, 0, 0, 1, 1, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
]

for i in range(8):
    for v in range(256):
        for j in range(8):
            mat[j][i] = (v >> j) & 1
        
        flag = True
        for j in range(5):
            s = vecs[j][i]
            for k in range(8):
                s += (vecs[j + 1][k] & 0xFF) * mat[k][i]
            
            if s != vecs[j + 2][i]:
                flag = False
                break
        
        if flag:
            print(i, v, f"{v:08b}")
            break

print(mat)

vals = '82 57 91 08 81 8D 72 59 39 48 4E 48 48 4E 57 8D 7D 11 0B 4B 8D 94 08 1F 81 2C 7E 44 69 82 1B 8C 8D 89 2D 93 46 32 21 3F 8D 00 7A 42 6F 93 89 7A 1F 8B 47 89 1E 2A 30 24 0B 89 5D 0D 31 7C 5C 23 92 23 43 12 2C 24 3B 95 00 8B 20 53 36 04 3B 11 19 3E 1B 31 79 60 22 69 25 75 79 91 2E 43 1E 33 3A 82 4F 5E 6A 53 73 37 5C 88 6F 70 0D 24 55 82 92 4F 19 43 63 6A 1E 2C 49 25 03 46 80 33 96 50 7F 32 62 83 0D 00 10 93 40 83 93 31 3A 09 43 6E 93 7C 2B 77 2F 00 69 0F 0B 8B 1B 2B 7E 4A 3F 4B 44 58 96 7C 18 71 53 7C 54 23 7E 37 4D 8F 24 6E 88 02 07 01 3D 14 77 79 1D 49 90 68 51 45 0D 2A 3A 2D 31 92 1F 47 42 4A 28 32 6B 71 1B 44 46 67 6B 80 13 3E 1A 43 93 85 96 0B 73 1B 39 55 66 25 2E 0F 88 13 0D 55 5E 82 85 13 65 6F 48 77 63 6C 25 1E 4E 92 3C 71 26 7A 01 36 6D 18 81 95 28 64'
vals = [int(v, 16) for v in vals.split(' ')]
A = [[0 for j in range(8)] for i in range(8)]

for i in range(8):
    for j in range(8):
        A[i][j] = sum(vals[32 * i + 4 * j:32 * i + 4 * j + 4])

A = Matrix(Zmod(2^32), A)

B = [
    [0x792d, 0x57e4, 0x5557, 0x4d46, 0x213f, 0x42e7, 0x35ce, 0x4387],
    [0x7270, 0x5084, 0x5b24, 0x466c, 0x2729, 0x3472, 0x3a6e, 0x4c62],
    [0x581b, 0x44a2, 0x426e, 0x3d9a, 0x1493, 0x3632, 0x3032, 0x2f30],
    [0x7684, 0x4b5a, 0x4731, 0x4361, 0x206a, 0x3f34, 0x3953, 0x4814],
    [0x6d16, 0x3ffe, 0x4b08, 0x40c7, 0x1f09, 0x334b, 0x3af5, 0x47a0],
    [0x683b, 0x549e, 0x504d, 0x453b, 0x1ea6, 0x3c19, 0x35aa, 0x3c18],
    [0x68e6, 0x4abd, 0x4ded, 0x4169, 0x1c3a, 0x374a, 0x359f, 0x4102],
    [0x6e85, 0x4e31, 0x4924, 0x3f49, 0x219d, 0x394a, 0x308a, 0x44c8],
]
B = Matrix(Zmod(2^32), B)
C = A.inverse() * B

print(C)

ans = ""
for i in range(8):
    for j in range(8):
        ans += f"{int(C[i][j]):01x}"

print(ans)

