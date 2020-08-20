Decrypt Vulnerable Data #1
==========================

In this challenge we are given 2 LFSRs, and a flag encrypted with the combined output of these LFSRs.
Howerver, we know the first 100 bits of the plaintext, so we can get the first 100 bits of the keystream.
Using this information, we can reverse the LFSR, and find the starting state which is the key.

We write a simple Z3 script to do this and get the flag.
