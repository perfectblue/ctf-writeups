WhiteHat 2020 Quals: Programming 02
==================================

In this challenge, we are asked to find the number of passwords that can be generated using this numpad:

```
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| * | 0 | # |
+---+---+---+
```

We are restricted by certain rules:

1. The password has length of n
2. The password must end with either *, 8 or #.
3. After one character, the character which is on the knight move pattern (as the
knight in chess) can be the next character. For example, if the current character
is 3, then the next character can be either 4 or 8.

We can treat this numpad as a graph, with the nodes being the numbers and there being a edge between two numbers if we can move from one
number to another using a knights move pattern. The answer is the number of (n-1)-length walks from each vertex to one of the special vertices (*, 8 or #).

To calculate this number, we can generate a adjacency matrix of the graph and raise it to the (n-1)th power modulo 1e16. The value at `Matrix[i][j]` will be the number of
passwords of length n which start at i and end at j. So we can add up the columns for our special verices to get the answer.

We can write a quick script in sage to interact with the remote and solve the challenges.

```py
from sage.all import *

def conv(i, j):
    return i * 3 + j

a = []

for i in range(4):
    for j in range(3):
        curr = []
        for k in range(4):
            for l in range(3):
                if (abs(i-k) == 2 and abs(j-l) == 1) or (abs(i-k) == 1 and abs(j-l) == 2):
                    curr.append(1)
                else:
                    curr.append(0)
        a.append(curr)

mod_num = 10**39

print a
M = Matrix(IntegerModRing(mod_num), a)

flag = ''

proc = remote('15.165.30.141', 9399)
while True:
    proc.recvuntil("n = ")
    curr_n = int(proc.recvline().strip())
    sice = M**(curr_n-1)

    ans = 0

    for j in range(12):
        ans += sice[conv(3, 0)][j]
        ans += sice[conv(2, 1)][j]
        ans += sice[conv(3, 2)][j]

    ans = ans % mod_num
    print ans
    proc.recvuntil("Answer: ")
    proc.sendline(str(ans))
    reward = proc.recvline().strip()
    print reward
    flag += reward[-1]
    print flag
```

Running this goes through all the questies and gives us the flag:

```
$ sage -python solve.sage
[[0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0], [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1], [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0], [0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0], [0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0], [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0]]
[+] Opening connection to 15.165.30.141 on port 9399: Done
6552
Thank you <3 Here is your reward: W
W
565482
Thank you <3 Here is your reward: h
Wh
186
Thank you <3 Here is your reward: i
Whi
1102
Thank you <3 Here is your reward: t
Whit
.
.
.
Thank you <3 Here is your reward: <
WhiteHat{S0_many_p4ssw0rd_uhuhu_giveup_already_:<
912219433891006851086847902654884262008
Thank you <3 Here is your reward: }
WhiteHat{S0_many_p4ssw0rd_uhuhu_giveup_already_:<}
```
