from pwn import *
from gmpy2 import *

proc = remote("43.154.211.24", 2333)

a = proc.recvline().strip().decode()
exp = int(a.split()[1].split('^')[-1][:-1])
mod = int(a.split()[3])
print(exp, mod)

ans = pow(mpz(2), pow(mpz(2), mpz(exp)), mpz(mod))
proc.sendline(str(ans))

print(proc.recvline())
print(proc.recvline())

soln = open("soln.lua", "rb").read()
proc.send(p32(len(soln)))
proc.send(soln)

proc.interactive()
