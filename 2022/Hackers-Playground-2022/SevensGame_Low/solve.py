from pwn import *
# context.log_level = 'DEBUG'

ans = {
    (b'\x1b[31m', b'\x1b[31m', b'\x1b[33m', b'\x1b[33m'): b'4',
    (b'\x1b[33m', b'\x1b[34m', b'\x1b[34m', b'\x1b[33m'): b'2',
    (b'\x1b[33m', b'\x1b[33m', b'\x1b[31m', b'\x1b[33m'): b'1',
    (b'\x1b[33m', b'\x1b[31m', b'\x1b[34m', b'\x1b[33m'): b'4',
    (b'\x1b[34m', b'\x1b[34m', b'\x1b[31m', b'\x1b[34m'): b'3',
}

ans_wrong = {
    (b'\x1b[31m', b'\x1b[31m', b'\x1b[33m', b'\x1b[33m'): b'1',
    (b'\x1b[33m', b'\x1b[34m', b'\x1b[34m', b'\x1b[33m'): b'3',
    (b'\x1b[33m', b'\x1b[33m', b'\x1b[31m', b'\x1b[33m'): b'2',
    (b'\x1b[33m', b'\x1b[31m', b'\x1b[34m', b'\x1b[33m'): b'1',
    (b'\x1b[34m', b'\x1b[34m', b'\x1b[31m', b'\x1b[34m'): b'4',
}

while True:
    r = remote('sevensgamelow.sstf.site', 7777)

    cur_mode = 1

    r.sendlineafter(b'menu:', b'5')
    r.sendlineafter(b'menu:', b'2')
    r.sendlineafter(b'menu:', b'0')

    r.sendlineafter(b'menu:', b'2')
    r.sendline(b'5000')

    

    for rnd in range(600):
        r.sendlineafter(b'menu:', b'1')
        l = r.recvline()
        if b'low to play' in l:
            if cur_mode == 2:
                r.sendlineafter(b'menu:', b'2')
                r.sendline(b'500')
                continue
            print("Bankrupt!")
            break
        
        r.recvuntil(b'+-------+-------+-------+\n')
        r.recvuntil(b'+-------+-------+-------+\n')

        l = r.recvline()
        if b'Win the Bonus Game!' in l:
            r.recvline()
            l1 = r.recvline()
            r.recvline()
            l2 = r.recvline()
            r.recvline()

            c1, c2 = l1[6:11], l1[20:25]
            c3, c4 = l2[6:11], l2[20:25]

            if (c1, c2, c3, c4) not in ans:
                print(c1, c2, c3, c4)
                r.interactive()

            if cur_mode != 2:
                r.sendline(ans[(c1, c2, c3, c4)])
            else:
                r.sendline(ans_wrong[(c1, c2, c3, c4)])

        r.sendlineafter(b'menu:', b'3')
        r.recvuntil(b'SCORE :')
        money = int(r.recvline().strip().decode().replace(',', ''))
        r.recvuntil(b'menu: \n')

        if money < 500:
            print("Bankrupt!")
            break
        elif money < rnd * 100:
            print("Slow!")
            break

        if rnd % 1 == 0:
            print(f"Round {rnd}: {money}")

        if money >= 5000000:
            r.sendline(b'1')
            r.interactive()
            exit(0)
        r.sendline(b'a')
        
        if money >= 50000 and cur_mode != 2:
            cur_mode = 2
            r.sendlineafter(b'menu:', b'2')
            r.sendline(b'50000')
        elif money >= 6000 and cur_mode == 0:
            cur_mode = 1
            r.sendlineafter(b'menu:', b'2')
            r.sendline(b'5000')
        elif cur_mode != 2:
            cur_mode = 0
            r.sendlineafter(b'menu:', b'2')
            r.sendline(b'500')
    
    r.close()
    # break
