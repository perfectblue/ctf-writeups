# leopard

This is a sponge-like AEAD construction. The state consists of 4 non-linear
feedback registers of lengths 8, 9, 9, 10 each containing elements of GF(8).
Input is processed in 64-bit blocks, with 16 bits getting added to the ends
of each register. After each block the registers are clocked 4 times (invertibly).

We are given the output of two encryptions of the same (`key`, `iv`, `ad`, `pt`) tuple:
once normally, and once with a one-element fault when processing 3rd block of the
plaintext. The `ad` is irrelevant, we can treat it as part of key initialization.

# Hand-wavy estimate of how weak is this cipher

Observe that due to how the feedback registers work, we know 20 bytes out of 36 bytes
of the state at any given time. They are leaked directly by 3 last blocks.

Now look at how the fault propagates:

```
            ****:              ****:              ****:                ****
ff00000000000000:000000000000000000:000000000000000000:00000000000000000000
00000000000000c4:000000000000000000:000000000000000000:00000000000000000000
000000000000c400:000000000000000000:000000000000000000:00000000000000000051
0000000000c4006a:000000000000000000:000000000000000000:00000000000000005100
            ****:              ****:              ****:                ****
00000000c4006a00:000000000000000000:000000000000000000:00000000000000510081
000000c4006a00bc:000000000000000000:000000000000000084:00000000000051008100
0000c4006a00bc95:00000000000000003d:00000000000000841d:00000000005100810002
00c4006a00bc952a:000000000000003d99:000000000000841de9:0000000051008100022d
            ****:              ****:              ****:                ****
c4006a00bc952a12:0000000000003d9937:0000000000841de94b:00000051008100022de5
006a00bc952a12fe:00000000003d993768:00000000841de94bce:000051008100022de59d
6a00bc952a12fe28:000000003d993768c6:000000841de94bce36:0051008100022de59d18
00bc952a12fe28e2:0000003d993768c638:0000841de94bce36bb:51008100022de59d1855
            ****:              ****:              ****:                ****
bc952a12fe28e250:00003d993768c638ff:00841de94bce36bbff:008100022de59d18557f
952a12fe28e25098:003d993768c638ffb9:841de94bce36bbffc6:8100022de59d18557fa5
2a12fe28e25098fb:3d993768c638ffb957:1de94bce36bbffc69d:00022de59d18557fa54d
12fe28e25098fb01:993768c638ffb9571a:e94bce36bbffc69dd7:022de59d18557fa54d78
```

It takes 4 whole blocks for the difference to propagate everywhere, and even then
most of differences have been though only few non-linear layers. This suggests that
an algebraic attack is viable.

# The actual attack

Now that we know that the cipher kinda-sorta very weak, let's throw it at a SAT
solver and see if it sticks. And it does! Boolector 3.2.2 with Lingeling as the SAT engine
recovers the entire state in just 40 seconds. See `./z.py` for the proof of concept.

All that is left is to run `process_ad()` and `init_state()` backwards and get the key+iv.
The final solution is `./sploit.py`.
