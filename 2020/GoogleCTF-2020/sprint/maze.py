import math
ayylmao = [
'CC B0 E7 7B BC C0 EE 3A FC 73 81 D0 7A 69 84 E2',
'48 E3 D7 59 11 6B F1 B3 86 0B 89 C5 BF 53 65 65',
'F0 EF 6A BF 08 78 C4 2C 99 35 3C 6C DC E0 C8 99',
'C8 3B EF 29 97 0B B3 8B CC 9D FC 05 1B 67 B5 AD',
'15 C1 08 D0 45 45 26 43 45 6D F4 EF BB 49 06 CA',
'73 6B BC E9 50 97 05 E5 97 D3 B5 47 2B AD 25 8B',
'AE AF 41 E5 D8 14 F4 83 E6 F0 C0 98 0A AC A1 95',
'F5 B5 D3 53 F0 97 EF 9D D4 3B 3B 0B E7 17 07 1F',
'6C F1 1E 44 92 B2 57 07 B7 36 8F 53 C9 EA 10 90',
'62 DF 1D 07 B3 71 53 61 1A 2B 78 BF C1 B5 C6 3B',
'EA 2B 44 17 A0 84 CA 8F B7 3B 38 2F E8 73 84 AD',
'44 EF F8 AD 8C 1F EA 7F CD C5 B3 49 05 03 95 A7',
'44 B5 91 69 F8 95 6C E5 87 53 4E 47 92 BE 80 D0',
'80 1D AD F1 3D E3 DF 35 61 F1 E7 0D 71 C5 02 4F',
'20 5E A2 8B C4 61 32 0F A8 BE 7E 29 D1 6D 2A D9',
'55 47 07 83 EA 2B 79 95 4F 3D A3 11 DD C1 1D 89',
]
def is_prime(i):
	if i == 1: return False
	if i == 2: return True
	for j in range(2, int(math.sqrt(i)+1)):
		if i % j == 0:
			return False
	return True
penis = []
for l in ayylmao:
	lol = []
	cs = map(lambda x: int(x, 16), l.split(' '))
	for c in cs:
		if is_prime(c):
			lol += ' '
		else:
			lol += '#'
	penis.append(lol)
waypoints = [0x83, 0x01, 0xAF, 0x49, 0xAD, 0xC1, 0x0F, 0x8B, 0xE1, ]
for i,wp in enumerate(waypoints):
	wp = 256 - wp
	row = wp >> 4
	col = wp & 0xf
	print(row,col)
	assert penis[row][col] == ' '
	penis[row][col] = str(i+1)

for row in penis:
	l = ''
	for c in row:
		l += c
	print(l)
