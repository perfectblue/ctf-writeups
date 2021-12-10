# magic rsa

As the given prefix is small (136 bits), it's easily factorizable. I tried to generate a value `prefix * 2**8 + x` that:
- The biggest prime should be small
- It does not have many `2`s in the phi value (to avoid CRT failing)

After generating the value, it's possible to calculate the dlog of the given values by using CRT and general dlog methods. The flag is `hitcon{Did_you@solve!this_with_smoooothness?}`.