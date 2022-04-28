from pwn import *
import os
from PIL import Image

f = "sice.png"

def get_hash(img_file1, img_file2):
	r = process("cargo run".split())
	# r = remote("icu.chal.pwni.ng", 1337)
	# L = r.recvline().strip()
	# out = os.popen(L).read()
	# r.sendline(out.strip())
	r.recvuntil("Image 1 (base64):")
	b64 = open(img_file1, "rb").read().encode("base64").replace("\n", "")
	r.sendline(b64)
	r.recvuntil("Image 2 (base64):")
	b64 = open(img_file2, "rb").read().encode("base64").replace("\n", "")
	r.sendline(b64)

	r.interactive()

	r.recvuntil("hash: ")
	hash1 = r.recvline().strip().decode("base64")
	r.recvuntil("hash: ")
	hash2 = r.recvline().strip().decode("base64")
	r.recvuntil(": ")
	distance = int(r.recvline().strip())
	r.recvuntil("text: ")
	text1 = r.recvline()
	r.recvuntil("text: ")
	text2 = r.recvline()
	r.close()

	return hash1, hash2, distance, text1, text2

def diff_hash(a, b):
	c = 0
	for i in range(len(a)):
		b1 = bin(ord(a[i]))[2:].zfill(8)
		b2 = bin(ord(b[i]))[2:].zfill(8)
		for j in range(8):
			if b1[j] != b2[j]:
				c += 1
	return c

def construct_hash(h, fname):
	temp_name = "temp.png"

	img = Image.new(mode="L", size=(9, 8), color=(0))

	row = 0
	for cur_byte in h:
		b = bin(ord(cur_byte))[2:].zfill(8)[::-1]
		img.putpixel((0, row), (128))
		current = 128
		for i in range(8):
			if b[i] == "0":
				img.putpixel((1 + i, row), current - 1)
				current -= 1
			else:
				img.putpixel((1 + i, row), current + 1)
				current += 1
		row += 1

	img.save(temp_name)
	current_hash, _, _, _, _ = get_hash(temp_name, temp_name)
	assert current_hash == h

	# upscale it
	SIZE = 200
	img2 = Image.new(mode="L", size=(9*SIZE, 8*SIZE))
	for i in range(9):
		for j in range(8):
			off_x = i * SIZE
			off_y = j * SIZE

			p = img.getpixel((i, j))
			for k in range(200):
				for l in range(200):
					img2.putpixel((off_x + k, off_y + l), p)
	img2.save("upscaled.png")

# construct_hash("ERsrE6nTHhI=".decode("base64"), f)

hash1, hash2, distance, text1, text2 = get_hash("test.jpg", "test2.jpg")

print("Hash1: {}\nHash2: {}\nDistance: {}\ntext1: {}text2: {}".format(hash1, hash2, distance, text1, text2))

# sice = Image.open("sice.png")
# sice.save("sice.jpg", compress_level=0)
# jpg_hash, _, _, _, _ = get_hash("sice.jpg", "sice.jpg")


# win = Image.open("sice.jpg")
# # for i in range(200):
# 	# for j in range(200):
# win.putpixel((1799, 1599), 255)
# win.save("win.jpg")
