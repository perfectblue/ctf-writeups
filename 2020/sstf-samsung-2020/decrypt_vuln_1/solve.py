from z3 import *

s = Solver()

ciph = "1b4eb59dce68c7d5173871ff3211a35bc8d089147c0c4c0f7cdf1b9489d4a640ee173557778095d84d0cd344e213100f2923e8ea96"
known = int(ciph[:26], 16) ^ int("The flag is: ".encode('hex'), 16)

lfsr_1 = [Bool('l1_{}'.format(i)) for i in range(17)]
lfsr_2 = [Bool('l2_{}'.format(i)) for i in range(25)]

for i in range(104):
    out_1 = Xor(lfsr_1[i+0], lfsr_1[i+14])
    lfsr_1.append(Bool('l1_o_{}'.format(i)))
    s.add(lfsr_1[-1] == out_1)
    out_2 = Xor(lfsr_2[i+0], Xor(lfsr_2[i+14], Xor(lfsr_2[i+3], lfsr_2[i+4])))
    lfsr_2.append(Bool('l2_o_{}'.format(i)))
    s.add(lfsr_2[-1] == out_2)
    out = Xor(Xor(out_1, True), out_2)
    act = (known >> (104 - i - 1)) & 1
    s.add(out == bool(act))

# import ipdb
# ipdb.set_trace()

print(s.check())
m = s.model()

reg1 = ''
reg2 = ''

for i in range(17):
    if bool(m[lfsr_1[i]]):
        reg1 += '1'
    else:
        reg1 += '0'

for i in range(25):
    if bool(m[lfsr_2[i]]):
        reg2 += '1'
    else:
        reg2 += '0'

reg1 = int(reg1[::-1], 2)
reg2 = int(reg2[::-1], 2)

print(reg1)
print(reg2)

class LFSR:
        def __init__(self, size, reg, invert):
                assert(size == 17 or size == 25)
                self.size = size
                self.register = reg
                self.taps = [0, 14]
                if size == 25:
                        self.taps += [3, 4]
                self.invert = 1 if invert == True else 0
        def clock(self):
                output = reduce(lambda x, y: x ^ y, [(self.register >> i) & 1 for i in self.taps])
                self.register = (self.register >> 1) + (output << (self.size - 1))

                output ^= self.invert
                return output

def encryptData(reg1, reg2, data):
        data = data.decode("hex")

        lfsr17 = LFSR(17, reg1, True)
        lfsr25 = LFSR(25, reg2, False)

        keystream = 0
        for i in range(len(data) * 8):
                keystream <<= 1
                keystream |= lfsr17.clock() ^ lfsr25.clock()

        pt = int(data.encode("hex"), 16)
        ct = ("%x"%(pt ^ keystream)).rjust(len(data) * 2, "0")

        return ct

print(encryptData(reg1, reg2, ciph).decode('hex'))
