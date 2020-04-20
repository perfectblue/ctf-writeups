from z3 import *

flag_chars = [BitVec('flag%d' % i, 32) for i in range(21)]
check_data = [[2, 5, 12, 19, 3749774], [2, 9, 12, 17, 694990], [1, 3, 4, 13, 5764], [5, 7, 11, 12, 299886], [4, 5, 13, 14, 5713094], [0, 6, 8, 14, 430088], [7, 9, 10, 17, 3676754], [0, 11, 16, 17, 7288576], [5, 9, 10, 12, 5569582], [7, 12, 14, 20, 7883270], [0, 2, 6, 18, 5277110], [3, 8, 12, 14, 437608], [4, 7, 12, 16, 3184334], [3, 12, 13, 20, 2821934], [3, 5, 14, 16, 5306888], [4, 13, 16, 18, 5634450], [11, 14, 17, 18, 6221894], [1, 4, 9, 18, 5290664], [2, 9, 13, 15, 6404568], [2, 5, 9, 12, 3390622]]

# zz is injective (one-to-one) so we can just treat zz(x) as a variable while solving and invert after solving the system of equations
def zz_helper(x, y, z):
  if y > z:
    return (1, z - x)
  a, b = zz_helper(y, x + y, z)
  if b >= x:
    return (2 * a + 1, b - x)
  else:
    return (2 * a + 0, b)

lut = {}
for i in range(0x10000):
  a, _ = zz_helper(1,1,i)
  lut[a] = i

s = Solver()
checksum = 0
for x in flag_chars:
  checksum = checksum ^ x
s.add(checksum == 5803878)

for a, b, c, d, target in check_data:
  s.add(flag_chars[a] ^ flag_chars[b] ^ flag_chars[c] ^ flag_chars[d] == target)

print s.check()
flag =''
model=s.model()
for c in flag_chars:
  c1c2 = lut[int(str(model.eval(c)))]
  c1, c2 = chr(c1c2 >> 8), chr(c1c2 & 0xff)
  flag += c1 + c2
print flag
