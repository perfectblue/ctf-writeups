from output import *
from Crypto.Util.number import *

# ps = [(e, c) for e, c in zip(es, cs)]

# mat = []

# for i in range(len(es)):
#     mat.append([(es[i] + 1) * 1000] + [0] * i + [1] + [0] * (len(es) - i))

# mat = Matrix(mat)
# mat = mat.LLL()

# now = None
# for row in mat:
#     if row[0] != 0:
#         continue
    
#     l, r = 1, 1
#     for j in range(len(es)):
#         if row[j + 1] < 0:
#             r *= pow(cs[j], -row[j + 1])
#         else:
#             l *= pow(cs[j], row[j + 1])
    
#     diff = abs(l - r)
#     if now is None:
#         now = diff
#     else:
#         now = gcd(now, diff)

# print(factor(now))

# from the factored result
p = 114123489471785231935784934808971699969409921187241213856052699152350022529522625133249122600992294384493330729753558097354310956450782137388609095123051712848950720360020186805006589596948820312938610934162552701552428320073591829720623902109809701883779673050594202312941073709061911680769616320309646800153

# mat = []
# for i in range(len(es)):
#     mat.append([(p + es[i]) * 1000] + [0] * i + [1] + [0] * (len(es) - i))

# mat = Matrix(mat)
# mat = mat.LLL()

# now = None
# for row in mat[:-1]:
#     print(row)
#     if row[0] != 0:
#         continue
    
#     l, r = 1, 1
#     for j in range(len(es)):
#         if row[j + 1] < 0:
#             r *= pow(cs[j], -row[j + 1])
#         else:
#             l *= pow(cs[j], row[j + 1])
    
#     diff = abs(l - r)
#     if now is None:
#         now = diff
#     else:
#         now = gcd(now, diff)
    
#     assert now % p == 0
#     print(now // p)

# print(now)
# from the factored result
q = 155312366755994695153905431155013822779796503239614940420723948832332918237930252610493357947142159292596935688727806711606570267559093776356748278389479257753345043473861780569830053269636280107067310144998217282879487875899092886496346312145691346641358602525635446079674778099204333711717420070242120920463
n = p * q

for i in range(len(es)):
    for j in range(len(es)):
        g, x, y = xgcd(p + es[i], p + es[j])

        if g == 1:
            m = pow(cs[i], x, n) * pow(cs[j], y, n)
            print(long_to_bytes(int(m)))