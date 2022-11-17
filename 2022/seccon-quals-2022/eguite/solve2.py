import z3

n1 = z3.BitVec('n1', 64)
n2 = z3.BitVec('n2', 64)
n3 = z3.BitVec('n3', 64)
n4 = z3.BitVec('n4', 64)

s = z3.Solver()
s.add(n1 + n2 == 0x8B228BF35F6A)
s.add(n2 + n3 == 0xE78241)
s.add(n4 + n3 == 0xFA4C1A9F)
s.add(n4 + n1 == 0x8B238557F7C8)
s.add((n4 ^ n2 ^ n3) == 0xF9686F4D)
print(s.check())
m = s.model()
n1 = m.eval(n1).as_long()
n2 = m.eval(n2).as_long()
n3 = m.eval(n3).as_long()
n4 = m.eval(n4).as_long()

print(f'SECCON{{{n1:012x}-{n2:06x}-{n3:06x}-{n4:08x}}}')
