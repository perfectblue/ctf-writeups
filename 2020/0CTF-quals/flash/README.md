## Flash

This challenge by far took the longest for me! This challenge consisted of a
kernel and a bios aspect to it. Here I will just briefly explain the highlights
of my reverse, but maybe someday I'll write a blog on it. 

The program consisted of two parts (the BIOs aspect and the kernel aspect). The
bios started from memory 0xbfc00000 and the kernel from 0x80000000 (which is
copied from the end of the BIOs image). The cool thing about this challenge is
that it uses an interrupt using the CPU clock (via COMPARE/COUNT co0 registers),
to go into the BIOs, and the bios would then make a swicheroo of the PC. 

In the end I finally decided to just write a ghidra script that undid this
branch scrambling technique, so that I can at least get readable code. 

Unsurprisingly once I unpacked this code, there was actually a nested VM (a
simple stack-based machine, that performed some modular arithmetic on the input
flag). At this point, I was kinda upset because this was definitely something
that could've been cheesed by instruction counting. On the other hand tho, it
was still nice going through this code... I learned a lot more about the kernel
stuff in MIPS. 

I also got pretty upset after learning the bug for the pwn part because I did
end up spending a lot of time trying to figure out how this code worked, and how
to try to pwn it. :(
