# Small Hashes Anyway

## Background

We are given a binary which uses the Xilinx microblaze architecture to reverse.

## Analysis

We used the binary ninja plugin https://github.com/amtal/microblaze to reverse the binary. (Unfortunately, this module does not work with the subsequent challenges: Ominous Edute and Blazin' Etudes).

The binary calculates `crc32(flag[:i])` and compare the result with a fixed value in the binary. This flag check routine works character by character. To solve this, we can brute force each character within range [0, 255] to see which character is correct.

## Solution

The full solver is in `solver.py`. Run with `python solver.py`. The flag is `flag{whiskey358896oscar3:GDtWITSqyj4LFka9AN7F3DkF_OMe_X7MMoSBri8a_CKVSAHSyNykaknqJ7k3BcnV7YB26fBKyEfZzXOigh5PALU}`.
