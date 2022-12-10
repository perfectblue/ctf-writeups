from unicorn import *
from unicorn.x86_const import *
from capstone import *
from keystone import *
import pefile

import os
import sys
import mmap

filename = 'checker_drv.sys'
f = open(filename, 'rb')
mm = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)

pe = pefile.PE(filename)
pe.full_load()

def doit(path):
    mu = Uc(UC_ARCH_X86, UC_MODE_64)
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    ks = Ks(KS_ARCH_X86, KS_MODE_64)

    block_disasm = []

    def map_region(base_va, virtual_size, contents):
        if virtual_size & 0xfff:
            virtual_size += 4096 - (virtual_size & 0xfff)
        if virtual_size > len(contents):
            contents += b'\x00' * (virtual_size-len(contents))
        elif virtual_size < len(contents):
            contents = contents[:virtual_size]
        assert len(contents) == virtual_size

        mu.mem_map(base_va, virtual_size)
        mu.mem_write(base_va, contents)
        print(f'Mapped region {base_va:x}-{base_va+virtual_size:x}')

    for s in pe.sections:
        start_va = pe.NT_HEADERS.OPTIONAL_HEADER.ImageBase+s.VirtualAddress
        start_fo = s.PointerToRawData
        end_fo = start_fo + s.SizeOfRawData
        contents = mm[start_fo:end_fo]
        map_region(start_va, s.Misc_VirtualSize, contents)

    def hook_mem_invalid(uc, access, address, size, value, user_data):
        # fault this region in if it exists in the dump. otherwise, abort
        print ('>>> Page fault accessing unmapped memory at 0x%x, data size = %u, data value = 0x%x' %(address, size, value))
        return False # halt emulation

    mu.hook_add(UC_HOOK_MEM_READ_UNMAPPED | UC_HOOK_MEM_WRITE_UNMAPPED, hook_mem_invalid)

    def hook_mem_access(uc, access, address, size, value, user_data):
        return
        if access == UC_MEM_WRITE:
            print(">>> Memory is being WRITE at 0x%x, data size = %u, data value = 0x%x" %(address, size, value))
        else:   # READ
            print(">>> Memory is being READ at 0x%x, data size = %u" %(address, size))

    def hook_block(uc, address, size, user_data):
        # print(">>> Tracing basic block at 0x%x, block size = 0x%x" %(address, size))
        pass

    # callback for tracing instructions
    def hook_code64(uc, address, size, user_data):
        # print(">>> Tracing instruction at 0x%x, instruction size = 0x%x" %(address, size))
        if size == 0xf1f1f1f1: # invalid instruction
            print('>>> ' + hex(address) + ': invalid')
            return False
        code = mu.mem_read(address, size)
        # print(code.hex())
        disasm = list(md.disasm_lite(code, size))
        # print(disasm)
        if len(disasm) == 1:
            _, disasm_size, mnemonic, op_str = disasm[0]
            if disasm_size != size:
                print('wtf bad disasm')
                print(disasm_size,size,code.hex())
            # print('>>> ' + hex(address) + ': ' + mnemonic + ' ' + op_str)
            if mnemonic in ['out', 'hlt'] : # yeaaaa idts
                print('no thats a bad instruction. smh')
                mu.reg_write(UC_X86_REG_RIP, 0)
                return False
            block_disasm.append((address, size, mnemonic, op_str))
        else:
            print('>>> bad disasm?')
            print(code.hex(), size)
            block_disasm.append(code.hex())
            # mu.reg_write(UC_X86_REG_RIP, 0)
            return False

    mu.hook_add(UC_HOOK_MEM_WRITE, hook_mem_access)
    mu.hook_add(UC_HOOK_MEM_READ, hook_mem_access)
    mu.hook_add(UC_HOOK_BLOCK, hook_block)
    mu.hook_add(UC_HOOK_CODE, hook_code64)

    # map a stack
    stack_base, stack_size = 0x7ffffff0000, 0x10000
    mu.mem_map(stack_base, stack_size)

    def mem_xor(dst, src, len):
        for i in range(len):
            x = mu.mem_read(dst,1)[0]
            y = mu.mem_read(src,1)[0]
            mu.mem_write(dst,bytes([x^y]))
            dst += 1
            src += 1
        mu.ctl_remove_cache(dst-len,dst) # fucking flush emulator code cache

    def reset_regs():
        for regno in [UC_X86_REG_RAX, UC_X86_REG_RBP, UC_X86_REG_RBX, UC_X86_REG_RCX, UC_X86_REG_RDI, UC_X86_REG_RDX, UC_X86_REG_RIP, UC_X86_REG_RSI, UC_X86_REG_RSP, UC_X86_REG_R8, UC_X86_REG_R9, UC_X86_REG_R10, UC_X86_REG_R11, UC_X86_REG_R12, UC_X86_REG_R13, UC_X86_REG_R14, UC_X86_REG_R15, UC_X86_REG_EFLAGS]:
            mu.reg_write(regno, 0)

    pmathshit = 0x140001B30
    MyObjPreCallback = 0x140001430
    pFucker = 0x140003030
    pFlag = 0x140003000

    mem_xor(pmathshit, MyObjPreCallback, 16)
    mem_xor(pmathshit, MyObjPreCallback+16, 16)

    def emulate(start_va, rcx):
        block_disasm.clear()

        reset_regs()
        mu.mem_write(stack_base, b'\x00' * stack_size)
        stack_frame = stack_base + (stack_size - 0x1000)
        mu.mem_write(stack_frame, b'iiiiiiii') # fake return address
        mu.reg_write(UC_X86_REG_RIP, start_va) # i think this is unnecessary
        mu.reg_write(UC_X86_REG_RBP, stack_frame)
        mu.reg_write(UC_X86_REG_RSP, stack_frame)
        mu.reg_write(UC_X86_REG_RCX, rcx)
        try:
            mu.emu_start(start_va, 0x6969696969696969) # fake retaddr
        except UcError as e:
            print("ERROR: %s" % e)
            print('RIP=%x' % mu.reg_read(UC_X86_REG_RIP))
            return 0, False
        # print('ok?')
        # print(hex(mu.reg_read(UC_X86_REG_RIP)))
        rax = mu.reg_read(UC_X86_REG_RAX)
        # print (f'rax={rax:x}')
        return rax, True

    def emulate_mathshit(arg):
        print('call mathshit(%02x)' % arg)
        rax, ok = emulate(0x140001B30, arg)
        if ok:
            print('-> ok: 0x%x'% rax);
        else:
            print('-> not ok')
        return rax, ok

    def simulate_ioctl(i):
        mem_xor(pmathshit, pFucker+i, 16)
        
        for j in range(43):
            inp = mu.mem_read(pFlag+j,1)[0]
            rax, ok = emulate_mathshit(inp)
            if not ok:
                return None, False
            al = rax&0xff
            # print('inp %02x' % inp, 'plain %02x'%( al))
            mu.mem_write(pFlag+j, bytes([al]))
        
        mem_xor(pmathshit, pFucker+i+16, 16)
        return block_disasm, True

    for i in path:
        print('i',hex(i))
        result, ok = simulate_ioctl(i)
        if not ok:
            return None, False
        print('code', result)
    result=mu.mem_read(pFlag,43)
    return result, True

path = [0xe0,0x40,192,0,32,128,96,160]
result,ok = doit(path)
print(result,ok)

# gucci = []
# for i in range(0,0x100,0x20):
#     try_path = path[:] + [i]
#     block_disasm, ok = doit(try_path)
#     if ok:
#         gucci.append((i, block_disasm))
#     print()
#     print()
#     print()
#     print()

# for g in gucci:
#     print(g)