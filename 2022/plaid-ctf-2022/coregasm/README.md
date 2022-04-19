# coregasm

## Flag 1
Find the buffer and just do some simple byte xor.

## Flag 2
To read otp, we search for the `_IO_FILE` object that was opened for the otp
file (by searching for `0xfbad` file header), and then read the buffer
associated with it.

## Flag 3
We found that the ending part of the flag 3 was still lying around in memory by
running strings located in the file buffer for the stdout file. However, because
of later successive file writes, we are unable to recover the earlier bytes
because of the successive writes done.

Though, if we look at how flag 4 was encoded, we see that it is just a repeating
sequence of 8 bytes, so we just xor from there.

## Flag 4
This was solved by referencing ST registers:
```
st0            15.6579354707501636756 (raw 0x4002fa86e7581c014d00)
st1            214.831820219884093451 (raw 0x4006d6d4f22b808dbff5)
st2            2526.22752352315034186 (raw 0x400a9de3a3efb4b005ce)
st3            24751.5189151917131252 (raw 0x400dc15f09af40839c63)
st4            193984.053677134516846 (raw 0x4010bd70036f723852be)
st5            1139716.96293101242827 (raw 0x40138b2027b4152cb578)
st6            4457828.61824004405162 (raw 0x4015880ac93c89f5848f)
st7            8758372.44193981720582 (raw 0x401685a4647122f7c5b3)
```

