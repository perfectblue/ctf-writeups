from log import logTable, expTable

class Point(object):
    def __init__(self, value):
        if type(value) == Point:
            self.value = value.value
        else:
            self.value = value % 256
    
    def __add__(self, point):
        return Point(self.value ^ point.value)
    
    def __neg__(self):
        return Point(self)

    def __sub__(self, point):
        return self + point

    def __mul__(self, point):
        if point.value == 0 or self.value == 0: 
            return Point(0)
        return Point(expTable[(logTable[self.value] + logTable[point.value]) % 255])
    
    def __div__(self, point):
        if point.value == 0: 
            raise ArithmeticError('Division by zero')
        return Point(expTable[(255 + logTable[self.value] - logTable[point.value]) % 255])

    def __eq__(self, point):
        return self.value == point.value

    def __ne__(self, point):
        return not self == point

    def __str__(self):
        return '%02x' % (self.value,)

    def __repr__(self):
        return chr(self.value)
