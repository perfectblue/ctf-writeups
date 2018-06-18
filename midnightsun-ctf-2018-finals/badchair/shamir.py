import random

from point import Point

class Shamir:

    def __init__(self, shares, threshold):
        self.shares = shares
        self.rng = random.SystemRandom()
        self.base_poly = [self.rng.randint(0, 256) for _ in range(threshold - 1)]
        
    def split(self, secret):
        coeffs = [secret] + self.base_poly
        coords = []
        result = []
        while len(coords) < self.shares:
            drawn = self.rng.randint(1, 255)
            if not drawn in coords:
                coords += [drawn]
        for coord in coords:
            B = Point(1)
            S = Point(0)
            X = Point(coord)
            for coeff in coeffs:
                S += (B * Point(coeff))
                B *= X
            result.append(S.value)
        return coords, result
