fmt = """A(M(12))R(48,13)A(M(14))R(66,15)M(16)R(150,17)A(M(18))R(
             36,19)A(M(20))R(46,21)M(22)R(131,23)A(M(24))R(32,25)M(26)
             R(161,27)A(M(28))R(66,29)A(M(30))R(26,31)A(M(32)) R(34,33
             )M(34)R(140,35)M(36)R(223,37)A(M(38))R(28,39)A( M(40))R(
             88,41)A(M(42))R(90,43)A(M(44))R(10,45)M(46)R( 155,47)M(48
             )R(159,49)A(M(50))R(116,51)M(52)R(141,53)M(54)R(151,55)A(
             M(56))R(22,57)M(58)R(140,59)A(M(60))R(122,61)M(62)R(154,
             63)M(64)R(153,65)A(M(66))R(22,67)M(68)R(146,69)A(M(70))R
             (66,71)"""

fmt = fmt.replace(' ', '').replace('\n', '')

inp = [27, 18, 5, 15, 14, 29, 12, 11, 21, 7, 24, 8, 28, 13, 2, 0, 4, 22, 10, 3, 20, 19, 6, 16, 1, 17, 26, 25, 23, 9]

ans = bytearray(30)

idx = 0
while idx < len(fmt):
    n1, n2 = fmt.find(")A", idx), fmt.find(")M", idx)
    if n1 == -1 and n2 == -1: nxt = len(fmt) + 1
    elif n1 == -1: nxt = n2 + 1
    elif n2 == -1: nxt = n1 + 1
    else: nxt = min(n1, n2) + 1

    chunk = fmt[idx:nxt]
    print(chunk)

    if chunk.startswith('A'):
        a, b, c = map(int, chunk[4:-1].replace('))R(', ',').split(','))
        ans[inp[(a - 12) // 2]] = (256 - b) // 2
    else:
        a, b, c = map(int, chunk[2:-1].replace(')R(', ',').split(','))
        ans[inp[(a - 12) // 2]] = (256 - b)

    idx = nxt

print(ans)
