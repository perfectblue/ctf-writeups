#!/usr/bin/env python
lines = open('list.txt').readlines()
with open('out.sh','w') as out:
    for i,l in enumerate(lines):
        parts = l.rstrip().split(' ')
        if parts[0].endswith('.script'):
            parts = parts[::-1]
        parts.append(i)
	print parts
        out.write("echo './HSF/%s ./HSF/%s >out/%d.txt'\n"%tuple(parts))
        out.write("./HSF/%s ./HSF/%s >out/%d.txt\n"%tuple(parts))
        out.write("echo\n")
        out.write("echo\n")

