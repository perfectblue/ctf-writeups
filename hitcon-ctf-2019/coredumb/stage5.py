for c1 in [ord('u'), ord('U')]:
    temp1 = c1
    for c2 in range(0xff+1):
        temp2 = c2
        for c3 in range(0xff+1):
            temp3 = c3
            for c4 in range(0xff+1):
                temp4 = c4
                flag = [temp1, temp2, temp3, temp4]
                c = 0
                cur = 0xffffffff
                for j in range(4):
                    if flag[j] == 0:
                        break
                    v1 = c
                    c += 1
                    cur = cur ^ flag[v1]
                    for i in range(8)[::-1]:
                        cur = (cur >> 1) ^ (0x100000000 - ((cur & 1)) & 0xEDB88320)
                if cur & 0xffffffff == 0x29990129:
                    print("WIN")
                    print(flag)