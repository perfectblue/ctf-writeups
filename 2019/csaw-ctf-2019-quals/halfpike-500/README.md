# Halfpike

**Category**: Reversing

500 Points

27 Solves

**Problem description**:

Ah, the 70's, a time of love, rock and roll, and the emergence of the microprocessor. At that time, a young upstart company by the name of Intel was doing a contracting job to keep the lights on, and they created an interesting little chip: the Intel 4004. Today, we've mostly forgotten that cute little CPU's legacy, so it might be good for us all to have a little reminder about how innovative it was!

[This might come in handy](https://archive.org/details/bitsavers_intelMCS4MProgrammingManualDec73_5215098)

Author: Josh Hofing (@hyperosonic, @trailofbits)

---

This was an Intel 4004 challenge. The processor is ancient; it predates even 8086 and 8080. Apart from some idiosyncrasies, the instruction set is actually surprisingly familiar to x86. The biggest challenges of the ISA are:

- 4-bit word size and registers
- Register pairs
- Bizarre addressing modes and "segmentation" of ROM and RAM
- ROM has 8-bit words, RAM has 4-bit words

Let's go through these one-by-one.

### 4-bit word size and registers

The 4004 is a 4-bit processor. All registers are 4 bits (so one hex digit). The accumulator is the only register hooked up to the ALU and is also 4 bits. Therefore basically all arithmetic and logical operations are done 4 bits at a time with carry.

### Register pairs

There are 16 general-purpose registers, `r0` through `r15`. Keep in mind these registers are 4 bits each. These 16 GPRs form 8 register pairs, `p0` through `p7`, where `p0` is `r0:r1`, `p1` is `r2:r3`, et cetera. More specifically `p0`s high 4 bits is in `r0`, and the low 4 bits is in `r1`. Register pairs are used to address memory.

### Bizarre addressing modes and "segmentation" of ROM and RAM

Since the largest operands we have are the 8-bit immediates and register pairs, how can we address the 12-bit address space we have available to us? For ROM, this is accomplished using a weird form of segmentation. Essentially, the highest 4 bits of the address is always the same as the highest 4 bits of the current instruction. The lower 8 bits are specified via register pair or immediate.

For example, this code will load 8 bits from the ROM at address 0x712 into `p0`:

```
00000000  2000               fim p0 0x0 ; load 8-bit immediate 0 to p0
00000002  5730               jms 0x730 ; far jump to 0x730
00000730  32                 fin p1 ; fetch 8 bits from ROM at [p0] to p1
```

RAM is even weirder. Essentially, you have 8 banks of 256 words. You select one bank at a time using `dcl`. `dcl` essentially sets the bank number to the low 3 bits of the accumulator. So for example, this code loads a word from RAM bank 3, address 0x69 into `r5`:

```
fim p0 0x03 ; load 8-bit immediate 3 to r0:r1
ld r1 ; load r1 (which is holding 3) to accumulator
dcl ; select bank 3 (based on accumulator)
fim p1 0x69 ; load 8-bit immediate 0x69 to p1
src p1 ; select RAM address r2:r3
rdm ; fetch word from RAM to accumulator
xch r5 ; exchange accumulator to r5
```

### ROM has 8-bit words, RAM has 4-bit words

The ROM is addressed in terms of bytes; the RAM is addressed in terms of 4-bit nibbles.
This means that RAM is laid out like this:

```
00: [high 4 bits of byte 0]
01: [low 4 bits of byte 0]
02: [high 4 bits of byte 1]
03: [low 4 bits of byte 1]
... and so on
```

With the ISA headache out of the way let's dive into the program. They provided us a Binary Ninja architecture plugin which is great. There were a few bugs with Python 3 support which I fixed.

The program starts off by printing a welcome message then loading memory from ROM into each of the 8 RAM banks:

```
00000000  40a9               jun 0xa9
000000a9  2000               fim p0 0x0  // 0x700 = "welcome"
000000ab  5739               jms printString

000000ad  d0                 ldm 0x0  // initialize VM 0
000000ae  fd                 dcl
000000af  2000               fim p0 0x0  // 400
000000b1  5480               jms copy32BytesBanks0-3
000000b3  2000               fim p0 0x0  // 600
000000b5  561c               jms copy3Bytes
000000b7  5640               jms read3Bytes

000000b9  d1                 ldm 0x1 // initialize VM 1
000000ba  fd                 dcl
000000bb  2020               fim p0 0x20
000000bd  5480               jms copy32BytesBanks0-3
000000bf  2003               fim p0 0x3
000000c1  561c               jms copy3Bytes
000000c3  5640               jms read3Bytes

... etc

00000101  d7                 ldm 0x7 // initialize VM 7
00000102  fd                 dcl
00000103  2060               fim p0 0x60
00000105  5580               jms 0x580
00000107  2019               fim p0 data_19
00000109  561c               jms copy3Bytes
0000010b  5640               jms read3Bytes

0000010d  d0                 ldm 0x0
0000010e  fd                 dcl
0000010f  4200               jun vm_step
```

After initializing it jumps to a coroutine `vm_step`, which essentially implements a virtual machine(!) that interprets the bytecode from RAM that we just loaded. There are 8 RAM banks, and each one hosts a virtual machine. In other words, 8 virtual machines are executing in parallel. The virtual machine is essentially a flag checker, and each virtual machine checks 3 bytes of the flag. The vm executes until it halts either in an accepting, or rejecting state. The whole program terminates when all virtual machines halt.

Here is the memory layout of each RAM bank:

![memorymap.png](memorymap.png)

I honestly think that Microsoft Excel is one of the most underrated reverse engineering tools.

Anyways, address 0x00-0x3f holds the VM's bytecode, 0xa0-0xa5 holds the input to check, 0xa6-0xab holds initialized data, and 0xbc-0xbf is scratch space. The value at 0x9d is 1 if the VM rejects the input, otherwise 0 if it accepts. The value at 0x9e is 1 if the VM has halted, and 0x9f is the VM's instruction pointer.

The VM's instruction set is composed of 8 instructions. Each instruction is 4 nibbles long, or two bytes. The instruction pointer refers to the **instruction count**, meaning that the actual RAM address of instruction number `i` is `4*i`. Each instruction is implemented in a subroutine in the program, where registers r10-r12 hold 3 operands:

```
// Compare two nibbles and update control flags.
// 
// if ([0xa0+r10] != [0xa0 + r11]) {
//   if (r12 && ![9e])
//     [9d] = r12;
//   [9e] = 1;
// }
vm_op0_cmp

// Rotate a nibble left r11 times.
// [a0 + r10] = rol([a0 + r10], r11)
vm_op1_rol

// Copy 4 bits from the host to the guest.
// [0xa0 + r10] = [r11]
vm_op2_recv

// Xor a nibble by an immediate.
// [a0 + r10] ^= r11
vm_op3_xor

// Send 4 bits from the guest to the host.
// [r10] = [a0 + r11]
vm_op4_send

// Set IP=0.
// [9f] = 0
vm_op5_loop

// If [a0 + r10] != [a0 + r11], skip the next instruction.
// If [a0 + r10] != [a0 + r11]: [9f]++
vm_op6_skip

// Add immediate to nibble.
// [a0 + r10] += r11
vm_op7_add
```

The `vm_step` coroutine discussed earlier simply executes 1 instruction for each of the 8 VMs. It loads r9-r12 from RAM, then jumps to the appropriate instruction handler using a jump table. Each instruction subroutine is responsible for jumping back to `vm_step` to yield.

With this in mind we can simply just extract the VM bytecodes and data then "solve" each VM. Since each VM only checks 3 bytes at a time, this is trivial to bruteforce. There's some self-modifying code BS in several VMs, but brute force doesn't care. The script takes less than 2 seconds on PyPy.

Here's the disassembly and correct input for each of the VMs. Together they form the flag.

```
VM 0:
cmp [4], [6], 1
cmp [5], [7], 1
cmp [1], [8], 1
cmp [2], [9], 1
cmp [3], [a], 1
cmp [0], [b], 1
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
fla -> ACCEPT

VM 1:
xor [0], 5
xor [1], 1
xor [2], 1
xor [3], e
xor [4], 4
xor [5], 7
cmp [0], [6], 1
cmp [1], [7], 1
cmp [2], [8], 1
cmp [3], [9], 1
cmp [4], [a], 1
cmp [5], [b], 1
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
g{i -> ACCEPT

VM 2:
cmp [0], [6], 1
recv guest:[c], vm:[6]
recv guest:[c], vm:[1]
add [c], 1
send vm:[1], guest:[c]
recv guest:[c], vm:[2]
add [c], 1
send vm:[2], guest:[c]
recv guest:[c], vm:[6]
recv guest:[d], vm:[1]
skipne [c], [d]
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
ntl -> ACCEPT

VM 3:
xor [0], 6
cmp [0], [6], 1
recv guest:[c], vm:[1]
add [c], 1
send vm:[1], guest:[c]
send vm:[5], guest:[c]
recv guest:[d], vm:[6]
add [d], 1
send vm:[6], guest:[d]
recv guest:[d], vm:[b]
skipne [c], [d]
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
_cp -> ACCEPT

VM 4:
add [0], 5
add [1], 1
add [2], 1
add [3], e
add [4], 4
add [5], 7
cmp [0], [6], 1
cmp [1], [7], 1
cmp [2], [8], 1
cmp [3], [9], 1
cmp [4], [a], 1
cmp [5], [b], 1
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
us_ -> ACCEPT

VM 5:
add [0], 6
cmp [0], [6], 1
recv guest:[c], vm:[1]
add [c], 1
send vm:[1], guest:[c]
send vm:[5], guest:[c]
recv guest:[d], vm:[6]
add [d], 1
send vm:[6], guest:[d]
recv guest:[d], vm:[b]
skipne [c], [d]
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
sca -> ACCEPT

VM 6:
rol [0], f
rol [1], d
rol [2], 7
rol [3], 6
rol [4], 4
rol [5], b
cmp [0], [6], 1
cmp [1], [7], 1
cmp [2], [8], 1
cmp [3], [9], 1
cmp [4], [a], 1
cmp [5], [b], 1
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
re_ -> ACCEPT

VM 7:
rol [0], 6
cmp [0], [6], 1
recv guest:[c], vm:[1]
add [c], 1
send vm:[1], guest:[c]
send vm:[5], guest:[c]
recv guest:[d], vm:[6]
add [d], 1
send vm:[6], guest:[d]
recv guest:[d], vm:[b]
skipne [c], [d]
cmp [0], [f], 0
loop
cmp [0], [0], 0
cmp [0], [0], 0
cmp [0], [0], 0
me} -> ACCEPT

SUCCESS
b'flag{intl_cpus_scare_me}'
```
