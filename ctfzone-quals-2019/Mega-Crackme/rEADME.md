# Mega Crackme

We have to reverse a sony genesis ROM. Using ghidra and the 68000 processor chipset, we can decompile the ROM. Looking for interesting functions, we find conditions imposed on a 16 byte input, which is what we are looking for. Then, use z3 to constraint solve the input and get the flag.
