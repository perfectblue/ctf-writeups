# Plaidflix

We have a UAF vulnerability through shared friend name. This allows us to leak heap and libc. Note that the LSB of unsorted bins was "\x00", so we have to sort unsorted into smallbins to leak a libc pointer. Because libc 2.32 has safe linking, the heap pointer is mangled, but we can unmangle this by knowing the lsb 12 bits and doing a bit of xor math.

The second vulnerability is UAF with 0x100 sized chunks. We can consolidate two 0x100 smallbin chunks, then use the single 0x120 chunk allocation to split the consolidated chunk. Then we forge a valid chunk at the UAF'd pointer to reclaim that chunk, and overwrite unsorted bin metadata to extend that chunk and obtain overlap. After overlap, we can overwrite tcache freelist pointer to freehook and win.

## Flag

`PCTF{N0w_YOu_Kn0w_S4f3_L1nk1ng!}`
