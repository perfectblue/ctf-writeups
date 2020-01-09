import socket
import struct
import string
import binascii
from pwn import *

from chosen_plaintext import ChosenPlaintext
from Crypto.Cipher import AES

def pad(x):
    l = 16 - (len(x) % 16)
    return (x + chr(l) * l)

proc = remote('crypto.chal.csaw.io', 1003)
flag = proc.recvline().strip().decode('hex')

class Client(ChosenPlaintext):

    def __init__(self):
        ChosenPlaintext.__init__(self)
        return

    def ciphertext(self, plaintext):
        print repr(plaintext)
        proc.recvuntil("something: ")
        proc.sendline(plaintext)
        proc.recvline()
        res = proc.recvline().strip().decode('hex')
        # print res.encode('hex')
        return res
        # return AES.new('a' * 16, AES.MODE_ECB).encrypt(pad("abc" + plaintext + "Lorem Ipsum Dolor Sit Amet"))

c = Client()
c.run()
print 'recovered', repr(c.plaintext)

# flag{y0u_kn0w_h0w_B10cks_Are_n0T_r31iab13...}
