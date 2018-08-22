bufCpy = [0]*32
bufCpy[0] = 0xC7
bufCpy[1] = 60
bufCpy[2] = 18
bufCpy[3] = 9
bufCpy[4] = 7
bufCpy[5] = -114
bufCpy[6] = -120
bufCpy[7] = -71
bufCpy[8] = 24
bufCpy[9] = -108
bufCpy[10] = 75
bufCpy[11] = 109
bufCpy[12] = 19
bufCpy[13] = 21
bufCpy[14] = -127
bufCpy[15] = 92
bufCpy[16] = -91
bufCpy[17] = -57
bufCpy[18] = 13
bufCpy[19] = 35
bufCpy[20] = -17
bufCpy[21] = 69
bufCpy[22] = -20
bufCpy[23] = -55
bufCpy[24] = -79
bufCpy[25] = 5
bufCpy[26] = -74
bufCpy[27] = 0x84
bufCpy[28] = 55
bufCpy[29] = 99
bufCpy[30] = -34
bufCpy[31] = -91
fuck=[0x8A,
0x68,
0x43,
0x39,
0x55,
0xCA,
0xC1,
0xC1,
0x57,
0xC1,
0x1D,
0x2A,
0x5D,
0x40,
0xC8,
0x69,
0xEB,
0x83,
0x58,
0x16,
0xBD,
0x0,
0xA9,
0xFD,
0xE3,
0x51,
0xF0,
0xC1,
0x7A,
0x27,
0x90,
0xE6,]
for i in range(len(bufCpy)):
       bufCpy[i]%=256
       bufCpy[i]^=fuck[i]
a=''
for c in bufCpy:
       a+=chr(c)


print a
# MTQ0RDIxOUVGNUI5NDU5REE4RTFEMDNC
# 144D219EF5B9459DA8E1D03B