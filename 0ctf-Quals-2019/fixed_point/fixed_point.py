# In this write-up, we will be working in an abstract vector space
# where the underlying field is GF(2).
# For those who are not familiar with abstract algebra, this means
# that our algebra is consists of two elements:
#  - 0, the additive identity
#  - 1, the multiplicative identity
# and is equipped with two operations:
#  - Addition by scalar, ^, which is defined as bitwise xor
#  - Multiplication by scalar, &, which is defined as bitwise and
# From these two elements, we also have an abstract vector space
# which consists of vectors and matrices whose elements are elements
# of the aforementioned field.
# Our vector space comes with two operations:
# - Vector addition, ^, which is defined as pwntools xor
# - Multiplication by matrix, which is what you would expect
#
# Our brief introduction aside, this challenge implements a custom CRC,
# with parameters W=128, and d=0xb595cf9c8d708e2166d545cf7cfdd4f9
# and a custom zero value of 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.
# CRC is calculated as the remainder of polynomial division where the
# coefficients are members of a finite field. For GF(2), this can be
# easily implemented in hardware as a simple shift-and-xor sequence.
# W is the bitwidth, and d is the divisor. The dividend is the input.
#
# Please observe that CRC is an affine transformation:
# CRC(x^y) = CRC(x) ^ CRC(y) ^ CRC(0)
# where 0 denotes "\0" * len(x)
def crc128(x):
    r = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    for c in x:
        r ^= ord(c)
        for _ in range(8):
            b, r = r & 1, r >> 1
            if b:
                r ^= 0xb595cf9c8d708e2166d545cf7cfdd4f9
    return r
assert crc128('flag{') == 0x347b8dfa4b97acb7f1bb2779591da2b6
assert crc128('\x03') == crc128('\x01')^crc128('\x02')^crc128('\x00')

# CRC128 by itself is affine, but we can derive a linear transformation
# from it, CRC', if we remove the simply addition by constant CRC(0)
# CRC'(x) = CRC(x) ^ CRC(0)
# CRC'(x^y)
# = CRC(x^y) ^ CRC(0)
# = (CRC(x) ^ CRC(y) ^ CRC(0)) ^ CRC(0)
# = (CRC(x) ^ CRC(0)) ^ (CRC(y) ^ CRC(0))
# = CRC'(x) ^ CRC'(y)
def crc_linear(x):
    return crc128(x) ^ crc128('\x00' * len(x))
assert crc_linear('\x03\x01') == crc_linear('\x01\x03')^crc_linear('\x02\x02')

# Because CRC' is a linear function, we are able to characterize it
# action in terms of multiplication by matrix.
#
# Before we proceed, we will demonstrate a brief lemma about CRC', that
# after padding the input of CRC' with zeros, the transformation is still linear.
# More formally, let f(x) = CRC'(a | x | b) where | denotes string concatenation,
# and a and b both consist solely of null bytes.
# We want to show that f(x^y) = f(x)^f(y), i.e. f is linear.
# f(x) = CRC'(a | x^y | b)
# = CRC'((a | x | b) ^ (a | y | b)) , because a^a = a and b^b = b.
# = CRC'(a | x | b) ^ CRC'(a | y | b)
# = f(x) ^ f(y)
# We have shown that CRC' is still a linear function even when its input is
# padded with some zero bytes; hence, that function f(x) can also be
# represented using a matrix.
#
# Now, we recall that the goal of the challenge is to find some x, such that
# CRC("flag{" | x | "}") = x, where | denotes string concatenation.
# Observe that the parameter to CRC, "flag{" | x | "}", can be rewritten as:
# ("flag{" | \x00*len(x) | "}") ^ (\0\0\0\0\0 | x | \0)
# so, the equation becomes:
# CRC(("flag{" | \x00*len(x) | "}") ^ (\0\0\0\0\0 | x | \0)) = x
# By the affine nature of CRC, we can rewrite the left side like so:
# CRC("flag{" | \x00*len(x) | "}") ^ CRC(\0\0\0\0\0 | x | \0) ^ CRC(0) = x
# Now re-associate:
# CRC("flag{" | \x00*len(x) | "}") ^ [CRC(\0\0\0\0\0 | x | \0) ^ CRC(0)] = x
# By definition of CRC':
# CRC("flag{" | \x00*len(x) | "}") ^ CRC'(\0\0\0\0\0 | x | \0) = x
# Rearranging:
# CRC'(\0\0\0\0\0 | x | \0) ^ x = CRC("flag{" | \x00*len(x) | "}")
# The right side is constant. We will denote it as b.
# b = crc128('flag{' + '\x00'*16 + '}')
b = crc128('flag{' + '\x00'*16 + '}')
# CRC'(\0\0\0\0\0 | x | \0) ^ x = b
# Using our earlier lemma, CRC'(\0\0\0\0\0 | x | \0) has a linear action on x,
# we can represent its operation as multiplication by a matrix.
# Ax ^ x = b
# For any vector, Ix = x where I is the identity matrix.
# Ax ^ Ix = b
# Associativity of vector space.
# (A^I)x = b
#
# Notice that we have reduced our problem to a series of linear equations in our field.
# We can now solve for x easily.
#
# But, I have skipped over the actual structure of A. How do we compute A?
# Recall that multiplication by matrix corresponds to a change of basis.
# Because f(x), our padded CRC', is linear, we can break it down into the
# sum of the results of CRC'ing each individiual input bit of x.
# I know that's not very clear, so hopefully this example will help illustrate it.
#
# f(x0 x1 x2 x3 ... x127) where x0 ... x127 are the individual bits comprising x
# = x0 * f(1000...0) -- note, "1000...0" is a bitstring, not a number. I wrote it wih LSB on the left
# + x1 * f(0100...0) 
# + x2 * f(0010...0)
# + x3 * f(0001...0)
# ...
# + x127 * f(0000...1)
#
# But, this looks quite like a multiplication by matrix!
# Our new basis is { CRC(1000...0), CRC(0100...0), ... , CRC(0000...1) }
# and our cordinates are x0, x1, ... , x127.
# Therefore the columns of A will be our basis vectors and our domain will be 
# x represented as a bitvector.

from sage.all import *

# Very simple helper function that returns the bitvector representation of x.
bits = lambda x: map(int, bin(x).lstrip("0b").rjust(128, "0"))[::-1]
def num2str(x):
    result = ''
    while x:
        result += chr(x&0xff)
        x >>= 8
    return result.ljust(16, '\x00')
def bits2num(bv):
    return int(''.join(map(str, bv))[::-1],2)

b = vector(GF(2), bits(b))

f = lambda x: crc_linear('\0\0\0\0\0' + num2str(x) + '\0')
A = matrix(GF(2), 128, 128)
for i in range(128):
    A.set_column(i, bits(f(1 << i)))
assert f(1234) == bits2num(A*vector(GF(2), bits(1234)))

# We wanted (A^I), rememeber?
for i in range(128):
    A[i,i] -= 1

# Now solve :)
x = A.solve_right(b)

result = num2str(bits2num(x)).encode('hex')
assert num2str(crc128('flag{'+result.decode('hex')+'}')).encode('hex') == result
print 'flag{' + result + '}'

# References:
# https://balsn.tw/ctf_writeup/20190323-0ctf_tctf2019quals/#fixed-point
# https://gist.github.com/hellman/78dfa800b6625d9c86592429d5f46589
# https://github.com/google/google-ctf/blob/c8325c749fdbb852b620a6b23d5a03f3224e69d8/2017/quals/2017-crypto-selfhash/challenge/challenge.py
# https://ilias.giechaskiel.com/posts/google_ctf_crc/index.html
