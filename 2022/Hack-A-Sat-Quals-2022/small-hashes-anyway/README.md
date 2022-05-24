# Small Hashes Anyway

Used https://github.com/amtal/microblaze to reverse the binary with Binary Ninja. (Unfortunately, this module does not work with the subsequent challenges: Ominous Edute and Blazin' Etudes)

The binary calculates `crc32(flag[:i])` and compare the result with a fixed value in the binary.

The full solver is in `solver.py`. The flag is `flag{whiskey358896oscar3:GDtWITSqyj4LFka9AN7F3DkF_OMe_X7MMoSBri8a_CKVSAHSyNykaknqJ7k3BcnV7YB26fBKyEfZzXOigh5PALU}`.