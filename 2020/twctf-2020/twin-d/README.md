We are given a RSA public key (e, N), with `e*d = 1 mod phi(N)`,
and a number E, s.t. `E*(d+2) = 1 mod phi(N)`. The flag is encrypted with `(e, N)`.

Knowing `e, e2, N` is enough to recover `d` in neglible time:

Let `r = 2*E*e - e + E`. Obviously `r` is not zero over integers, but in the ring mod `phi(N)`:
`r = 2*E*e - e + E = 2/(d^2+2d) - 2/(d^2 + 2d) = 0`. Therefore `r` is a multiple of `phi(N)`.
Now we can invert `e` mod `r` and use it to decrypt the flag: `flag = enc^r mod N`.
