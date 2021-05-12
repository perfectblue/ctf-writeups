F.<x> = GF(2)[]
G = GF(2^128, name='a', modulus=x^128+x^7+x^2+x+1)
R.<t>=PolynomialRing(F)

while True:
    tag = G.fetch_int(int(input("tag = "), 16))
    partial = G.fetch_int(int(input("partial enc iv = "), 16) << 4)
    ans = []

    for i in range(16):
        X = G.fetch_int(i) + partial
        f = X * t^256 + tag * t + tag + X

        if len(f.roots()) > 1:
            ans.append(i)
    print(ans)
