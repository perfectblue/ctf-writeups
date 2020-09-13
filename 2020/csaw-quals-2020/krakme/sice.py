sice = [102, 109, 99, 100, 127, 104, 53, 52, 124, 86, 103, 56, 83, 100, 96, 80, 114, 125, 123, 99, 103, 74, 120, 72, 123, 113, 41, 122, 104, 103, 99, 0]
print(len(sice))
buf = ''
for i , c in enumerate(sice):
	buf += chr(c ^ i)
print(buf)
# flag{m33t_m3_in_blips_n_ch3atz}