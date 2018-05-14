Let's apply some critical thinking skills for a moment.
We need to match the programs with their correct respective inputs. We notice that in the zip the date modified for the files are in generation order; i.e. the challenge writer generated each program, then its respective input file. So we use date modified to pair up the files and we don't need to reverse them at all. Then we just do a quick bytewise diff on the program results to extract the flag.

Note: the outputted files are in out.zip, it's zipped because they're very compressible (warning: uncompressed size is 500MB)

```
$ ls -1t | xargs -L2 echo > list.txt
$ less list.txt
$ tail -n 10 list.txt
banana64.script monkeyDo4366303
banana49.script monkeyDo6941106
banana36.script monkeyDo2422799
monkeyDo9593780 banana25.script
monkeyDo3762441 banana16.script
banana9.script monkeyDo782443
banana4.script monkeyDo1554450
banana1.script monkeyDo8776659
monkeyDo2063837 banana0.script
runThis withThis.script
```

Some of the pairs are out of order so we just make a bootstrap script to properly run the files.

<fix.py>
```python
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
```

When we do a diff on the files we see that each file gives us one character and position of the flag. So we write a quick script to parse it out.

<ayylmao.py>
```python
#!/usr/bin/env python
results = open('search.txt','r').readlines()
flag = [''] * 256
for l in results:
    l = l.rstrip().split(':')[1:][0].split(' is in place ')
    l[1] =int(l[1].strip(' of the flag'))
    flag[l[1]]=l[0]
flag = ''.join(flag)
print flag
```

`flag{N0w_y0u_d0nt_s33_m3_4sking_YOU_why_I_cr34t3d_b4n4n4Scr1pt_Only_th3_truly_3nl1ght3n3d_c4n_und3rst4nd_th3_p0wer_w1th1n_b4n4n4Scr1pt}`

Sure bud.
