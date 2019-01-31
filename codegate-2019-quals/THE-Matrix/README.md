# THE Matrix

90.9 Points

**Problem description**:
```
nc 110.10.147.106 15959

Download
```

I didn't solved this challenge, but I got eeeextremely close, only couldn't finish due to guessing at the end :<
It was a gameboy binary. First, I loaded into IDA, then manually (!) setup all the xrefs by changing immediates to offsets.
What you had to do was die 6 times, then Neo would approach you. Next, you had to connect to the gameboy serial port and send the byte 64h.
Upon getting past the final level (one with Architect), the game tells you that the answer is in the matrix. (????)
The game had setup some data at $C12D after each stage by the function at $142d.

- `0F 07 08 0C 03 0B 00 04`
- `09 0A 0B 0C`
- `0d 00 01 02 03 02 04 10 05 04 08 07 04 05 06 07 08 0e`

But WTF is this???

Anyways to solve... the game had setup some tile data at $c230.
If you copy this data to $8000 and view it in VRAM, there are actually letters.
And the previous data was the tile indices.

- `CONGRAT_`
- `FLAG`
- `{THERE_IS_NO_SPON}`

😭 How am i supposed to guess this????
