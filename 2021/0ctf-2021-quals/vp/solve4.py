from pwn import *
ans = '''
2437859106
3580674291
5123987460
4091765382
8652140973
0974236518
9365418027
6809521734
1746302859
7218093645
'''.strip().split('\n')

ans2 = b''
for line in ans:
    ans2 += bytes([int(x) + 1 for x in line])
with open('output', 'wb') as f:
    f.write(ans2 + p16(0xcc8) + p16(0x8008))
