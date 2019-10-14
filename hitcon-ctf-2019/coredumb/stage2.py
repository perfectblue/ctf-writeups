
target = [0x95CB8DBD, 0xF84CC79, 0xB899A876, 0xA5DAB55, 0x9A8B3BBA, 0x70B238A7, 0x72B53CF1, 0xD47C0209]


for c1 in range(0xff+1):
    temp = c1
    for c2 in range(0xff+1):
        temp2 = c2
        c1 = temp
        increment = 0
        key = [0x43, 0x30, 0x52, 0x33]
        for j in range(32):
            c1 += (((c2 >> 5) ^ 16 * c2) + c2) ^ ((key[increment & 3]) + increment)
            c1 &= 0xffffffff
            increment += 0x1337DEAD
            c2 += (((c1 >> 5) ^ 16 * c1) + c1) ^ ((key[(increment >> 11) & 3]) + increment)
            c2 &= 0xffffffff
        if c1 & 0xffffffff == target[2] and c2 & 0xffffffff == target[3]:
            print(c1, c2)
            print(temp, temp2)
            exit()
# 95 104 109 95 117 70 67 48
