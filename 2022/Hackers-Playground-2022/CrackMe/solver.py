
arr = [
    bytes.fromhex('61 62 63 64 65 66 67 68'),
    bytes.fromhex('69 6A 6B 6C 6D 6E 6F 70'),
    bytes.fromhex('71 72 73 74 75 76 77 78'),
    bytes.fromhex('79 7A 41 42 43 44 45 46'),
    bytes.fromhex('47 48 49 4A 4B 4C 4D 4E'),
    bytes.fromhex('4F 50 51 52 53 54 55 56'),
    bytes.fromhex('57 58 59 5A 30 31 32 33'),
    bytes.fromhex('34 35 36 37 38 39 40 5F')
]

'''
0x55555556d820: 0x31786275      0x76395075      0x716b4068      0x78587839
0x55555556d830: 0x78433446      0x75333970      0x30393133      0x00003538
'''

target = bytes.fromhex('756278317550397668406b71397858784634437870393375333139303835')

ans = b''

for idx in range(0, len(target), 2):
    x, y = target[idx:idx + 2]

    flag = False
    
    for i in range(64):
        for j in range(64):
            if i // 8 == j // 8:
                if arr[i // 8][((i % 8) + 1) % 8] == x and arr[i // 8][((j % 8) + 1) % 8] == y:
                    ans += bytes([arr[i // 8][i % 8], arr[j // 8][j % 8]])
                    flag = True
                    break
            elif i % 8 == j % 8:
                if arr[(i // 8 + 1) % 8][i % 8] == x and arr[(j // 8 + 1) % 8][j % 8] == y:
                    ans += bytes([arr[i // 8][i % 8], arr[j // 8][j % 8]])
                    flag = True
                    break
            elif arr[i // 8][j % 8] == x and arr[j // 8][i % 8] == y:
                ans += bytes([arr[i // 8][i % 8], arr[j // 8][j % 8]])
                flag = True
                break
            else:
                pass
        if flag:
            break

    if flag is False:
        print(x, y)

print(ans)