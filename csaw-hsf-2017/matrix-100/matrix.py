# uncompyle6 version 2.11.5
# Python bytecode 2.7 (62211)
# Decompiled from: Python 2.7.12 (default, Nov 19 2016, 06:48:10) 
# [GCC 5.4.0 20160609]
# Embedded file name: /Users/tnek/HSF-2017-Prelims/Tier 1/Reversing/Saipychallenge/matrix.py
# Compiled at: 2017-09-20 19:39:36
import itertools
import operator

def get_primes(n):
    numbers = set(range(n, 1, -1))
    primes = []
    while numbers:
        p = numbers.pop()
        primes.append(p)
        numbers.difference_update(set(range(p * 2, n + 1, p)))

    return primes


def get_flag():
    return input('Please give me the password:  ')


def matrixify(string):
    string = [ ''.join(x) for x in itertools.permutations(string, len(string)) ][len(string) // 2]
    primes = get_primes(len(string) * 9)
    ordify = lambda x: (ord(x), primes[ord(x) % len(primes)])
    row = zip(*[ x for x in map(ordify, [ i for i in string ]) ])
    matrix = list(row) * len(string)
    return matrix


def super_cool_matrix_operations(matrix):
    matrix.reverse()
    transpose = zip(*matrix)
    compressed = set(matrix)
    special_sum = lambda x: operator.mul(*map(sum, x))
    x = special_sum(compressed)
    print x
    return x


def NOOOOOO():
    print 'N00000000000000000'
    print 'HAHAHAHAHA'


def YEEEEEEEE():
    print 'YEEE DIGGITY YOU GOT THE PASSWORD!!!'
    print 'ENTER THE PASSWORD IN FLAG FORMAT!!!!!'
    print 'EX: flag{PASSWORD}'


def main():
    flag = get_flag()
    print matrixify(flag)
    matrix = matrixify(flag)
    if super_cool_matrix_operations(matrix) == 149760:
        return YEEEEEEEE()
    else:
        return NOOOOOO()


if __name__ == '__main__':
    main()
# okay decompiling matrix.pyc
