#!/usr/bin/env python
from reedsolo import *
from pwn import *
from PIL import Image

a = Image.open('homework.png').convert('RGB')
width, height = a.size

bitstream = ''
for y in range(0, 5):
    for x in range(0, width):
        r,g,b = a.getpixel((x,y))
        # print '%d %d %d %d %d' % (x, y, r,g,b)
        if r == 0:
            bitstream += '0'
        else:
            bitstream += '1'

numhex = []
for b in grouper(bitstream, 8, '1'):
    numhex.append(int(''.join(b),2),)
bitstream = numhex

# bitstream = '3B 66 20 79 78 75 20 63 6A 6E 20 72 23 61 64 20 74 68 69 73 20 74 68 65 6E 20 79 6F 75 20 6D 75 3E 74 20 62 65 20 76 65 72 74 20 66 6F 6F 64 20 61 74 20 72 65 65 64 69 6E 67 2C 20 2A 20 67 75 65 73 2F 20 79 6F 75 40 65 20 62 61 72 6E 65 64 20 74 68 5B 73 3A 20 66 6C 20 67 2B 77 30 70 5F 72 2D 72 5F 34 3D 5F 33 6E 79 6C 31 7C 68 5F 6D 34 29 30 72 7D 24 4B 72 67 42 20 3B 31 DE F1 DD 65 40 82 34 76 00 72 4F 68 69 E8 85 A7 CC A5 6C E6 1B A4 42 98 84 F8 39 5F E9 91 C8 4C 69 03 AB'
# bitstream = map(lambda x:int(x,16),bitstream.split(' '))
# text = unordlist(bitstream)

i = 43
msglen = 117
totallen = msglen+i
copy = bitstream[0:totallen]
try:
    out = RSCodec(i,totallen).decode(copy)
    print out
except Exception as e:
    print e
