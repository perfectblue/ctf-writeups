#-*- coding:utf-8 -*-

TemperingMaskB = 0x9d2c5680
TemperingMaskC = 0xefc60000

def untemper(y):
    y = undoTemperShiftL(y)
    y = undoTemperShiftT(y)
    y = undoTemperShiftS(y)
    y = undoTemperShiftU(y)
    return y

def undoTemperShiftL(y):
    last14 = y >> 18
    final = y ^ last14
    return final

def undoTemperShiftT(y):
    first17 = y << 15
    final = y ^ (first17 & TemperingMaskC)
    return final

def undoTemperShiftS(y):
    a = y << 7
    b = y ^ (a & TemperingMaskB)
    c = b << 7
    d = y ^ (c & TemperingMaskB)
    e = d << 7
    f = y ^ (e & TemperingMaskB)
    g = f << 7
    h = y ^ (g & TemperingMaskB)
    i = h << 7
    final = y ^ (i & TemperingMaskB)
    return final

def undoTemperShiftU(y):
    a = y >> 11
    b = y ^ a
    c = b >> 11
    final = y ^ c
    return final
