# Biooosless

Tl;dr read from floppy in 32bit protected mode with no BIOS, using PMIO. Your shellcode gets pasted into seabios.

# Intended solution

Write a floppy disk driver that does DMA. Output the flag using VGA MMIO

# My solution

1. Floppy disk

- Too stupid and lazy to learn about floppy disk, know remote hardware is always QEMU -> hack seabios to log all in/out instructions, copy paste them into shellcode.
- In/out not working -> add usleep() everywhere, shellcode magically starts working
- Final `in` instructions seems to return flag bytes -> Ignore DMA and use completely idiotic solution that works

2. Outputting the flag

- Too stupid and lazy to read docs and figure out VGA -> copy paste QEMU ACPI shutdown.
- Use as timing side channel for time-based blind boolean exfil. Binary search on flag chars
- Side channel is slow and unreliable -> babysit the brute force and guess words manually to speed it up
