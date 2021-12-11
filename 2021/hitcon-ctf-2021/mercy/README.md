# mercy

1. Port PPP's clemency processor plugin to make it work on IDA 7.x
    - https://github.com/pwning/defcon25-public
2. Analyze the high-level procedure of the binary; encrypt() and memcmp(encrypted, harcoded_ciphertext)
3. Find that encrypt() has 2 steps: KSA + PRNG, and it was a 1:1 stream cipher. KSA is similar to RC4's one but 512 instead of 256
4. The PRNG part was a little bit different; analyze and replicate them in python; it's not a simple XOR, so I used Z3Py instead in order to get the plaintext. (See solve.py)
5. Flag: hitcon{6d0fe79f2179175dda}