# Choreography

Not an intended solution.
Each round is doing xor with `sbox[b ^ k[(2*i) & 3]]` and `sbox[d ^ k[(2*i+1) & 3]]`.
If we put `b = k[(2*i) & 3] ^ k[(2*i+1) & 3]`, the sbox results will be identical, and it'll affect the encryption result, too.

So, here's the oracle and the solution used by the solver:
1. Put `[a, 0, 0, b]` on encrypt1, `[0, 0, a, b]` on encrypt2.
2. If the result `r` satisfies `r[0] == r[2] ^ a` and `r[1] == r[3] ^ b`, `(a, b)` is a candidate for `(k[0] ^ k[1], k[2] ^ k[3])`.
3. Brute-force `256**2` values quickly and find the key.

As there are total `256**2` possible `(k[0] ^ k[1], k[2] ^ k[3])` pairs and we can only try 1000 inputs, the success rate is about 1.5%.

The flag is `PCTF{square_dancin'_the_night_away~}`.