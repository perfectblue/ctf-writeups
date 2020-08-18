from pwn import xor
from pwn import u32
a = open("libvault.so", "rb").read()

off = 0x1720
data1 = a[off:][:128]

key = "Love"

res = [0]*128
for i in range(0, 128, 2):
	res[i] = chr(ord(data1[i]) ^ ord(key[i & 2]))
	res[i + 1] = chr(ord(data1[i + 1]) ^ ord(key[(i+1) & 3]))
res = "".join(res)
print(len(res))

key = ""
for i in range(0, 0x20):
	curval = 0
	for j in range(4):
		curval ^= ord(res[4*i + j])
	key += chr(curval)
print(key)
print(key.encode("hex"))

ciphertext = a[0x1620:0x16d0]
ct = ""
for i in range(0, len(ciphertext), 4):
	curval = u32(ciphertext[i:i+4])
	ct += chr(curval)
print(ct.encode("hex"))
