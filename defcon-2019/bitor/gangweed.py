from z3 import *

s = Solver()
flag = [BitVec('flag_' + str(i), 8) for i in range(45)]
s.add(flag[0] == BitVecVal(ord('O'), 8))
s.add(flag[1] == BitVecVal(ord('O'), 8))
s.add(flag[2] == BitVecVal(ord('O'), 8))
s.add(flag[3] == BitVecVal(ord('{'), 8))
s.add(flag[-1] == BitVecVal(ord('}'), 8))
for i in range(len(flag)):
    s.add(flag[i] >= BitVecVal(0x20, 8))
    s.add(flag[i] < BitVecVal(0x7f, 8))

# stage1 brute key checked in vitor/classes.dex
bArr = [BitVecVal(0, 8) for i in range(0,4)]
for i in range(0,10,1):
   for j in range(4):
       bArr[j] = bArr[j] ^ flag[4 + 4*i + j]
#bArr is now [0x17, 0x01, 0x2f, 0x03]
s.add(bArr[0] == BitVecVal(0x17, 8))
s.add(bArr[1] == BitVecVal(0x01, 8))
s.add(bArr[2] == BitVecVal(0x2f, 8))
s.add(bArr[3] == BitVecVal(0x03, 8))

# stage2 brute key , generated in g1 in dec/classes.dex
bArr = [BitVecVal(0, 8) for i in range(0,4)]
for i in range(0,10,2):
   for j in range(4):
       bArr[j] = bArr[j] ^ flag[4 + 4 * (i+1) + j]
#bArr is now [0x3c, 0x27, 0x43, 0x60]
s.add(bArr[0] == BitVecVal(0x3c, 8))
s.add(bArr[1] == BitVecVal(0x27, 8))
s.add(bArr[2] == BitVecVal(0x43, 8))
s.add(bArr[3] == BitVecVal(0x60, 8))

# stage3 generated in g2 in native lib mmdffuoscjdamcnssn.so
bArr = [BitVecVal(0, 8) for i in range(0,4)]
for i in range(3,10,3):
   for j in range(4):
       bArr[j] = bArr[j] ^ flag[4 + 4 * (i - 1) + j]
#bArr is now 0x4e27636e
s.add(bArr[0] == BitVecVal(0x6e, 8))
s.add(bArr[1] == BitVecVal(0x63, 8))
s.add(bArr[2] == BitVecVal(0x27, 8))
s.add(bArr[3] == BitVecVal(0x4e, 8))

# stage4 generated in decrypted chode
bArr = [BitVecVal(0, 8) for i in range(0,4)]
for i in range(4,10,4):
   for j in range(4):
       bArr[j] = bArr[j] ^ flag[4 * i + j]
#bArr is now 0x13331842
s.add(bArr[0] == BitVecVal(0x42, 8))
s.add(bArr[1] == BitVecVal(0x18, 8))
s.add(bArr[2] == BitVecVal(0x33, 8))
s.add(bArr[3] == BitVecVal(0x13, 8))

# stage5 generated in rop
bArr = [BitVecVal(0, 8) for i in range(0,4)]
for i in range(5,11,5):
   for j in range(4):
       bArr[j] = bArr[j] ^ flag[4 * i + j]
# bArr is now V-R]
s.add(bArr[0] == BitVecVal(ord('V'), 8))
s.add(bArr[1] == BitVecVal(ord('-'), 8))
s.add(bArr[2] == BitVecVal(ord('R'), 8))
s.add(bArr[3] == BitVecVal(ord(']'), 8))

# last part of the flag. from the javascript bullshit
lastpart = " => pHd_1w_e4rL13r;)"
for i, c in enumerate(map(ord, lastpart)):
    s.add(flag[24+i] == BitVecVal(c, 8))

print s.check()
m = s.model()
result = ''
for i in range(len(flag)):
    result += chr(int(str(m.eval(flag[i]))))
print result
print result.encode('hex')

#OOO{pox&mpuzz,U_solve_it => pHd_1w_e4rL13r;)}