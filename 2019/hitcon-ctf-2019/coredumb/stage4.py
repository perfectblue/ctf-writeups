store = [0]*252

chode = """30645F7361336C50
353452635F74276E
21682B5F6E315F68
312B436E55665F73
6E30""".split("\n")

gay = [0]*12

hardcoded = []
for i in chode:
    penis = ""
    penis = i.decode("hex")
    temp = penis[::-1]
    for a in temp:
        hardcoded.append(ord(a))

check = """14DD43A0935D552B""".decode("hex")[::-1] + "E57D5243".decode("hex")[::-1]
target = []
for i in check:
    target.append(ord(i))

v9 = 0
for i in range(246):
    store[i] = i
for j in range(246):
    v9 = (hardcoded[j % 34] + store[j] + v9) % 246
    v2 = store[j]
    store[j] = store[v9]
    store[v9] = v2
c = 0
v7 = 0
val1 = 0
flag = ""
while c < 12:
    v7 = (v7 + 1) % 246
    val1 = (store[v7] + val1) % 246
    val3 = store[v7]
    store[v7] = store[val1]
    store[val1] = val3
    gay[c] = store[(store[v7] + store[val1]) % 246]
    flag += chr(target[c] ^ gay[c])
    c += 1
print(flag)