# Coredumb

We are given a core dump. Reversing this shows that hardcoded values are keyed xored with a 4 byte key then ran as shellcode. We can recover the 4 byte xor key by xoring the shellcode with asm(push rbp; mov rsp, rbp). Then we just reverse the shellcode, which takes some flag bytes as input and verifies if they are correct.
