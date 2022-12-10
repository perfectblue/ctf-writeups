patterns1 = ida_bytes.compiled_binpat_vec_t()
ida_bytes.parse_binpat_str(patterns1,here(),'6A 33 E8 00 00 00 00 83 04 24 05 cb',16,ida_nalt.BPU_2B)

patterns2 = ida_bytes.compiled_binpat_vec_t()
ida_bytes.parse_binpat_str(patterns2,here(),'E8 00 00 00 00 C7 44 24 04 23 00 00 00 83 04 24 0D CB',16,ida_nalt.BPU_2B)

def lol():
    start_ea = ida_bytes.bin_search(here(), here()+0x1000,patterns1,0)
    if start_ea != ida_idaapi.BADADDR:
        idc.create_insn(start_ea)
        next_start = start_ea + 12
        end_ea = ida_bytes.bin_search(next_start, next_start+0x1000,patterns2,0)
        print(hex(next_start),hex(end_ea))
        if end_ea != ida_idaapi.BADADDR:
            srsly_the_end_ea = end_ea+18
            ok = ida_segment.add_segm(0, next_start, srsly_the_end_ea,None,'CODE')
            if ok:
                s = ida_segment.getseg(next_start)
                if s:
                    ok = ida_segment.set_segm_addressing(s, 2) # 64bits
                    if ok:
                        idc.create_insn(next_start)
                        idc.create_insn(srsly_the_end_ea)
                        idaapi.jumpto(srsly_the_end_ea)
                        print('ok')
                else:
                    print('getseg failed')
            else:
                print('add_segm failed')
        else:
            print('second search failed')
    else:
        print('search failed')
