# Crypto 02

This problem provides you with some generated message that you have to decrypt,
and an encrypt oracle. At some point you can provide the message and decrypt it,
and at that point, if it is correct, you get the flag. 

We first note that encrypting a letter, vs a number, vs a symbol yields
different size hex strings, and each hex string corresponds to a character. This
means that most of the bytes in this hex string is useless junk. 

My hypothesis was that perhaps a certain subset of bits actually determine what
letter it is. To verify that, I encrypted 'A' some number of times, then
encrypted 'B'. Based on my hypothesis, bytes that differ at each iteration of
encrypting 'A' is just noise, and the bytes that didn't change at all between
both 'A' and 'B' are also ignored. 

By making a few tests, we also noticed consistent format in the chaos strings:
the hex strings can be divided into pairs, separated by 2f or '/'. Each pair has
the same two hex strings (so the corresponding 2-byte coding is the same).
Effectively, a letter has 4 bytes of entropy. We noticed that for upper case
letters, the 2nd byte is same across all 'A's, but different for 'B'. For lower
case, we find it to be the third pair. For symbols, it is the first pair, and
numbers, it is also the third pair. Numbers has 3 pairs, while symbols have 5
pairs. 

Next we observe that the position also changes those respective values.

Unfortunately the mapping between position, letters, actual byte value is varied
(i.e. there's no consistent pattern, and it changes each time), and the
relationship can be linear or some other crazy relation. For simplicity, we just
brute all the letters, symbols, and numbers at all positions.

Here is the [solve script](./crypto.py) for this cancerous crypto challenge. 
