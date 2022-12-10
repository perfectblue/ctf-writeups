patterns1 = ida_bytes.compiled_binpat_vec_t()
ida_bytes.parse_binpat_str(patterns1,here(),'48 31 C0 65 48 8b 40 60',16,ida_nalt.BPU_2B)

patterns2 = ida_bytes.compiled_binpat_vec_t()
ida_bytes.parse_binpat_str(patterns2,here(),'85 c0 75 ?',16,ida_nalt.BPU_2B)

patterns3 = ida_bytes.compiled_binpat_vec_t()
ida_bytes.parse_binpat_str(patterns3,here(),'E8 00 00 00 00 C7 44 24 04 23 00 00 00 83 04 24 0D CB',16,ida_nalt.BPU_2B)


start_ea = here()
while True:
    start_ea = ida_bytes.bin_search(start_ea,start_ea+0x1000,patterns1,0)
    if start_ea != ida_idaapi.BADADDR:
        juicy_start_ea = ida_bytes.bin_search(start_ea, start_ea+0x1000,patterns2,0)
        # print(hex(next_start),hex(juicy_start_ea))
        if juicy_start_ea != ida_idaapi.BADADDR:
            juicy_start_ea += 4
            end_ea = ida_bytes.bin_search(juicy_start_ea, juicy_start_ea+0x1000,patterns3,0)
            print(hex(start_ea-12), hex(idaapi.get_fileregion_offset(juicy_start_ea)),',',hex(end_ea-juicy_start_ea))
            start_ea=end_ea
        else:
            print('second search failed')
            break
    else:
        print('search failed')
        break
