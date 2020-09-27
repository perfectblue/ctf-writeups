Each character of the flag was separately encrypted with ElGamal in a prime field.
However, the order of the multiplicative subgroup has small cofactor of 570.
So by using brute force to solve DLP, we can recover the part of plaintext in the subgroup of size 570.
Since each ASCII character was encrypted separately this is quite enough to recover the flag.
