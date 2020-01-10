from pwn import *

data = open("output.png", "rb").read()

shits = []
for i in range(0, len(data), 0x1000):
    shits.append(map(ord, list(data[i:i+0x1000])))


opts1 = []
for i in range(52, 61+1):
    for j in range(52, 61+1):
        for k in range(52, 61+1):
            if((k*k*k + i*i*i + j*j*j) % 256 == 98):
                opts1.append([i, j, k])

opts2 = []
for i in range(52, 61+1):
    for j in range(52, 61+1):
        for k in range(52, 61+1):
            for l in range(77, 86+1):
                if((k*k*k + i*i*i + j*j*j + l*l*l) % 256 == 107):
                    opts2.append([i, j, k, l])

opts3 = []
for i in range(77, 86+1):
    for j in range(77, 86+1):
        for k in range(77, 86+1):
            for l in range(34, 43+1):
                if((k*k*k + i*i*i + j*j*j + l*l*l) % 256 == 191):
                    opts3.append([i, j, k, l])

print len(opts1)
print len(opts2)
print len(opts3)


total_len = sum(map(len, shits))
print hex(total_len)

def SHF(sice, curr_len):
    v4 = 0x2FD2B4
    for i in range(curr_len):
        v4 ^= sice[i]
        v4 *= 0x66EC73
        v4 %= 2**64
    return v4

cnt = 0
curr = []
for i in range(15):
    curr.append(shits[i][:])

for opt1 in opts1:
    for opt2 in opts2:
        for opt3 in opts3:
            for fuck_8 in range(77, 86+1):
                ans = []
                ans += [7]
                ans += opt1
                ans += opt2
                ans += [fuck_8]
                ans += opt3
                ans += [12]
                cnt += 1
                if cnt % 100 == 0:
                    print cnt
                for i in range(14):
                    curr[i][10] = ans[i]
                v27 = [curr[i/4096][i % 4096] for i in range(total_len)]
                v12 = SHF(v27, total_len)
                v4 = []
                v4.append((v12 - 125) % 256)
                v4.append((((v12 >> 8) & 0xff) + 124) % 256)
                v4 += map(ord, p16((((v12 >> 16) & 0xffff) - 0x5100 + 0x10000) % 0x10000))
                v4 = ''.join(map(chr, v4))
                if v4 == "Flag":
                    print ans
                    print "SICE"

print cnt
