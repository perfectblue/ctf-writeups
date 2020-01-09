# badchair

**Category**: Reverse

161 Points

11 Solves

**Problem description**:
```
Try sitting on it and see if it breaks 
```
---

This was a crypto problem involving [Shamir's Secret Sharing Scheme (SSS)][1] problem over the finite field GF(256). The way SSS works is that your secret is the constant term of a polynomial, and the shares are points on the polynomial. Since `k` points are necessary to define a polynomial of degree `k-1`, you can split up the secret in this manner while revealing no information about the secret unless you have enough (`>= k`) points. In our problem we're given only 4 shares (points) when the threshold is 5 (degree 4 polynomial). So somehow we would need to deduce the polynomial.

What's interesting is the secret splitting implementation:
```python
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
```

The key observation here is that secret is split up byte-for-byte, and the non-constant terms of the secret polynomial is the same for every byte. That means that for two bytes in the secret with the same value but different position, the corresponding secret polynomial would be the same. If we knew the positions of two identical bytes in the secret, we could combine the 4 (insufficient) shares of each byte into 8 (sufficient) shares of the secret. Moreover, we can even calculate the full polynomial which would allow us to use only 4 shares to deduce all the other bytes of the secret too.

Luckily, we know the flag format is `midnight{..}` and we have two `i`s at positions 1 and 4. So using that, we can figure out the polynomial used was `f<SECRET>(x) = SECRET + db*x^1 + 6f*x^2 + ad*x^3 + 1f*x^4`. Then, for the other bytes of the secret, we can simply try all field elements 0-255 as the secret constant term in the polynomial `f(x)`, and check whether `f(x_i)` matches `y_i` for each of the 4 known share points. If they all match, that means we probably guessed our constant term correctly.

`midnight{ehhh_n0t_3ven_cl0se}`

Note: I believe the algebra can all be done in sage, but I was in a hurry just to solve the problem so I just reinvented the wheel.

[1]:https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing
