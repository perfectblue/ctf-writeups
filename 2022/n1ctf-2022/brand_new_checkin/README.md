# Brand_new_checkin

As `m` is in `[0..255]`, we can guess `m` then check `(c1 // m)^t == (c2 // m)^s` holds.
If we get correct `m`, we can get `r' = r % n` using the extended gcd method on `s` and `t`.
From this, we can get possible candidates of `r`: mostly in `r'`, `r' + n` or `r' + 2 * n`.

To recover `a`, we need to recover four `r` values. After guessing `r`, we can get `a` candidate,
and then check whether it's correct or not with `pow(2, (1 - a) * t + a * s, n) == 1`.

The flag is `n1ctf{5255840f-9140-4479-950f-a3c03fe7f4cd}`.