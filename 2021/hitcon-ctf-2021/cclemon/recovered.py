from tqdm import tqdm

mem = dict()
mem[0] = 68694329

def w():
    mem[0] = (mem[0] * 1259409 + 321625345) % 4294967296
    return mem[0]

class A:
    def __init__(self, n):
        self.a = []

        for i in range(n):
            self.a.append(w())

    def r(self, x, y):
        if x > y:
            return self.r(y, x)
        while x < y:
            self.s(x, y)
            x = x + 1
            y = y - 1

    def s(self, x, y):
        t = self.a[x]
        self.a[x] = self.a[y]
        self.a[y] = t
        
    def o(self, x, y, val):
        if x > y:
            return self.o(y, x, val)
        t = x
        while t <= y:
            self.a[t] = self.a[t] ^ val
            t += 1

mem[7] = 200000
mem[8] = A(200000)

for i in tqdm(range(mem[7] * 5)):
    mem[10] = w() % 3
    mem[11] = w() % mem[7]
    mem[12] = w() % mem[7]

    if mem[10] == 0:
        mem[8].r(mem[11], mem[12])
    elif mem[10] == 1:
        mem[8].s(mem[11], mem[12])
    elif mem[10] == 2:
        mem[8].o(mem[11], mem[12], w())
    else:
        print("???")

mem[14] = 0
for i in tqdm(range(mem[7])):
    mem[14] += mem[8].a[i] * (i + 1)

print("hitcon{" + str(mem[14]) + "}")
