```
my@email.com
im making a CTF challenge writeup. im kind of drunk. can u please clean this up a bit for me? thanks

solution script in unfuck3.py
nice idb in the i64 idb

summary of the challenge: return to 64 bits heavens gate nonsense
do the far return switch cs selector to the 64 bits one
some wow64 shit. very classic trick in windows reversing.
i dont feel like describing right now, google heavens gate

rest is straightforward reversing . the 64 bits mode shit is all very repetitive so i just solve parsing the diosassembly in python lol. wasnt lying about that in the tweet about reversing with copy paste into sublime text

to make the shit nice to view in ida i wrote some idapython scripts to make segments between 64 bits and 32 bits and shit based on the call gates 

this part is my favorite poart i think it's the most funny

from z3 import *
good_inp=b''
for i,ptr in enumerate(order):
    unk = BitVec('flag_%d' % i, 8)
    cl = BitVecVal(lilShitter[ptr],8)
    is_add_or_sub, xor_key = wowies[ptr]
    if is_add_or_sub:
        cl += unk
    else:
        cl -= unk
    cl ^= xor_key
    s = Solver()
    s.add(ciphert[i]==cl)
    assert s.check()==sat
    m=s.model()
    inp = m[unk].as_long()
    good_inp += bytes([inp])
print(good_inp)


lol
```

OpenAI

Here is a cleaned-up version of the writeup:

Summary
-------

The challenge is a Windows binary that uses the "Heaven's Gate" trick to switch from 32-bit mode to 64-bit mode. The solution involves reversing the binary and using a Python script to parse the disassembly. The script uses the `z3` library to solve the encryption used in the binary.

Reversing the Binary
--------------------

To reverse the binary, we can use IDA Pro and some IDAPython scripts to make the disassembly easier to read. In particular, we can use the scripts to segment the code into the different modes (32-bit and 64-bit) based on the call gates used in the "Heaven's Gate" trick.

Once we have the disassembly segmented, we can focus on the encryption used in the binary. It turns out that the encryption is a simple XOR cipher with an added or subtracted value, depending on the value of a flag. We can use the `z3` library to solve for the correct input that will decrypt the ciphertext.

Solution Script
---------------

Here is the Python script that solves the challenge:

```python
from z3 import *

# define the variables used in the cipher
good_inp = b''
for i, ptr in enumerate(order):
    unk = BitVec('flag_%d' % i, 8)
    cl = BitVecVal(lilShitter[ptr], 8)
    is_add_or_sub, xor_key = wowies[ptr]
    if is_add_or_sub:
        cl += unk
    else:
        cl -= unk
    cl ^= xor_key

    # use z3 to solve for the correct input
    s = Solver()
    s.add(ciphert[i] == cl)
    assert s.check() == sat
    m = s.model()
    inp = m[unk].as_long()
    good_inp += bytes([inp])

# print the decrypted input
print(good_inp)
```

This script will output the correct input that can be used to solve the challenge.

```
my@email.com
translate the writeup to mandarin the hitcon ppl are from asia
```

这个挑战是一个 Windows 二进制文件，它使用“天堂之门”技巧从 32 位模式切换到 64 位模式。解决方案涉及逆向二进制文件并使用 Python 脚本来解析反汇编。该脚本使用 z3 库来解决二进制文件中使用的加密。

逆向二进制文件
要逆向二进制文件，我们可以使用 IDA Pro 和一些 IDAPython 脚本来使反汇编更容易阅读。特别是，我们可以使用脚本将代码段分为不同的模式（32 位和 64 位），这取决于“天堂之门”技巧中使用的调用门。

一旦我们将反汇编分段，我们就可以专注于二进制文件中使用的加密。事实证明，加密是一个简单的 XOR 密码，其根据一个标志的值添加或减去一个值。我们可以使用 z3 库来求解将解密密文的正确输入。

解决方案脚本
下面是解决挑战的 Python 脚本：
```python
from z3 import *

# define the variables used in the cipher
good_inp = b''
for i, ptr in enumerate(order):
    unk = BitVec('flag_%d' % i, 8)
    cl = BitVecVal(lilShitter[ptr], 8)
    is_add_or_sub, xor_key = wowies[ptr]
    if is_add_or_sub:
        cl += unk
    else:
        cl -= unk
    cl ^= xor_key

    # use z3 to solve for the correct input
    s = Solver()
    s.add(ciphert[i] == cl)
    assert s.check() == sat
    m = s.model()
    inp = m[unk].as_long()
    good_inp += bytes([inp])

# print the decrypted input
print(good_inp)
```