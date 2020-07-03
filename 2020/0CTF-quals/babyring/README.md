babyring
========

Let's treat the ciphertexts as random numbers: C1, C2, ..., C64

Since RC4 is just XOR, we can extract a list of RC4 keys for each round.
So the constraint we have to satisfy is:


```
v ^ C1 ^ RC4_1 ^ C2 ^ RC4_2 ^ ... ^ C64 ^ RC4_64 == v
```

Combining all the RC4 keys together, we get

```
C1 ^ C2 ^ ... ^ C64 == RC4
```

So we have to find a set of ciphertexts that xor to a given value.

To solve this, we generate 64 random plaintexts and their ciphertexts,
do gaussian elimination on them to find the subset which xors to the given value.

If we find such a subset, for the ones that are picked we send that plaintext,
and the ones that are not picked, we send 0, since pow(0, e, N) == 0.

It may take a few tries before we find a invertible matrix.
