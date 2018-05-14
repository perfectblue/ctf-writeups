This is a MIPs challenge. So let's fire up qemu-mips and gdb-multiarch:

`qemu-mips -g 12345 ./reverseme < input.txt & gdb-multiarch ./reverseme`

So we see in the encode_me function there are three transformations:
 - the string is reversed.
 - each byte b_i of the string is subtracted by i*2.
 - each byte b_i of the string is xored with i+0x66

we also see the encoded input being compared with
`61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 40 70 71 72 73 74 75 76 77 78 79 7A`

So to decode, we apply the transformation backwards inside-out:
 - each byte b_i of the string is xored with i+0x66. this function is the inverse of itself in the modular field.
 - each byte b_i of the string is added to i*2.
 - the string is reversed


So the result is: `flag{D0_y0u_l1k3_m1ps???}`

I'm ambivalent. RISC is easy to grasp but it's not very expressive. Maybe it's good for embedded. [Modern cpus are hybrid RISC/CISC anyways](https://stackoverflow.com/questions/5806589/why-does-intel-hide-internal-risc-core-in-their-processors).
