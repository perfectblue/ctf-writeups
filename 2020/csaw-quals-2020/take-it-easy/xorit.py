binary = open('fuck.out', 'rb').read()
key = 'XOR!'

out = b''
for i, c in enumerate(binary):
	out += chr(ord(c) ^ ord(key[i % len(key)]))
open('fuck.xored', 'wb').write(out)
