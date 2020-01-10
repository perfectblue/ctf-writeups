WhiteHat 2020 Quals: Misc 03
===============================

We're given a image file `pied_piper.png`. Looking at the hexdump there a lot of additional data after the last chunk (IEND):

```
$ hexdump -C pied_piper.png| grep -A10 -B10 IEND
00154ee0  38 08 25 95 fe 7c 00 d3  43 79 c8 14 04 4f 17 12  |8.%..|..Cy...O..|
00154ef0  0c 0f 0c 16 0a e0 84 0a  49 80 41 c3 b4 04 42 b5  |........I.A...B.|
00154f00  a0 9a f1 e1 06 32 8d 84  32 50 00 48 bb 22 84 2b  |.....2..2P.H.".+|
00154f10  d0 cb 0d 90 84 37 5c c3  a1 63 b0 50 98 24 f6 19  |.....7\..c.P.$..|
00154f20  1f 69 cc 4d 49 cc 4f 4f  6e aa 2c ef 6a 6c e8 69  |.i.MI.OOn.,.jl.i|
00154f30  69 82 16 e6 a6 24 5b 0c  7a 43 88 22 52 a7 85 19  |i....$[.zC."R...|
00154f40  6a a4 12 93 5a 25 e1 fb  42 11 63 23 4c c5 59 19  |j...Z%..B.c#L.Y.|
00154f50  28 bc 79 ed 1a 98 de bf  5f 7c fe eb cf 3e 21 6d  |(.y....._|...>!m|
00154f60  86 10 42 a6 d3 29 9c 90  80 1c b8 e2 f7 df 0e 1d  |..B..)..........|
00154f70  39 f4 dd 81 fd ff 0f 6f  a3 12 43 53 65 e6 6a 00  |9......o..CSe.j.|
00154f80  00 00 00 49 45 4e 44 ae  42 60 82 ce 17 09 00 4a  |...IEND.B`.....J|
00154f90  4d 5d 4d 47 47 47 4a 0e  0f 03 15 47 47 46 73 47  |M]MGGGJ....GGFsG|
00154fa0  47 47 93 4f 41 47 47 47  55 f5 98 ee 47 47 67 47  |GG.OAGGGU...GGgG|
00154fb0  0e 03 06 13 3f db aa 3a  28 c3 1a 1e fd b0 f6 5a  |....?..:(......Z|
00154fc0  00 03 d3 55 62 65 e9 ac  fd a9 c0 ac 39 cf 96 65  |...Ube......9..e|
00154fd0  81 5f 2a 1b 24 f3 cf 15  0d 6e 62 a1 04 cc 55 56  |._*.$....nb...UV|
00154fe0  2a 1b 2a 1b a4 12 e5 d3  3b ff 9d 5f e2 d3 15 0d  |*.*.....;.._....|
00154ff0  ce 5f ea d3 e4 5b 00 6e  6a 1d 03 03 f3 6f e2 03  |._...[.nj....o..|
00155000  f3 51 56 ea 82 2f a4 cd  6f 80 f6 2a ac 1a a8 39  |.QV../..o..*...9|
00155010  99 48 bc eb 32 d9 fa 89  1d 2c e8 f2 b1 9d a0 db  |.H..2....,......|
00155020  ed 1e 9d e8 34 ad db fa  b9 7a 88 f4 39 bc 1e 38  |....4....z..9..8|
```

Extracting the data and doing some analysis on it:

```py
>>> from pwn import *
>>> data = open('pied_piper.png', 'rb').read()
>>> data.index("IEND")
1396611
>>> extra = data[data.index("IEND")+8:]
>>> extra[:16]
'\xce\x17\t\x00JM]MGGGJ\x0e\x0f\x03\x15'
>>> xor(extra[:16], "G")
'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR'
>>>
```

We see that it has some repeated bytes, we try to xor it with that and we get the PNG header. This means that the extra data is a PNG encrypted with a single-byte XOR.
We can easily decrypt it and get the flag.png.

![flag.png](flag.png)

This flag image is a pigpen cipher, which we can decode online to get the flag.
