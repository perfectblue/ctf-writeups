# SCAR

It's brute-forcable, one by one. Each flag character is independent from others,
and there are total 27 possible values `[A-Z_]`.

`gen.py` finds the number of messages to succeed the mining. For 5-character
inputs, only `'V'` does not have any answer. For example, `'A'` has an answer
`{171, 18, 1, 1, 1}`. It means we have to send `A----` 171 times, `-A---` 18
times, and so on, to check whether the first flag character is `'A'`.

It's a bit hard to explain well, but you will be able to get it by reading
`gen.py` and `solve.c`.
