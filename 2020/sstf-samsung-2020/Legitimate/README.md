Legitimate
==========

In this challenge, we are given just a website: http://legitimate.sstf.site/.

Doing some manual fuzzing, we find that there is .git/ folder, so we use some online tools to download
the repository.

The downloaded repo seems to be empty, but we see a lot of commits with messages such as :

```
get dup 10 cmp
read 1 right 0 write 1 right 1 write 1 right write 1 right write 1 right 8 write
```

When we google some of these commands, we find that this is a from a esoteric programming language: https://github.com/blinry/legit

There are two commits which seem to be writing data to memory:

```
pop 67 write 1 left 99 write 1 left 57 write 1 left 65 write 1 left 82 write 1 left 86 write 1 left 120 write 1 left 83 write 1 left 72 write 1 left 98 write 1 left 74 write 1 left 81 write 1 left 72 write 1 left 90 write 1 left 99 write 1 left 118 write 1 left 57 write 1 left 68 write 1 left 88 write 1 left 110 write 1 left 81 write 1 left 52 write 1 left 100 write 1 left 74 write 1 left 121 write 1 left 81 write 1 left 77 write 1 left 83 write 1 left 122 write 1 left 113 write 1 left 81 write 1 left 80 write 1 left 66 write 1 left 117 write 1 left 77 write 1 left 69 write 1 left 97 write 1 left 55 write 1 left 102 write 1 left 88 write 1 left 40 right
1 right 11 write 1 right 37 write 1 right 99 write 1 right 39 write 1 right 62 write 1 right 126 write 1 right 64 write 1 right 114 write 1 right 103 write 1 right 98 write 1 right 3 write 1 right 75 write 1 right 16 write 1 right 18 write 1 right 96 write 1 right 74 write 1 right 124 write 1 right 85 write 1 right 3 write 1 right 14 write 1 right 45 write 1 right 42 write 1 right 29 write 1 right 105 write 1 right 65 write 1 right 83 write 1 right 5 write 1 right 121 write 1 right 100 write 1 right 21 write 1 right 47 write 1 right 124 write 1 right 101 write 1 right 73 write 1 right 21 write 1 right 13 write 1 right 25 write 1 right 9 write 1 right 17 write 1 right 62 write 0
```

One is writing data from right to left and the other is writing data from left to right on the tape.

Let's extract the numbers from these in python and convert them into strings.

```
>>> x = "1 right ..."
>>> y = "pop 67 ..."
>>> x = [chr(int(a)) for a in x.split()[2::4]]
>>> y = [chr(int(a)) for a in y.split()[1::4]][::-1]
>>> x
"\x0b%c'>~@rgb\x03K\x10\x12`J|U\x03\x0e-*\x1diAS\x05yd\x15/|eI\x15\r\x19\t\x11>"
>>> y
'Cc9ARVxSHbJQHZcv9DXnQ4dJyQMSzqQPBuMEa7fX'
```

If we take a guess and reverse one of the strings and xor them, we get the flag:

```
>>> xor(x, y[::-1])
'SCTF{35073r1C_13617_CrYP70_15_M461C_X0r}'
>>>
```
