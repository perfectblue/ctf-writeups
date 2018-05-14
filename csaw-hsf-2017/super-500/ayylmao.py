#!/usr/bin/env python
results = open('search.txt','r').readlines()
flag = [''] * 256
for l in results:
    l = l.rstrip().split(':')[1:][0].split(' is in place ')
    l[1] =int(l[1].strip(' of the flag'))
    flag[l[1]]=l[0]
flag = ''.join(flag)
print flag