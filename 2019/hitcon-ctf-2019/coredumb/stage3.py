hardchode = """32716E66492D7C2A
24645A410A202130
7B2F445C6F583C72
377A5434617E434B
7D0B60783A5E5929
76696D4F79317353
4E5F5B405D250D23
677551562C6A4828""".split("\n")

sol = """23415F4125516034
7D482F41255A3A54
0B515B41536D257B""".split("\n")

target = ""

hardcoded = []
for i in hardchode:
    penis = ""
    penis = i.decode("hex")
    temp = penis[::-1]
    for a in temp:
        hardcoded.append(ord(a))

for i in sol:
    penis = ""
    penis = i.decode("hex")
    target += penis[::-1]

ind = 0

print len(hardcoded)

calcs = [0]*24

v9 = 0
flag = ""
while 18 - ind > 2:
    for c1 in range(0xff+1):
        temp1 = c1
        for c2 in range(0xff+1):
            temp2 = c2
            for c3 in range(0xff+1):
                temp3 = c3
                c1 = temp1
                c2 = temp2

                val1 = v9
                val2 = v9 + 1
                calcs[val1] = hardcoded[c1 >> 2]

                val3 = val2
                val2 += 1
                calcs[val3] = hardcoded[16 * c1 & 0x30 | (c2 >> 4)]
                calcs[val2] = hardcoded[4 * c2 & 0x3c | (c3 >> 6)]

                val4 = val2 + 1

                calcs[val4] = hardcoded[c3 & 0x3f]

                good = True
                for i in range(ind / 3 * 4, ind / 3 * 4 + 4):
                    if calcs[i] != ord(target[i]):
                        good = False
                        break
                if good:
                    print("WIN")
                    flag += chr(temp1) + chr(temp2) + chr(temp3)
                    print(temp1, temp2, temp3)
    v9 = val2 + 2
    ind += 3

# (114, 95, 114)


print flag