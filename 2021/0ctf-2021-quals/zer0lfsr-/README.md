# zer0lfsr-

Solved by recovering key from Generator1 and Generator3.

## Generator 1

Brute-force 16-bit LFSR. Then you can recover some streams from NFSR, and then it's possible to recover other states from the values. See `lfsr1.c` for details.

## Generator 3

It's simple 64-bit LFSR. Solve by matrix inversion in GF(2).