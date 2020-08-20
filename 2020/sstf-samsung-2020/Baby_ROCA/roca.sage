import time

def coppersmith_howgrave_univariate(pol, modulus, beta, mm, tt, XX):
    """
    Coppersmith revisited by Howgrave-Graham
    
    finds a solution if:
    * b|modulus, b >= modulus^beta , 0 < beta <= 1
    * |x| < XX
    """
    #
    # init
    #
    dd = pol.degree()
    nn = dd * mm + tt

    #
    # checks
    #
    if not 0 < beta <= 1:
        raise ValueError("beta should belongs in (0, 1]")

    if not pol.is_monic():
        raise ArithmeticError("Polynomial must be monic.")

    #
    # calculate bounds and display them
    #
    """
    * we want to find g(x) such that ||g(xX)|| <= b^m / sqrt(n)

    * we know LLL will give us a short vector v such that:
    ||v|| <= 2^((n - 1)/4) * det(L)^(1/n)

    * we will use that vector as a coefficient vector for our g(x)
    
    * so we want to satisfy:
    2^((n - 1)/4) * det(L)^(1/n) < N^(beta*m) / sqrt(n)
    
    so we can obtain ||v|| < N^(beta*m) / sqrt(n) <= b^m / sqrt(n)
    (it's important to use N because we might not know b)
    """
   
    #
    # Coppersmith revisited algo for univariate
    #

    # change ring of pol and x
    polZ = pol.change_ring(ZZ)
    x = polZ.parent().gen()

    # compute polynomials
    gg = []
    for ii in range(mm):
        for jj in range(dd):
            gg.append((x * XX)**jj * modulus**(mm - ii) * polZ(x * XX)**ii)
    for ii in range(tt):
        gg.append((x * XX)**ii * polZ(x * XX)**mm)
    
    # construct lattice B
    BB = Matrix(ZZ, nn)

    for ii in range(nn):
        for jj in range(ii+1):
            BB[ii, jj] = gg[ii][jj]

    # LLL
    BB = BB.LLL()

    # transform shortest vector in polynomial    
    new_pol = 0
    for ii in range(nn):
        new_pol += x**ii * BB[0, ii] / XX**ii

    # factor polynomial
    potential_roots = new_pol.roots()
    #print "potential roots:", potential_roots

    # test roots
    roots = []
    for root in potential_roots:
        if root[0].is_integer():
            roots.append(ZZ(root[0]))

    # 
    return roots

N = 1172182071079403612819460591410436801254598455663212814122676976455521772943555586683995840410187689112480076452984704299817334381387842689748983063082229411869124571739688203711476164271691372368112347398301683214529319606705993490175490698699529245499839

M = 136798100663240822199584482903026244896116416344106704058806838213895795474149605111042853590
M_ = 51693683179068137641702024930559289580874279697128737964619897244540414690590

m = 5
t = 6

c = discrete_log(Mod(N, M), Mod(65537, M))
c_ = discrete_log(Mod(N, M_), Mod(65537, M_))

o = Mod(65537, M).multiplicative_order()
o_ = Mod(65537, M_).multiplicative_order()

print(Integer(c_/2), Integer(floor((c_+o_)/2 + 1)))
print()

for a in range((c_+o_)//2 + 1, c_//2 - 1, -1):
    if a % 100 == 0:
        print(a)
    P.<x> = PolynomialRing(Zmod(N))
    f = x + inverse_mod(M_,N) * Integer(pow(65537,a,M_))
    B = 0.5
    X = ceil(2*N^B/M_)
    k = coppersmith_howgrave_univariate(f, N, B, m, t, X)
    if len(k) > 0:
        print(k)
        p = k[0]*M_+ Integer(pow(65537,a,M_))
        if N%p == 0:
            print(p, N/p)
            exit()

