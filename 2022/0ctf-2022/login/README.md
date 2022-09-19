# login

The remote service does some math similar to Ring-LWE encryption, but not quite.

Let's write out all the equations in `Player_Login(x)` and see that they simplify
to `pt = M*x*y + y*garbage`, where `x` is the input to login, `y` is the registered
password, and `garbage` is some polynomial with coefficients small enough that
`y*garbage` rounds to zero after division by `M`.

In other words, the login procedure is just this, no post-quantum cryptography involved:

```python
def login(x): # x and y are -1/+1 polynomials here
    Zx.<x> = Z[]
    R = Zx.quotient(1 + x**2048)
    result = (R(y) * R(x))
    if result[0] == 2048:
        return 'success'
    else:
        return "fail, but here's a leak: ", result
```

The way to achieve `result[0] == 2048` is:

```python
def auth_for_passwd(y): # x and y are lists of bits here
    # multiplication mod `x^n+1` is basically a just cyclic convolution
    y = [0]*N
    for i in range(N):
        x[(n-i)%n] = y[i]
    for i in range(1, N):
        x[i] ^= 1 # flip signs due to RLWE modulus being `x^n+1` and not `x^n-1`
    return y
```

# Stealing Player's password (method 1)

We can easily steal the password by evaluating `login([1]*2048)`.
The login will fail (with overwhelming odds), and will give us back a length-2048 array `p`
of what's effectively the prefix sums of `x`. We can then go over it and compare each `p[i-1]` with
`p[i]` to determine one bit of `x`. See function `recov(leak)` in `sploit.py`.

This logs us in as the player.

# Stealing Admins's password (method 2)

The above thick won't work anymore, now we have `login(x)` with random `x` that we don't control.
However, it's easy to generalize to arbitrary `x`. The polynomial `x**n + 1` is irreducible over the
rationals, and so the equation `leak = y * x mod x**2048+1` will have a unique solution even over
the rational field. We can solve as a standard, floating-point linear system and be confident that
we get a solution with coefficients +1/-1. See function `attack2(leak)` in `./tt.py`.

There's a small wrinkle left: we don't know the values of `Q` and `M`, which are used to
convert `M*x*y + y*garbage` to just `x*y`. This is not a big deal: we build a histogram of coefficients of
`M*x*y + y*garbage` and look for clusters spaced approximately `10**14` apart. Each cluster is a discreete
"level" of `x*y`. We fit a linear function over their centers, and use it to decode `x*y` without knowing `Q`
precisely. See function `decode(vals)` in `./tt.py`.

# Recap

To login as admin we:
1. fail to login as player, steal password with method 1 (method 2 also works), `FAILED = 1`
2. login as player, `FAILED = 1`
3. fail to login as admin, steal password with method 2, `FAILED = 2`
4. get offered to reset our password, reset it to `auth_for_passwd(admin_passwd)`
5. enjoy flag
