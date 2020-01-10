WhiteHat 2020 Quals: Programming 03
===============================

In this challenge, we are give two random boolean expressions, and are asked to evaluate if they are equivalent:

```
Given two expressions, are they equal? Enter either [YES/NO]
E1: ~(A+A)
E2: (~A)
>
```

They start off simple, but we can assume that it will get much more complex towards the end, so we have to write a solver for this.
SAT Solvers can easily do this for us. We need to parse the equations into the format for the SAT solver and then check if they are equivalent or not.

If you are stupid like me and do not know that there exist libraries that can do this for you, you can waste time writing a stack based parse for the infix operations, and lose first blood.
See `parse_expr` in `solve.py` for how it is done. Once we have the expression parsing implemented, we can give it to a SAT solver and ask it to check if they are different or not.

```py
while True:
    e1 = proc.recvline().strip().split(": ")[1]
    e2 = proc.recvline().strip().split(": ")[1]
    print e1
    print e2

    z1 = parse_expr(e1)
    z2 = parse_expr(e2)
    print z1
    print z2
    s = Solver()
    s.add(z1 != z2)
    if s.check() == unsat:
        print "YES"
        proc.sendline("YES")
    else:
        print "NO"
        proc.sendline("NO")
    print proc.recvline()
```

We tell the SAT solver that the two expressions are not equivalent to each other and make it find a example that fits the case, if it cannot do so, we know that the 
there is no assignment of variables that will make it different, so they are indeed equivalent.

We can run this and get the flag.

```
> Very well, you've done it the right way! Your flag is: WhiteHat{BO0l3_1s_s1MpL3_f0R_Pr0gR4mM3R}
```
