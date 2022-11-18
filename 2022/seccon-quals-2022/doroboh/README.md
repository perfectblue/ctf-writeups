TL;DR

The binary does a key exchange and seeds RC4 from it.

We look at all 256-byte substrings of araiguma.DMP and:

    1. check that each byte value is present exactly once (i.e. it is a valid RC4 sbox)
    2. guess the values of "i" and "j"
    3. compute the RC4 keystream both before and after the state we found in memory
    4. see if it decrypts anything
