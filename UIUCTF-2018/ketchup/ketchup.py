from z3 import *

for fuck in range(1, 100):

    flag = BitVec("x" + str(i), fuck * 8)



    #init
    b = [0]*200
    outlen = 64
    out = [0]*outlen
    rsiz = 200 - 2 * outlen
    pt = 0

    def ROTL64(x, y):
        return (((x) << (y)) | ((x) >> (64 - (y))))

    def get_i(st, i):
        result = 0
        for a in range(8):
            result |= st[i * 8 + a] << (a * 8)
        return result

    def set_i(st, i, value):
        for a in range(8):
            st[i * 8 + a] = (value >> 8 * a) & 0xff

    def ketchup(st):
        ketchup_rotc = [1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14, 27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44]
        ketchup_idk = [10, 7,  11, 17, 18, 3, 5, 16, 8,  21, 24, 4,15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1]
        i = 0
        j = 0
        t = 0
        bc = [0]*5
        for i in range(5):
            bc[i] = get_i(st, i) ^ get_i(st, i + 5) ^ get_i(st, i + 10) ^ get_i(st, i + 15) ^ get_i(st, i + 20)
        for i in range(5):
            t = bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1)
            t &= 18446744073709551615
            for j in range(0, 25, 5):
                set_i(st, j + i, get_i(st, j + i) ^ t)
        t = get_i(st, 1)
        for i in range(24):
            j = ketchup_idk[i]
            bc[0] = get_i(st, j)
            set_i(st, j, ROTL64(t, ketchup_rotc[i]))
            t = bc[0]
        for j in range(0, 25, 5):
            for i in range(5):
                bc[i] = get_i(st, j + i)
            for i in range(5):
                toxor = (~bc[(i + 1) % 5]) & bc[(i + 2) % 5]
                set_i(st, j + i, get_i(st, j + i) ^ toxor)
        set_i(st, 0, get_i(st, 0) ^ 1)


    #update
    j = pt
    for i in range(fuck):
        #new_value = (q[j / 4] >> (3 - (j % 4)) * 8) ^ ord(flag[i])
        b[j] ^= flag >> (fuck * 8 - (i + 1) * 8) & 0xff
        j += 1
        if j >= rsiz:
            ketchup(b)
            j = 0
    pt = j
    #final
    b[pt] ^= 0x06
    b[rsiz - 1] ^= 0x80

    ketchup(b)
    s = Solver()
    #target = "38f19f69c71391f53891991b0d0924bd9d803ead26f6e3af7fba67bbb1ad3cbc6d04bee1726f826516a547f4ef0b4454fabbb07ea0da9b00d4c7805667f05514".decode("hex")
    target = "38f19f69c71391f53891991b0d0924bd9d803ead26f6e3af7fba67bbb1ad3cbc6d04bee1726f826516a547f4ef0b4454fabbb07ea0da9b00d4c7805667f05514".decode("hex")

    for i in range(64):
        s.add(ord(target[i]) == b[i])
    if s.check() == sat:
        print "SICE"
        print fuck
        print s.model()
print "unlucky"
