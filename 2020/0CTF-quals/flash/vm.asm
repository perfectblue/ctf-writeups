0000: cns 0x91d

0004: cns 0x0
0008: get_flagind
000a: seq
000c: bne loop_end
0010: cns 0x1
0014: get_flagind
0016: sub
0018: set_flagind
001a: read1
001c: cns 0x1
0020: bne 0x4

loop_end:

(inp * 0x11) % 0xb248 == 0x72a9
0024: cns 0x11
0028: mult
002a: cns 0xb248
002e: mod
0030: cns 0x72a9
0034: seq
0036: beq 0x17e

003a: cns 0x11
003e: mult
0040: cns 0xb248
0044: mod
0046: cns 0x97e
004a: seq
004c: beq 0x17e

0050: cns 0x11
0054: mult
0056: cns 0xb248
005a: mod
005c: cns 0x5560
0060: seq
0062: beq 0x17e

0066: cns 0x11
006a: mult
006c: cns 0xb248
0070: mod
0072: cns 0x4ca1
0076: seq
0078: beq 0x17e

007c: cns 0x11
0080: mult
0082: cns 0xb248
0086: mod
0088: cns 0x37
008c: seq
008e: beq 0x17e

0092: cns 0x11
0096: mult
0098: cns 0xb248
009c: mod
009e: cns 0xaa71
00a2: seq
00a4: beq 0x17e

00a8: cns 0x11
00ac: mult
00ae: cns 0xb248
00b2: mod
00b4: cns 0x122c
00b8: seq
00ba: beq 0x17e

00be: cns 0x11
00c2: mult
00c4: cns 0xb248
00c8: mod
00ca: cns 0x4536
00ce: seq
00d0: beq 0x17e

00d4: cns 0x11
00d8: mult
00da: cns 0xb248
00de: mod
00e0: cns 0x11e8
00e4: seq
00e6: beq 0x17e

00ea: cns 0x11
00ee: mult
00f0: cns 0xb248
00f4: mod
00f6: cns 0x1247
00fa: seq
00fc: beq 0x17e

0100: cns 0x11
0104: mult
0106: cns 0xb248
010a: mod
010c: cns 0x76c7
0110: seq
0112: beq 0x17e

0116: cns 0x11
011a: mult
011c: cns 0xb248
0120: mod
0122: cns 0x96d
0126: seq
0128: beq 0x17e

012c: cns 0x11
0130: mult
0132: cns 0xb248
0136: mod
0138: cns 0x122c
013c: seq
013e: beq 0x17e

0142: cns 0x11
0146: mult
0148: cns 0xb248
014c: mod
014e: cns 0x87cb
0152: seq
0154: beq 0x17e

0158: cns 0x11
015c: mult
015e: cns 0xb248
0162: mod
0164: cns 0x9e4
0168: seq
016a: beq 0x17e

016e: cns 0x91d
0172: beq 0x17e
0176: cns 0x0
017a: set_flagind
017c: exit

017e: cns 0x1
0182: set_flagind
0184: exit
