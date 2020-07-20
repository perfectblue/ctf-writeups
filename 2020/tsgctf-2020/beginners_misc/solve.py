#!/usr/bin/python3.8

import math
import base64
from pwn import *

def get_power(x):
    if x == 0:
        return ["0o1+"]
    elif x % 2 == 1:
        return ["0512", "e00/"] + (["0o4/"] * (x//2 + 5)) + ["0o1+"]
    else:
        return (["0o4/"] * (x//2 + 2)) + ["0o1+"]

def get_frac(x):
    orig = x
    ans = []
    for i in range(60):
        while x > 1/2**i:
            ans += get_power(i)
            x -= 1/2**i
    ans += ["0o00"]
    ans = ''.join(ans)
    assert eval(ans) == orig
    return ans

ans = (get_frac(math.pi))
print(ans)
print()
print()
print()
print()
sice = base64.b64decode(ans)
print(sice.decode('utf-8'))

proc = remote("35.221.81.216", 30718)
proc.sendline(sice)
proc.interactive()

# TSGCTF{Y0u_t00k_the_first_step_0f_the_misc_w0rld!_G0_and_s0lve_all_the_remaining_challenges}
