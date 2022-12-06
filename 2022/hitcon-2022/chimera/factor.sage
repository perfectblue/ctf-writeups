from output import *
from tqdm import tqdm
from Crypto.Util.number import *

a = 143684642197375144177147158855853692668588800554193977558610296778751822580114038001358324581787378580872562099321966717548328915955931557014819660248335768703843650181118037332168940615255654385428471399452134131237486655430385594698984041709528412818098878208671854494888289862816247508570341341144291061804686340591902597677708742601740239151407141330097096057960696869868306378165361528290787726188133329061186703067302036544465101778190513113434324043654457
b = 167352289538521831900068303893849462884611879177327891332587809720230639559806397413772956644716449447590735981383896960276712495542059479149006336979727641959120139405218127535689160497885057304889947873643276371840497731671102379214228403473852990097216100053584104183830792848580118046966013781807107306470368639380702010022756255560693596301723230682190906560616366646290287284412622207608529405928696609593713613820866492056395760168172577692798799704251087
n = 591703505189598943502532470020819444351417786427559744959290752225569789666099653318864844640178933068932025277859268335616211431452288797227920690077916934058390749961256662320969850344143774517775954191622800337672863912047782627

NN = Zmod(n)

def add1(P, Q):
    x1, y1, z1 = P
    x2, y2, z2 = Q

    s1 = (x1 * y2 - x2 * y1) * (y1 * z2 + y2 * z1) + (x1 * z2 - x2 * z1) * y1 * y2
    s1 += -a * (x1 * z2 - x2 * z1) * (x1 * z2 + x2 * z1) - 3 * b * (x1 * z2 - x2 * z1) * z1 * z2
    s2 = -3 * x1 * x2 * (x1 * y2 - x2 * y1) - y1 * y2 * (y1 * z2 - y2 * z1)
    s2 += -a * (x1 * y2 - x2 * y1) * z1 * z2 + a * (y1 * z2 - y2 * z1) * (x1 * z2 + x2 * z1)
    s2 += 3 * b * (y1 * z2 - y2 * z1) * z1 * z2
    s3 = 3 * x1 * x2 * (x1 * z2 - x2 * z1) - (y1 * z2 - y2 * z1) * (y1 * z2 + y2 * z1)
    s3 += a * (x1 * z2 - x2 * z1) * z1 * z2

    assert s2^2 * s3 - s1^3 - a*s1*s3^2 - b*s3^3 == 0

    return [s1, s2, s3]

def add2(P, Q):
    x1, y1, z1 = P
    x2, y2, z2 = Q

    t1 = y1 * y2 * (x1 * y2 + x2 * y1) - a * x1 * x2 * (y1 * z2 + y2 * z1)
    t1 += -a * (x1 * y2 + x2 * y1) * (x1 * z2 + x2 * z1) - 3 * b * (x1 * y2 + x2 * y1) * z1 * z2
    t1 += -3 * b * (x1 * z2 + x2 * z1) * (y1 * z2 + y2 * z1) + a^2 * (y1 * z2 + y2 * z1) * z1 * z2
    t2 = y1^2 * y2^2 + 3 * a * x1^2 * x2^2 + 9 * b * x1 * x2 * (x1 * z2 + x2 * z1)
    t2 += -a^2 * x1 * z2 * (x1 * z2 + 2 * x2 * z1) - a^2 * x2 * z1 * (2 * x1 * z2 + x2 * z1)
    t2 += -3 * a * b * z1 * z2 * (x1 * z2 + x2 * z1) - (a^3 + 9 * b^2) * z1^2 * z2^2
    t3 = 3 * x1 * x2 * (x1 * y2 + x2 * y1) + y1 * y2 * (y1 * z2 + y2 * z1)
    t3 += a * (x1 * y2 + x2 * y1) * z1 * z2 + a * (x1 * z2 + x2 * z1) * (y1 * z2 + y2 * z1)
    t3 += 3 * b * (y1 * z2 + y2 * z1) * z1 * z2

    assert t2^2 * t3 - t1^3 - a*t1*t3^2 - b*t3^3 == 0

    return [t1, t2, t3]

def add(P, Q):
    x1, y1, z1 = add1(P, Q)
    x2, y2, z2 = add2(P, Q)
    return [(x1 + x2), (y1 + y2), (z1 + z2)]

def mult(k, P):
    if k == 0:
        return (0, 1, 0)
    elif k == 1:
        return P
    
    t = mult(k//2, P)
    t = add(t, t)
    if k % 2 == 1:
        t = add(t, P)
    return t

P = [NN(chimera[0][0]), NN(chimera[0][1]), NN(1)]
res = mult(26547499809981069510927003971948749075772722276992950364792314618117852191809368252259393907545335096600102525321072, P)


print(gcd(int(res[0]), n))
print(gcd(int(res[1]), n))
print(gcd(int(res[2]), n))

exit(0)

# st = set()

# def backtrack(idx, val, upper):
#     # print(idx, val)
#     if idx == len(factors):
#         global st
#         st.add(val)
#         # print(val)
#         return

#     if val * upper // factors[idx] >= MIN:
#         backtrack(idx + 1, val, upper // factors[idx])
#     if val * factors[idx] < MAX:
#         backtrack(idx + 1, val * factors[idx], upper // factors[idx])

# backtrack(0, 1, gift)

# E = EllipticCurve(Zmod(n), [a, b])
# for v in tqdm(st):
#     for xy in chimera:
#         P, flag = E(*xy), False
#         try:
#             T = v * P
#         except ZeroDivisionError:
#             flag = True
        
#         if not flag:
#             break
#     else:
#         print(v)

pos = [
    26547499809981069510927003971948749075772722276992950364792314618117852191809368252259393907545335096600102525321072,
    22288483263012814591348765846880205017828692034537673547054108766305150848936155217127280012115743233530006890953060
]

load('coppersmith/coppersmith.sage')

bounds = (floor(n^.25), floor(n^.25))
roots = tuple(randrange(bound) for bound in bounds)
R = Integers(n)
P.<x, y> = PolynomialRing(R)
monomials = [x, y, x*y, x^2]
f = (x - pos[0]) * (y - pos[1])
print(small_roots(f, bounds))

# print("backtrack fin")
# Zn = Zmod(n)
# P.<x> = PolynomialRing(Zn)
# print(gift - pos[1] * pos[2])
# for v1 in pos:
#     for v2 in pos:
#         print(n - v1 * v2)