def SHF(sice, curr_len):
    v4 = 0x2FD2B4
    for i in range(curr_len):
        v4 ^= sice[i]
        v4 *= 0x66EC73
        v4 %= 2**64
    return v4

data = open("output.png", "rb").read()

shits = []
for i in range(0, len(data), 0x1000):
    shits.append(map(ord, list(data[i:i+0x1000])))

cnt = 0
curr = []
for i in range(15):
    curr.append(shits[i][:])

total_len = sum(map(len, shits))
print hex(total_len)

deet = [7, 54, 61, 61, 59, 56, 58, 80, 83, 79, 85, 83, 38, 12]

for i in range(14):
    curr[i][10] = deet[i]

for i in range(7):
    if (curr[2*i][0] + curr[2*i+1][0]) % 2 == 0:
        curr[2*i], curr[2*i+1] = curr[2*i+1], curr[2*i]

haxxor = []

f = open('data', 'wb')
for i in range(len(curr)):
    haxxor += curr[i]
    f.write(''.join(map(chr, curr[i])))
f.close()

print SHF(haxxor, total_len)
