from pwn import *

from bplib.bp import G1Elem, G2Elem
from base64 import b64encode, b64decode
from bls.scheme import *

r = remote("crypto.chal.csaw.io", 1004)
r.recvuntil("Abra")
r.recvline()
p0 = r.recvline().strip().decode("base64")
r.recvuntil("Bern")
r.recvline()
p1 = r.recvline().strip().decode("base64")
r.recvuntil("Ches")
r.recvline()
p2 = r.recvline().strip().decode("base64")

r.sendline("1")
r.sendline("ham")
r.recvuntil("sure th")
r.recvline()
s0 = r.recvline().strip().decode("base64")

r.sendline("3")
r.sendline("this stuff")
r.recvuntil("ok, su")
r.recvline()
s2 = r.recvline().strip().decode("base64")

def getsignature(self, ask, who):
    ask_s = b64decode(str(raw_input(ask)))
    s = G1Elem.from_bytes(ask_s, self.params[0])
    ask_p = b64decode(str(raw_input(who)))
    p = G2Elem.from_bytes(ask_p, self.params[0])
    assert p in self.vks
    return (s, p)

def pretty_point(x):
    return b64encode(x.export())

params = setup()

# ask_p = b64decode(str(raw_input("P0")))
p0 = G2Elem.from_bytes(p0, params[0])

# ask_p = b64decode(str(raw_input("P1")))
p1 = G2Elem.from_bytes(p1, params[0])

# ask_p = b64decode(str(raw_input("P2")))
p2 = G2Elem.from_bytes(p2, params[0])

# ask_s = b64decode(str(raw_input("S0")))
s0 = G1Elem.from_bytes(s0, params[0])

# ask_s = b64decode(str(raw_input("S2")))
s2 = G1Elem.from_bytes(s2, params[0])

(G, o, g1, g2, e) = params
t = 3
l = [lagrange_basis(t, o, i, 0) for i in range(1,t+1)]
t = 2
l2 = [lagrange_basis(t, o, i, 0) for i in range(1,t+1)]

deetv = [p0, p1, p2 * l2[0] + (p0 * l[0]).neg() + (p1 * l[1]).neg()]
deets = [s0 * l2[1] + s2, (s0 * l2[0]).neg()]
verif = aggregate_vk(params, deetv, threshold=True)

for i in deets:
    print(pretty_point(i))

for i in deetv:
    print(pretty_point(i))

r.sendline("4")
r.recvuntil("please")
r.sendline(pretty_point(deets[0]))
r.recvuntil("?")
r.sendline(pretty_point(deetv[0]))

r.sendline(pretty_point(deets[1]))
r.sendline(pretty_point(deetv[1]))

r.sendline(pretty_point(deetv[2]))

r.interactive()

# print verify(params, verif, aggregate_sigma(params, deets, threshold=True), "this stuff")
