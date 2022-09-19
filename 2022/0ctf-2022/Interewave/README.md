# Interweave

This solution can solve to the level 3.

The binary generates 16 random strings, of the length 0xC00.
Each `i`th binary has to print:
1. Its given 0xC00-length random string.
2. The SHA256 sum of the 1st binary to 16th binary, including *itself*.

Therefore, I made a binary with this struct:
```
[         ELF  Header         ]
[ jmp to code | random string ]
[        random string        ]
[            code             ]
```

With this structure, we can calculate a SHA256 state (which is not digested yet)
which has consumed data til the random string. With the state, we can calculate 
the SHA256 sum of the binary itself, by providing the code to SHA256.

I used this code to calculate SHA256, which is using Intel SHA extension: [sha256_ni_x1.asm](https://github.com/carl008-ma/isa-l_crypto/blob/0e4f088aace7ccca8540f54735150bf78731f0b7/sha256_mb/sha256_ni_x1.asm)
For calculating SHA256 inner states, I used this code: [pysha2](https://github.com/thomdixon/pysha2/blob/master/sha2/sha256.py)