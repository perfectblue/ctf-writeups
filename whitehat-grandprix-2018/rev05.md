rev05 writeup
===============

```
material.grandprix.whitehatvn.com/re05

This program is a keygen of a vendor. Many company (bkav,vtv,vtc,voz,vna,fpt,fis.....) used software with license provided from it. Our boss want to find some secrect license! Do it.
```

Reversing the `ctfq.exe` binary, we notice the main function first calls `sub_401090`.

```c
<insert_code_here sub_401090>
```

This looks to be connecting to `66.42.55.226:8888` and sends `111|test|test|test` and waits
for the response of "Ok fine". If we play around with this socket, we notice that there seem to be
specific correct IDs like `111`.

```
66.42.55.226.vultr.com [66.42.55.226] 8888 (?) open
111|test|test|test
Ok fine
1|||
wrong id
 id looklike 000-999
500|||
wrong id
 id looklike 000-999
```

We write a brute force script that runs through all the IDs in the range mentioned to see if we
can find something interesting.

```py
from pwn import *

context.log_level = 'error'

for i in range(1000):
    proc = remote('66.42.55.226', 8888)
    curr = str(i).zfill(3)
    proc.sendline(curr + '|||')
    resp = proc.recvline()
    print '{} - {}'.format(curr, repr(resp))
    proc.close()
```

Running this, we find besides `111` one other valid ID in `720`.

```
716 - 'wrong id\n'
717 - 'wrong id\n'
718 - 'wrong id\n'
719 - 'wrong id\n'
720 - 'wrong view command\n'
721 - 'wrong id\n'
722 - 'wrong id\n'
723 - 'wrong id\n'
```

If we use the `view` command with 720, we see it's giving an error for "wrong company".

```
720|view||
wrong company
```

If we remember the problem statement, we had a list of companies in it. We try all those companies
to see if something works.

```
720|view|bkav|
wrong company
720|view|vtv|
wrong company
720|view|vtc|
wrong company
720|view|voz|
wrong company
720|view|vna|
wrong company
720|view|fpt|
wrong company
720|view|fis|
vqmuwzjxfmqmdnfhr
```

So, if we send the company name `fis`, we get back a code. If we reverse through the rest of the
program, we will find a serial key generation routine in `sub_401310`.

```c
<insert_code_here sub_401310>
```

It takes in the parameters `company name` and `serial key` and uses a custom algorithm to generate
a code, which seems to be what we get from the remote socket. If we reverse this keygen algo and run
it with company name and the code output, we get `phuongdonghuyenbi`, which we take the SHA1 of and
submit as flag.

```py
import string

enc_key = "vqmuwzjxfmqmdnfhr"
companyname = "fis"
v2 = len(enc_key)
v3 = len(companyname)
v0 = 0
v1 = 0
v8 = [0 for i in range(256)]
while True:
    if v0 == v3:
        v0 = 0
    v4 = companyname[v0]
    v0 += 1
    v8[v1] = v4
    v1 += 1
    if v1 >= v2:
        break

secret_key = ""
v5 = 0
while True:
    v6 = enc_key[v5]
    if v6 in string.lowercase:
        #enc_key[v5] = ((unsigned __int8)v8[v5] + v6 - 192) % 27 + 96;
        fin = -1
        for x in string.lowercase:
            y = (ord(x) + ord(v8[v5]) - 192 + 27 * 10) % 27 + 96
            if chr(y) == v6:
                assert fin == -1
                fin = x
        assert fin != -1
        secret_key += fin
    v5 += 1
    if v5 >= len(enc_key):
        break

print secret_key
```

The final flag is `WhiteHat{f1354f4e0cba1cf3faa337adb1289f1647047567}`.
