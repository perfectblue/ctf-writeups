# polyshell

**Category**: Programming

482 Points

22 Solves

**Problem description**:
You might be cool, but are you 5 popped shells cool?

---

The aim of the challenge is to write a polyglot syscall shellcode that works on 5 architectures.

```
$ nc polyshell-01.play.midnightsunctf.se 30000

Welcome to the polyglot challenge!
Your task is to create a shellcode that can run on the following architectures:
x86
x86-64
ARM
ARM64
MIPS-LE

The shellcode must run within 1 second(s) and may run for at most 100000 cycles.
The code must perform a syscall on each platform according to the following paramters:
Syscall number: 234
Argument 1: 52790
Argument 2: A pointer to the string "sharp"

You submit your code as a hex encoded string of max 4096 characters (2048 bytes)

Your shellcode: ^C
```

This challenge is a lot like the [Doublethink challenge](https://www.robertxiao.ca/hacking/defcon2018-assembly-polyglot/) from DEFCON 2018 CTF.
However, we don't have to deal with any stupid architectures like PDP or Clemency.
The approach for these types of problems is to develop some initial code which are jumps for certain architectures, and effectively nops for other architectures.
This way we can distinguish between the architecture we are currently running on without crashing on any of them.
Then we can just write generic shellcode for each architecture after we have branched based on the current arch.

First I will discuss the branching code. We took some inspiration from [this repository](https://github.com/ixty/xarch_shellcode) which had a polyglot for all architectures except MIPS.
Our final branching code looked like this:

```
eb 1e 00 32    # 0x00  x86,x86_64 jump to 0x6b. everything else nop
04 00 42 10    # 0x04  MIPS jump to 0x18. both ARMs nop
eb 69 00 32    # 0x08  nop for MIPs due to branch delayed slots T_T
00 00 00 ea    # 0x0c  ARM jump to 0x14. ARM64 nop
3c 00 00 14    # 0x10  ARM64 jump to final payload (0x100)
7a 00 00 ea    # 0x14  ARM jump to final payload (0x200)
b9 00 00 10    # 0x18  MIPS jump to final payload (0x300)
00 00 00 00    # 0x1c  MIPS branch delayed slot nop shit
31 c0 40 90    # 0x20  x86,x86_64 differentiator
74 05          # 0x24  x64 jump to 0x2b
e9 d5 03 00 00 # 0x26  x86 jump to final payload (0x400)
e9 d0 04 00 00 # 0x2b  x64 jump to final payload (0x500)
```

To aid in writing this we used [an online diassembler/assembler](https://disasm.ninja) written by Jazzy.

The hardest part was to find a branch that worked for MIPS while being a nop for ARM and ARM64.
I also had to insert another nop for MIPS due to the "branch delay slot" problem where
the instruction immediately following a branch will get executed unconditionally, regardless
whether you branched or not. Otherwise the code was relatively straightforward, and our goal
was just to avoid segfaulting or executing illegal/invalid instructions.

For the actual payload themselves the syscall number, arg1, and arg2 are random each time,
so we need to do this in something like pwntools. However they are very trivial so I will not
discuss them in any more detail. We have a lot of space to work with so we don't need to use
any other clever tricks.
