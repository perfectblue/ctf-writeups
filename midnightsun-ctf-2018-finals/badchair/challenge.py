import os
import json 
import base64

# from flag import FLAG
from point import Point
from shamir import Shamir

class KeySplitter:
    
    def __init__(self, numshares, threshold):
        self.splitter = Shamir(numshares, threshold)
        self.numshares = numshares
        self.threshold = threshold

    def split(self, key):
        xshares = [''] * self.numshares
        yshares = [''] * self.numshares
        for char in key:
            xcords, ycords = self.splitter.split(ord(char))
            for idx in range(self.numshares):
                xshares[idx] += chr(xcords[idx])
                yshares[idx] += chr(ycords[idx])
        return zip(xshares, yshares)
    
    def jsonify(self, shares, threshold, split):
        data = {
            'shares': shares, 
            'threshold': threshold, 
            'split': [
                base64.b64encode(split[0]),
                base64.b64encode(split[1])
            ]
        }
        return json.dumps(data)

def lagrange_interpolate_l0(x, x_s, y_s):
    k = len(x_s)
    l0 = Point(0)
    for j in range(0, k):
        prod = Point(1)
        for m in range(0, k):
            if m == j:
                continue
            prod = prod * x_s[m] / (x_s[m] + x_s[j])
        l0 = l0 + y_s[j] * prod
    return l0

# we have to be very careful to treat our ring members like they are immutable
class Poly(object):
    def __init__(self, coeff,zero,one):
        self.coeff = coeff
        self.zero = zero # additive identity
        self.one = one # multiplicative identity

    def _zeros(self, deg):
        res = [0]*(deg)
        for i in range(0,deg):
            res[i] = self.zero
        return res

    def __mul__(self, other):
        if type(other) == Poly:
            res = self._zeros(len(self.coeff)+len(other.coeff)-1)
            for o1,i1 in enumerate(self.coeff):
                for o2,i2 in enumerate(other.coeff):
                    res[o1+o2] = res[o1+o2] + i1*i2
            return Poly(res,self.zero,self.one)
        else:
            res = self.coeff[:]
            for i,a in enumerate(res): 
                res[i] = a*other
            return Poly(res,self.zero,self.one)

    def __add__(self, other):
        res = self._zeros(max(len(self.coeff), len(other.coeff)))
        for o1,i1 in enumerate(self.coeff):
            res[o1] = res[o1] + i1
        for o1,i1 in enumerate(other.coeff):
            res[o1] = res[o1] + i1
        return Poly(res,self.zero,self.one)

    def __div__(self, scalar):
        res = self.coeff[:]
        for i,a in enumerate(res): 
            res[i] = a/scalar
        return Poly(res,self.zero,self.one)

    def __call__(self, scalar):
        res = self.zero
        xi = self.one
        for i,a in enumerate(self.coeff):
            res = res + a * xi 
            xi = xi * scalar
        return res

    def __str__(self):
        result = []
        for i,a in enumerate(self.coeff):
            result.append('%sx^%s' % (a,i))
        return ' + '.join(result)


def lagrange_interpolate_poly(x_s, y_s, deg, zero,one):
    assert(len(x_s) == len(y_s))
    l_s = [zero] * (deg+1)
    for j in range(0, deg+1):
        num = Poly([one],zero,one)
        den = one
        for i in range(0, len(x_s)):
            if i == j:
                continue
            num = num * Poly([-x_s[i], one],zero,one)
            den = den * (x_s[j] - x_s[i])
        l_s[j] = num / den
    f = Poly([],zero,one)
    for j in range(0, deg+1):
        f = f + l_s[j] * y_s[j]
    return f


def extract_coords(xs,ys,i):
    xs_i = map(lambda fuck: Point(ord(fuck[i])), xs)
    ys_i = map(lambda fuck: Point(ord(fuck[i])), ys)
    return xs_i, ys_i

def decode(xs, ys):
    l = len(xs[0])
    result = ''
    for i in range(0, l):
        xs_i,ys_i = extract_coords(xs,ys,i)
        result += chr(lagrange_interpolate_l0(0, xs_i, ys_i).value)
    return result

def decode_brute(poly, xs, ys):
    l = len(xs[0])
    result = ''
    for i in range(0, l):
        xs_i,ys_i = extract_coords(xs,ys,i)
        result += chr(brute_base(poly, xs_i, ys_i).value)
    return result


def brute_base(poly, xs, ys):
    cands = []
    for x0 in range(32, 128):
        coeffs = poly.coeff[:]
        coeffs[0] = Point(x0)
        ok = True
        for x,y in zip(xs,ys):
            yx = Poly(coeffs, poly.zero,poly.one)(x)
            if not (yx == y):
                ok = False
                break
        if ok:
            cands.append(coeffs[0])
    assert(len(cands) == 1)
    return cands[0]

# print lagrange_interpolate_poly([2.,4.,5.],[1942.,3402.,4414.], 2,0.0,1.)

if __name__ == "__main__":
    shares = map(json.loads, open('shares.txt','r').readlines())
    splits = []
    for share in shares:
        splits.append(map(base64.b64decode, share['split']))
    xs,ys= zip(*splits)
    # now here is the trick. since they are both split-up `i`s we can combine the shares to deduce the poly.
    # midnight{
    # 01234567
    #  ^  ^
    xs_1,ys_1 = extract_coords(xs,ys,1)
    xs_4,ys_4 = extract_coords(xs,ys,4)
    xs_full = xs_1[0:3] + xs_4[0:3]
    ys_full = ys_1[0:3] + ys_4[0:3]
    # print interpolate(0, xs_full, ys_full)
    P = lagrange_interpolate_poly(xs_full, ys_full, 5, Point(0), Point(1))
    print P
    # print P(Point(xs_full[0])),ys_full[0]
    print decode_brute(P, xs, ys)


# if __name__ == "__main__":
#     splitter = KeySplitter(9, 5)
#     splits = splitter.split('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
#     xs,ys= zip(*splits)
#     xs_0,ys_0 = extract_coords(xs,ys,0)
#     xs_5,ys_5 = extract_coords(xs,ys,5)
#     print str(interpolate(0, xs_0[0:3] + xs_5[0:3],ys_0[0:3] + ys_5[0:3]))
    # for i in range(0, 4):
        # print splitter.jsonify(9, 5, splits[i])


