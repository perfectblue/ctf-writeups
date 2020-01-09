
# ----------------------------------------------------------------------
# EFI bytecode processor module
# (c) Hex-Rays
# Please send fixes or improvements to support@hex-rays.com

import sys
from ida_bytes import *
from ida_ua import *
from ida_idp import *
from ida_auto import *
from ida_nalt import *
import ida_frame
from ida_funcs import *
from ida_lines import *
from ida_problems import *
import ida_offset
from ida_segment import *
from ida_name import *
from ida_netnode import *

# fix for ea overflow ... ?
def add_ea(*ea_list):
    return sum(ea_list) & 0xFFFFFFFFFFFFFFFF

# extract bitfield occupying bits high..low from val (inclusive, start from 0)
def BITS(val, low, high):
  return (val>>low)&((1<<(high-low+1))-1)
# extract one bit
def BIT(val, bit):
  return (val>>bit) & 1
# sign extend b low bits in x
# from "Bit Twiddling Hacks"
def SIGNEXT(x, b):
  m = 1 << (b - 1)
  x = x & ((1 << b) - 1)
  return (x ^ m) - m

# check if operand is register reg
def is_reg(op, reg):
    return op.type == o_reg and op.reg == reg

# check if operand is immediate value val
def is_imm(op, val):
    return op.type == o_imm and op.value == val

# are operands equal?
def same_op(op1, op2):
    return op1.type  == op2.type  and \
           op1.reg   == op2.reg   and \
           op1.value == op2.value and \
           op1.addr  == op2.addr  and \
           op1.flags == op2.flags and \
           op1.specval == op2.specval and \
           op1.dtype == op2.dtype

# is sp delta fixed by the user?
def is_fixed_spd(ea):
    return (get_aflags(ea) & AFL_FIXEDSPD) != 0

# ----------------------------------------------------------------------
class ebc_processor_t(processor_t):
    # IDP id ( Numbers above 0x8000 are reserved for the third-party modules)
    id = PLFM_EBC

    # Processor features
    flag = PR_SEGS | PR_DEFSEG32 | PR_USE32 | PRN_HEX | PR_RNAMESOK | PR_NO_SEGMOVE | PR_TYPEINFO

    # Number of bits in a byte for code segments (usually 8)
    # IDA supports values up to 32 bits
    cnbits = 8

    # Number of bits in a byte for non-code segments (usually 8)
    # IDA supports values up to 32 bits
    dnbits = 8

    # short processor names
    # Each name should be shorter than 9 characters
    psnames = ['ebc']

    # long processor names
    # No restriction on name lengthes.
    plnames = ['EFI Byte code']

    # size of a segment register in bytes
    segreg_size = 0

    # Array of typical code start sequences (optional)
    # codestart = ['\x60\x00']  # 60 00 xx xx: MOVqw         SP, SP-delta

    # Array of 'return' instruction opcodes (optional)
    # retcodes = ['\x04\x00']   # 04 00: RET

    # You should define 2 virtual segment registers for CS and DS.
    # Let's call them rVcs and rVds.

    # icode of the first instruction
    instruc_start = 0

    #
    #      Size of long double (tbyte) for this processor
    #      (meaningful only if ash.a_tbyte != NULL)
    #
    tbyte_size = 0

    # only one assembler is supported
    assembler = {
        # flag
        'flag' : ASH_HEXF3 | AS_UNEQU | AS_COLON | ASB_BINF4 | AS_N2CHR,

        # user defined flags (local only for IDP)
        # you may define and use your own bits
        'uflag' : 0,

        # Assembler name (displayed in menus)
        'name': "EFI bytecode assembler",

        # org directive
        'origin': "org",

        # end directive
        'end': "end",

        # comment string (see also cmnt2)
        'cmnt': ";",

        # ASCII string delimiter
        'ascsep': "\"",

        # ASCII char constant delimiter
        'accsep': "'",

        # ASCII special chars (they can't appear in character and ascii constants)
        'esccodes': "\"'",

        #
        #      Data representation (db,dw,...):
        #
        # ASCII string directive
        'a_ascii': "db",

        # byte directive
        'a_byte': "db",

        # word directive
        'a_word': "dw",

        # remove if not allowed
        'a_dword': "dd",

        # remove if not allowed
        'a_qword': "dq",

        # remove if not allowed
        'a_oword': "xmmword",

        # float;  4bytes; remove if not allowed
        'a_float': "dd",

        # double; 8bytes; NULL if not allowed
        'a_double': "dq",

        # long double;    NULL if not allowed
        'a_tbyte': "dt",

        # array keyword. the following
        # sequences may appear:
        #      #h - header
        #      #d - size
        #      #v - value
        #      #s(b,w,l,q,f,d,o) - size specifiers
        #                        for byte,word,
        #                            dword,qword,
        #                            float,double,oword
        'a_dups': "#d dup(#v)",

        # uninitialized data directive (should include '%s' for the size of data)
        'a_bss': "%s dup ?",

        # 'seg ' prefix (example: push seg seg001)
        'a_seg': "seg",

        # current IP (instruction pointer) symbol in assembler
        'a_curip': "$",

        # "public" name keyword. NULL-gen default, ""-do not generate
        'a_public': "public",

        # "weak"   name keyword. NULL-gen default, ""-do not generate
        'a_weak': "weak",

        # "extrn"  name keyword
        'a_extrn': "extrn",

        # "comm" (communal variable)
        'a_comdef': "",

        # "align" keyword
        'a_align': "align",

        # Left and right braces used in complex expressions
        'lbrace': "(",
        'rbrace': ")",

        # %  mod     assembler time operation
        'a_mod': "%",

        # &  bit and assembler time operation
        'a_band': "&",

        # |  bit or  assembler time operation
        'a_bor': "|",

        # ^  bit xor assembler time operation
        'a_xor': "^",

        # ~  bit not assembler time operation
        'a_bnot': "~",

        # << shift left assembler time operation
        'a_shl': "<<",

        # >> shift right assembler time operation
        'a_shr': ">>",

        # size of type (format string)
        'a_sizeof_fmt': "size %s",
    } # Assembler

    # ----------------------------------------------------------------------
    # Some internal flags used by the decoder, emulator and output
    # operand size or move size; can be in both auxpref and OpN.specval
    FL_B               = 0x0001 # 8 bits
    FL_W               = 0x0002 # 16 bits
    FL_D               = 0x0004 # 32 bits
    FL_Q               = 0x0008 # 64 bits

    # OpN.specval
    FLo_INDIRECT       = 0x0010 # This is an indirect access (not immediate value)
    FLo_SIGNED         = 0x0020 # This is a signed operand

    # insn_t.auxpref flags (NB: only 16 bits!)
    FLa_OP1            = 0x0010 # check operand 1
    FLa_32             = 0x0020 # Is 32
    FLa_64             = 0x0040 # Is 64
    FLa_EXTERN         = 0x0080 # external call (via thunk)
    FLa_ABS            = 0x0100 # absolute call
    FLa_CS             = 0x0200 # Condition flag is set
    FLa_NCS            = 0x0400 # Condition flag is not set
    FLa_CMPMASK        = 0xF000 # mask of the CMP[I] comparison
    FLa_CMPeq          = 0x1000 # compare equal
    FLa_CMPlte         = 0x2000 # compare signed less than or equal
    FLa_CMPgte         = 0x3000 # compare signed greater than or equal
    FLa_CMPulte        = 0x4000 # compare unsigned less than or equal
    FLa_CMPugte        = 0x5000 # compare unsigned greater than or equal

    IMMDATA_16 = 1
    IMMDATA_32 = 2
    IMMDATA_64 = 3

    # ----------------------------------------------------------------------
    # Utility functions
    #

    # ----------------------------------------------------------------------
    # set comparison kind (eq/lte/gte/ulte/ugte)
    def set_cmp(self, insn, no):
        insn.auxpref &= ~self.FLa_CMPMASK
        insn.auxpref |= [self.FLa_CMPeq, self.FLa_CMPlte,
                             self.FLa_CMPgte, self.FLa_CMPulte,
                             self.FLa_CMPugte][no]

    # ----------------------------------------------------------------------
    # get comparison kind (eq/lte/gte/ulte/ugte)
    def get_cmp(self, insn):
        t = insn.auxpref & self.FLa_CMPMASK
        if t:
            return { self.FLa_CMPeq: "eq",
                     self.FLa_CMPlte: "lte",
                     self.FLa_CMPgte: "gte",
                     self.FLa_CMPulte: "ulte",
                     self.FLa_CMPugte: "ugte" } [t]

    # ----------------------------------------------------------------------
    def get_data_width_fl(self, sz):
        """Returns a flag given the data width number"""
        if   sz == 0: return self.FL_B
        elif sz == self.IMMDATA_16: return self.FL_W
        elif sz == self.IMMDATA_32: return self.FL_D
        elif sz == self.IMMDATA_64: return self.FL_Q

    # ----------------------------------------------------------------------
    def next_data_value(self, insn, sz):
        """Returns a value depending on the data widh number"""
        if   sz == 0: return insn.get_next_byte()
        elif sz == self.IMMDATA_16: return insn.get_next_word()
        elif sz == self.IMMDATA_32: return insn.get_next_dword()
        elif sz == self.IMMDATA_64: return insn.get_next_qword()
        else: raise Exception, "Invalid width!"

    # ----------------------------------------------------------------------
    def get_data_dt(self, sz):
        """Returns a dt_xxx on the data widh number"""
        if   sz == 0: return dt_byte
        elif sz == self.IMMDATA_16: return dt_word
        elif sz == self.IMMDATA_32: return dt_dword
        elif sz == self.IMMDATA_64: return dt_qword
        else: raise Exception, "Invalid width!"

    # ----------------------------------------------------------------------
    def native_dt(self):
        return dt_qword if self.PTRSZ==8 else dt_dword

    # ----------------------------------------------------------------------
    def get_sz_to_bits(self, sz):
        """Returns size in bits of the data widh number"""
        if   sz == self.IMMDATA_16: return 16
        elif sz == self.IMMDATA_32: return 32
        elif sz == self.IMMDATA_64: return 64
        else:         return 8

    # ----------------------------------------------------------------------
    def dt_to_bits(self, dt):
        """Returns the size in bits given a dt_xxx"""
        if   dt == dt_byte:  return 8
        elif dt == dt_word:  return 16
        elif dt == dt_dword: return 32
        elif dt == dt_qword: return 64

    # ----------------------------------------------------------------------
    def dt_to_width(self, dt):
        """Returns OOFW_xxx flag given a dt_xxx"""
        if   dt == dt_byte:  return OOFW_8
        elif dt == dt_word:  return OOFW_16
        elif dt == dt_dword: return OOFW_32
        elif dt == dt_qword: return OOFW_64

    # ----------------------------------------------------------------------
    def fl_to_str(self, fl):
        """Given a flag, it returns a string. (used during output)"""
        if   fl & self.FL_B != 0: return "b"
        elif fl & self.FL_W != 0: return "w"
        elif fl & self.FL_D != 0: return "d"
        elif fl & self.FL_Q != 0: return "q"

    # ----------------------------------------------------------------------
    def set_ptr_size(self):
        """
        Functions checks the database / PE header netnode and sees if the input file
        is a PE+ or not. If so, then pointer size is set to 8 bytes.
        """
        n = netnode("$ PE header")
        s = n.valobj()
        if not s:
            return
        # Extract magic field
        t = struct.unpack("<H", s[0x18:0x18+2])[0]
        if t == 0x20B:
            self.PTRSZ = 8

    # ----------------------------------------------------------------------
    # Decodes an index and returns all its components in a dictionary
    # Refer to "Index Encoding" section
    def decode_index(self, index, sz):
        N = sz - 1
        s = -1 if BIT(index, N) else 1
        w = BITS(index, N-3, N-1)
        t = sz // 8
        A  = w * t # width of the natural units field
        n  = BITS(index, 0, A-1) if A >= 1 else 0 # natural units (n)
        c  = BITS(index, A, N-4) if N-4 >= A else 0 # constant units (c)
        o  = (c + (n * self.PTRSZ)) # offset w/o sign
        so = o * s # signed final offset
        return so

    # ----------------------------------------------------------------------
    def op_reg(self, op, reg):
        op.type    = o_reg
        op.reg     = reg

    # ----------------------------------------------------------------------
    def op_disp(self, op, reg, d, direct):
        op.type    = o_displ
        op.phrase  = reg
        op.addr    = d if d else 0
        if not direct:
            op.specval |= self.FLo_INDIRECT
        else:
            op.specval &= ~self.FLo_INDIRECT
        op.specval |= self.FLo_SIGNED

    # ----------------------------------------------------------------------
    def decode_index_or_data(self, insn, sz, immed):
        bs = self.get_sz_to_bits(sz)
        d = self.next_data_value(insn, sz)
        if not immed:
            d = self.decode_index(d, bs)
        else:
            d = SIGNEXT(d, bs)
        return d

    # ----------------------------------------------------------------------
    def fill_op(self, insn, op, reg, direct, has_imm, immsz, dt = None, index_only = False):
        if direct and not has_imm:
            self.op_reg(op, reg)
        else:
            d = self.decode_index_or_data(insn, immsz, direct and not index_only) if has_imm else None
            self.op_disp(op, reg, d, direct)
        if dt:
            insn.Op1.dtype = dt

    # ----------------------------------------------------------------------
    def fill_op1(self, insn, opbyte, has_imm, immsz, dt = None, index_only = False):
        op1_direct    = (opbyte & 0x08) == 0
        r1            = (opbyte & 0x07)
        self.fill_op(insn, insn.Op1, r1, op1_direct, has_imm, immsz, dt, index_only)

    # ----------------------------------------------------------------------
    def fill_op2(self, insn, opbyte, has_imm, immsz, dt = None, index_only = False):
        op2_direct    = (opbyte & 0x80) == 0
        r2            = (opbyte & 0x70) >> 4
        self.fill_op(insn, insn.Op2, r2, op2_direct, has_imm, immsz, dt, index_only)

    # ----------------------------------------------------------------------
    # Instruction decoding
    #

    # ----------------------------------------------------------------------
    def decode_RET(self, insn, opbyte):
        # No operands
        insn.Op1.type  = o_void
        # Consume the next byte, and it should be zero
        insn.get_next_byte()
        return True

    # ----------------------------------------------------------------------
    def decode_STORESP(self, insn, opbyte):
        # opbyte (byte0) has nothing meaningful (but the opcode itself)

        # get next byte
        opbyte = insn.get_next_byte()

        vm_reg = (opbyte & 0x70) >> 4
        gp_reg = (opbyte & 0x07)

        insn.Op1.type = insn.Op2.type = o_reg
        insn.Op1.dtype = insn.Op2.dtype = dt_qword

        insn.Op1.reg  = gp_reg
        insn.Op2.reg  = self.ireg_FLAGS + vm_reg

        return True

    # ----------------------------------------------------------------------
    def decode_LOADSP(self, insn, opbyte):
        # opbyte (byte0) has nothing meaningful (but the opcode itself)

        # get next byte
        opbyte = insn.get_next_byte()

        gp_reg = (opbyte & 0x70) >> 4
        vm_reg = (opbyte & 0x07)

        insn.Op1.type = insn.Op2.type = o_reg
        insn.Op1.dtype = insn.Op2.dtype = dt_qword

        insn.Op1.reg  = self.ireg_FLAGS + vm_reg
        insn.Op2.reg  = gp_reg

        return True

    # ----------------------------------------------------------------------
    def decode_BREAK(self, insn, opbyte):
        """
        stx=<BREAK [break code]>
        txt=<The BREAK instruction is used to perform special processing by the VM.>
        """
        insn.Op1.type  = o_imm
        insn.Op1.dtype  = dt_byte
        insn.Op1.value = insn.get_next_byte()
        return True

    # ----------------------------------------------------------------------
    def cmt_BREAK(self, insn):
        s = "Special processing by VM"
        if insn.Op1.value == 0:
            s += ": runaway program break (null/bad opcode)"
        elif insn.Op1.value == 1:
            s += ": get virtual machine version in R7"
        elif insn.Op1.value == 3:
            s += ": debug breakpoint"
        elif insn.Op1.value == 4:
            s += ": system call (ignored)"
        elif insn.Op1.value == 5:
            s += ": create thunk (thunk pointer in R7)"
        elif insn.Op1.value == 6:
            s += ": set compiler version in R7"
        else:
            s += ": unknown break code"
        return s

    # ----------------------------------------------------------------------
    def decode_PUSH(self, insn, opbyte):
        """
        PUSH[32|64] {@}R1 {Index16|Immed16}
        PUSHn       {@}R1 {Index16|Immed16}
        """
        have_data     = (opbyte & 0x80) != 0
        is_n          = (opbyte & ~0xC0) in [0x35, 0x36]        # PUSHn, POPn
        if is_n:
          dt = self.native_dt()
          insn.auxpref = 0
        else:
          op_32 = (opbyte & 0x40) == 0
          dt = dt_dword if op_32 else dt_qword
          insn.auxpref = self.FLa_32 if op_32 else self.FLa_64

        opbyte = insn.get_next_byte()
        self.fill_op1(insn, opbyte, have_data, self.IMMDATA_16, dt)
        return True

    # ----------------------------------------------------------------------
    def decode_JMP(self, insn, opbyte):
        """
        stx=<JMP32{cs|cc} {@}R1 {Immed32|Index32}>
        stx=<JMP64{cs|cc} Immed64>
        """
        have_data     = (opbyte & 0x80) != 0
        jmp_32        = (opbyte & 0x40) == 0

        opbyte        = insn.get_next_byte()
        conditional   = (opbyte & 0x80) != 0
        cs            = (opbyte & 0x40) != 0
        abs_jmp       = (opbyte & 0x10) == 0
        op1_direct    = (opbyte & 0x08) == 0
        r1            = (opbyte & 0x07)

        if jmp_32:
            # Indirect and no data specified?
            if not op1_direct and not have_data:
                return False

            self.fill_op1(insn, opbyte, have_data, self.IMMDATA_32, dt_dword)
            if insn.Op1.reg == 0:
                if op1_direct:
                    insn.Op1.type = o_near
                else:
                    insn.Op1.type = o_mem
        else:
            if not have_data:
                return False
            insn.Op1.type  = o_near
            insn.Op1.dtype  = dt_qword
            insn.Op1.addr  = insn.get_next_qword()

        if not abs_jmp:
            # PATCH:
            # insn.Op1.addr += insn.ea + insn.size
            insn.Op1.addr = add_ea(insn.ea, insn.size, insn.Op1.addr)

        fl = self.FLa_32 if jmp_32 else self.FLa_64
        if conditional:
            fl |= self.FLa_CS if cs else self.FLa_NCS
        insn.auxpref = fl

        return True

    # ----------------------------------------------------------------------
    def cmt_JMP(self, insn):
        s = "Jump to address"
        if insn.auxpref & self.FLa_CS:
            s += " if condition is true"
        elif insn.auxpref & self.FLa_NCS:
            s += " if condition is false"
        else:
            s += " unconditionally"
        return s

    # ----------------------------------------------------------------------
    def decode_JMP8(self, insn, opbyte):
        """
        stx=<JMP8{cs|cc} Immed8>
        """
        conditional   = (opbyte & 0x80) != 0
        cs            = (opbyte & 0x40) != 0
        insn.Op1.type = o_near
        insn.Op1.dtype = dt_byte
        addr               = insn.get_next_byte()
        insn.Op1.addr  = (SIGNEXT(addr, 8) * 2) + insn.size + insn.ea

        if conditional:
            insn.auxpref = self.FLa_CS if cs else self.FLa_NCS

        return True

    # ----------------------------------------------------------------------
    def decode_MOVI(self, insn, opbyte):
        """
        MOVI[b|w|d|q][w|d|q] {@}R1 {Index16}, Immed16|32|64
        MOVIn[w|d|q]         {@}R1 {Index16}, Index16|32|64

        First character specifies the width of the move and is taken from opcode
        Second character specifies the immediate data size and is taken from the opbyte
        """
        imm_sz   = (opbyte & 0xC0) >> 6
        opcode   = (opbyte & ~0xC0)
        is_MOVIn = opcode == 0x38

        # Reserved and should not be 0
        if imm_sz == 0:
            return False

        # take byte 1
        opbyte = insn.get_next_byte()

        # Bit 7 is reserved and should be 0
        if opbyte & 0x80 != 0:
            return False

        have_idx = (opbyte & 0x40) != 0
        move_sz  = (opbyte & 0x30) >> 4
        direct   = (opbyte & 0x08) == 0
        r1       = (opbyte & 0x07)

        # Cannot have an index with a direct register
        if have_idx and direct:
            return False

        dt = self.native_dt() if is_MOVIn else self.get_data_dt(move_sz)
        self.fill_op1(insn, opbyte, have_idx, self.IMMDATA_16, dt)

        insn.Op2.type = o_imm
        insn.Op2.dtype = self.get_data_dt(imm_sz)
        v = self.decode_index_or_data(insn, imm_sz, not is_MOVIn)
        if imm_sz == self.IMMDATA_64:
            # PATCH: 64bit! WTF!
            # insn.Op2.value = int(SIGNEXT(v & 0xFFFFFFFFL, 32))
            # insn.Op2.addr = int(v >> 32)
            insn.Op2.value = v
        else:
            insn.Op2.value = v
        # save imm size and signal that op1 is defined in first operand
        insn.auxpref = self.get_data_width_fl(imm_sz)
        if not is_MOVIn:
            insn.auxpref |= self.FLa_OP1
            insn.Op1.specval |= self.get_data_width_fl(move_sz)

        return True

    # ----------------------------------------------------------------------
    def decode_MOVREL(self, insn, opbyte):
        """
        MOVREL[w|d|q] {@}R1 {Index16}, Immed16|32|64
        """

        imm_sz = (opbyte & 0xC0) >> 6

        # Reserved and should not be 0
        if imm_sz == 0:
            return False

        # take byte 1
        opbyte = insn.get_next_byte()

        # Bits 7 is reserved and should be 0
        # Bits 4 and 5 are supposed to be 0 too, except in real programs they aren't!
        if (opbyte & 0x80) != 0:
            return False

        have_idx = (opbyte & 0x40) != 0
        direct   = (opbyte & 0x08) == 0
        r1       = (opbyte & 0x07)

        # Cannot have an index with a direct register
        if have_idx and direct:
            return False

        self.fill_op1(insn, opbyte, have_idx, self.IMMDATA_16, self.get_data_dt(imm_sz))
        insn.Op1.specval = self.get_data_width_fl(imm_sz)
        insn.Op2.type   = o_mem
        insn.Op2.dtype   = self.get_data_dt(imm_sz)
        insn.Op2.addr   = self.next_data_value(insn, imm_sz) + insn.size + insn.ea

        # save imm size
        insn.auxpref   = self.get_data_width_fl(imm_sz)

        return True

    # ----------------------------------------------------------------------
    def decode_MOV(self, insn, opbyte):
        """
        MOV[b|w|d|q]{w|d} {@}R1 {Index16|32}, {@}R2 {Index16|32}
        MOVn{w|d}         {@}R1 {Index16|32}, {@}R2 {Index16|32}
        MOVqq             {@}R1 {Index64},    {@}R2 {Index64}
        """
        have_idx1 = (opbyte & 0x80) != 0
        have_idx2 = (opbyte & 0x40) != 0
        opcode    = (opbyte & ~0xC0)

        # opcode: data move size, index size
        m = {
                0x1D: (dt_byte,  self.IMMDATA_16), #MOVbw
                0x1E: (dt_word,  self.IMMDATA_16), #MOVww
                0x1F: (dt_dword, self.IMMDATA_16), #MOVdw
                0x20: (dt_qword, self.IMMDATA_16), #MOVqw
                0x21: (dt_byte,  self.IMMDATA_32), #MOVbd
                0x22: (dt_word,  self.IMMDATA_32), #MOVwd
                0x23: (dt_dword, self.IMMDATA_32), #MOVdd
                0x24: (dt_qword, self.IMMDATA_32), #MOVqd
                0x28: (dt_qword, self.IMMDATA_64), #MOVqq
                0x32: (self.native_dt(), self.IMMDATA_16), #MOVnw
                0x33: (self.native_dt(), self.IMMDATA_32), #MOVnd
            }

        dt, idx_sz = m[opcode]
        # get byte1
        opbyte = insn.get_next_byte()
        self.fill_op1(insn, opbyte, have_idx1, idx_sz, dt, True)
        self.fill_op2(insn, opbyte, have_idx2, idx_sz, dt, True)

        return True

    # ----------------------------------------------------------------------
    def decode_CMP(self, insn, opbyte):
        """
        CMP[32|64][eq|lte|gte|ulte|ugte] R1, {@}R2 {Index16|Immed16}
        """
        have_data  = (opbyte & 0x80) != 0
        cmp_32     = (opbyte & 0x40) == 0
        opcode     = (opbyte & ~0xC0)

        opbyte     = insn.get_next_byte()

        if opbyte & 0x08: # operand 1 indirect is not supported
            return False

        r1         = (opbyte & 0x07)
        dt = dt_dword if cmp_32 else dt_qword
        insn.Op1.type   = o_reg
        insn.Op1.reg    = r1
        insn.Op1.dtype   = dt

        self.fill_op2(insn, opbyte, have_data, self.IMMDATA_16, dt)

        insn.auxpref = self.FLa_32 if cmp_32 else self.FLa_64
        self.set_cmp(insn, opcode - 0x05)
        return True

    # ----------------------------------------------------------------------
    def cmt_CMP(self, insn):
        s = "Compare if "
        t = insn.auxpref & self.FLa_CMPMASK
        s += { self.FLa_CMPeq: "equal",
                 self.FLa_CMPlte: "less than or equal (signed)",
                 self.FLa_CMPgte: "greater than or equal (signed)",
                 self.FLa_CMPulte: "less than or equal (unsigned)",
                 self.FLa_CMPugte: "greater than or equal (unsigned)" } [t]
        return s

    # ----------------------------------------------------------------------
    def decode_CMPI(self, insn, opbyte):
        """
        CMPI[32|64]{w|d}[eq|lte|gte|ulte|ugte] {@}R1 {Index16}, Immed16|Immed32
        """
        imm_sz    = self.IMMDATA_16 if (opbyte & 0x80) == 0 else self.IMMDATA_32
        cmp_32    = (opbyte & 0x40) == 0
        opcode    = (opbyte & ~0xC0)

        opbyte = insn.get_next_byte()
        have_idx   = (opbyte & 0x10) != 0
        dt = dt_dword if cmp_32 else dt_qword
        self.fill_op1(insn, opbyte, have_idx, self.IMMDATA_16, dt)
        insn.Op2.type  = o_imm
        insn.Op2.value = self.next_data_value(insn, imm_sz)
        insn.Op2.dtype  = dt

        insn.auxpref = (self.FLa_32 if cmp_32 else self.FLa_64) | self.get_data_width_fl(imm_sz)
        self.set_cmp(insn, opcode - 0x2D)
        return True

    # ----------------------------------------------------------------------
    def decode_CALL(self, insn, opbyte):
        """
        stx=<CALL32{EX}{a} {@}R1 {Immed32|Index32}>
        stx=<CALL64{EX}{a} Immed64>
        """
        have_data  = (opbyte & 0x80) != 0
        call_32    = (opbyte & 0x40) == 0

        opbyte     = insn.get_next_byte()

        # Call to EBC or Native code
        ebc_call   = (opbyte & 0x20) == 0
        # Absolute or Relative address
        abs_addr   = (opbyte & 0x10) == 0
        # Op1 direct?
        op1_direct = (opbyte & 0x08) == 0
        r1         = (opbyte & 0x07)

        if call_32:
            self.fill_op1(insn, opbyte, have_data, self.IMMDATA_32, dt_dword)
            if have_data and insn.Op1.reg == 0:
                insn.Op1.type = o_near
                if not abs_addr:
                    # PATCH:
                    # insn.Op1.addr += insn.ea + insn.size
                    insn.Op1.addr = add_ea(insn.ea, insn.size, insn.Op1.addr)
        # 64-bit
        else:
            insn.Op1.type = o_near
            insn.Op1.dtype = dt_qword
            insn.Op1.addr = self.next_data_value(insn, self.IMMDATA_64) # Get 64-bit value

        fl  = self.FLa_EXTERN if not ebc_call else 0
        fl |= self.FLa_32 if call_32 else self.FLa_64
        if abs_addr:
            fl |= self.FLa_ABS
        insn.auxpref = fl

        return True

    # ----------------------------------------------------------------------
    def cmt_CALL(self, insn):
        if insn.auxpref & self.FLa_EXTERN:
            s = "Call an external subroutine (via thunk)"
        else:
            s = "Call a subroutine"
        if insn.auxpref & self.FLa_ABS:
            s += " [absolute addressing]"
        return s

    # ----------------------------------------------------------------------
    def decode_BINOP_FORM1(self, insn, opbyte):
        """
        op[32|64] {@}R1, {@}R2 {Index16|Immed16}
        """
        have_data  = (opbyte & 0x80) != 0
        op_32      = (opbyte & 0x40) == 0
        opcode     = (opbyte & ~0xC0)

        opbyte     = insn.get_next_byte()

        op2_direct = (opbyte & 0x80) == 0
        op1_direct = (opbyte & 0x08) == 0
        r1         = (opbyte & 0x07)
        r2         = (opbyte & 0x70) >> 4
        dt         = dt_dword if op_32 else dt_qword

        self.fill_op1(insn, opbyte, False, 0, dt)
        self.fill_op2(insn, opbyte, have_data, self.IMMDATA_16, dt)
        insn.auxpref = self.FLa_32 if op_32 else self.FLa_64

        return True

    # ----------------------------------------------------------------------
    def decode_MOVSN(self, insn, opbyte):
        """
        MOVsn{w} {@}R1 {Index16}, {@}R2 {Index16|Immed16}
        MOVsn{d} {@}R1 {Index32}, {@}R2 {Index32|Immed32}
        """
        have_idx1  = (opbyte & 0x80) != 0
        have_idx2  = (opbyte & 0x40) != 0
        opcode     = (opbyte & ~0xC0)

        if opcode == 0x25:
            idx_sz = self.IMMDATA_16
        elif opcode == 0x26:
            idx_sz = self.IMMDATA_32
        else:
            return False

        opbyte = insn.get_next_byte()
        self.fill_op1(insn, opbyte, have_idx1, idx_sz, self.native_dt())
        self.fill_op2(insn, opbyte, have_idx2, idx_sz, self.native_dt())

        return True

    # ----------------------------------------------------------------------
    # Processor module callbacks
    #
    # ----------------------------------------------------------------------
    def notify_get_frame_retsize(self, func_ea):
        """
        Get size of function return address in bytes
        for EBC it's 8 bytes of the actual return address
        plus 8 bytes of the saved frame address
        """
        return 16

    # ----------------------------------------------------------------------
    def notify_get_autocmt(self, insn):
        """
        Get instruction comment. 'insn' describes the instruction in question
        @return: None or the comment string
        """
        if 'cmt' in self.instruc[insn.itype]:
          return self.instruc[insn.itype]['cmt'](insn)

    # ----------------------------------------------------------------------
    def notify_can_have_type(self, op):
        """
        Can the operand have a type as offset, segment, decimal, etc.
        (for example, a register AX can't have a type, meaning that the user can't
        change its representation. see bytes.hpp for information about types and flags)
        Returns: bool
        """
        return op.type in [o_imm, o_displ, o_mem]

    # ----------------------------------------------------------------------
    def notify_is_align_insn(self, ea):
        """
        Is the instruction created only for alignment purposes?
        Returns: number of bytes in the instruction
        """
        return 2 if get_word(ea) == 0 else 0

    # ----------------------------------------------------------------------
    def notify_newfile(self, filename):
        self.set_ptr_size()

    # ----------------------------------------------------------------------
    def notify_oldfile(self, filename):
        self.set_ptr_size()

    # ----------------------------------------------------------------------
    def notify_out_header(self, ctx):
        """function to produce start of disassembled text"""
        ctx.out_line("; natural unit size: %d bits" % (self.PTRSZ*8))
        ctx.flush_outbuf(0)

    # ----------------------------------------------------------------------
    def notify_may_be_func(self, insn, state):
        """
        can a function start here?
        the instruction is in 'insn'
          arg: state -- autoanalysis phase
            state == 0: creating functions
                  == 1: creating chunks
          returns: probability 0..100
        """
        if is_reg(insn.Op1, self.ireg_SP) and insn.Op2.type == o_displ and\
            insn.Op2.phrase == self.ireg_SP and (insn.Op2.specval & self.FLo_INDIRECT) == 0:
            # mov SP, SP+delta
            if SIGNEXT(insn.Op2.addr, self.PTRSZ*8) < 0:
                return 100
            else:
                return 0
        return 10

    # ----------------------------------------------------------------------
    def check_thunk(self, addr):
        """
        Check for EBC thunk at addr
        dd fnaddr - (addr+4), 0, 0, 0
        """
        delta = get_dword(addr)
        fnaddr = (delta + addr + 4) & 0xFFFFFFFF
        if is_off(get_flags(addr), 0):
            # already an offset
            if ida_offset.get_offbase(addr, 0) == addr + 4:
                return fnaddr
            else:
                return None
        # should be followed by three zeroes
        if delta == 0 or get_dword(addr+4) != 0 or\
           get_dword(addr+8) != 0 or get_dword(addr+12) != 0:
            return None
        if segtype(fnaddr) == SEG_CODE:
            # looks good, create the offset
            create_dword(addr)
            if ida_offset.op_offset(addr, 0, REF_OFF32|REFINFO_NOBASE, BADADDR, addr + 4):
                return fnaddr
            else:
                return None

    # ----------------------------------------------------------------------
    def handle_operand(self, insn, op, isRead):
        F = get_flags(insn.ea)
        is_offs   = is_off(F, op.n)
        dref_flag = dr_R if isRead else dr_W
        def_arg   = is_defarg(F, op.n)
        optype    = op.type

        # create code xrefs
        if optype == o_imm:
            if is_offs:
                insn.add_off_drefs(op, dr_O, 0)
        # create data xrefs
        elif optype == o_displ:
            # reg + delta
            if is_offs:
                insn.add_off_drefs(op, dref_flag, OOF_ADDR)
            elif may_create_stkvars() and not def_arg and op.reg == self.ireg_SP:
                # ignore prolog/epilog
                # MOVqw         SP, SP+delta
                if is_reg(insn.Op1, self.ireg_SP):
                    pass
                else:
                    pfn = get_func(insn.ea)
                    # [SP+var_x] (indirect)
                    # SP+var_x   (direct)
                    flag = STKVAR_VALID_SIZE if (op.specval & self.FLo_INDIRECT) else 0
                    if pfn and insn.create_stkvar(op, op.addr, flag):
                        op_stkvar(insn.ea, op.n)
        elif optype == o_mem:
            if insn.itype == self.itype_MOVREL:
                dref_flag = dr_O
                self.check_thunk(op.addr)
            else:
                insn.create_op_data(op.addr, op)
            insn.add_dref(op.addr, op.offb, dref_flag)
        elif optype == o_near:
            itype = insn.itype
            if itype == self.itype_CALL:
                fl = fl_CN
            else:
                fl = fl_JN
            insn.add_cref(op.addr, op.offb, fl)

    # ----------------------------------------------------------------------
    def add_stkpnt(self, insn, pfn, v):
        if pfn:
            end = insn.ea + insn.size
            if not is_fixed_spd(end):
                ida_frame.add_auto_stkpnt(pfn, end, v)

    # ----------------------------------------------------------------------
    def trace_sp(self, insn):
        """
        Trace the value of the SP and create an SP change point if the current
        instruction modifies the SP.
        """
        pfn = get_func(insn.ea)
        if not pfn:
            return
        if is_reg(insn.Op1, self.ireg_SP) and insn.itype in [self.itype_MOVbw, self.itype_MOVww,
                                              self.itype_MOVdw, self.itype_MOVqw, self.itype_MOVbd,
                                              self.itype_MOVwd, self.itype_MOVdd, self.itype_MOVqd,
                                              self.itype_MOVsnw, self.itype_MOVsnd, self.itype_MOVqq]:
            # MOVqw         SP, SP-0x30
            # MOVqw         SP, SP+0x30
            if insn.Op2.type == o_displ and insn.Op2.phrase == self.ireg_SP and (insn.Op2.specval & self.FLo_INDIRECT) == 0:
                spofs = SIGNEXT(insn.Op2.addr, self.PTRSZ*8)
                self.add_stkpnt(insn, pfn, spofs)
        elif insn.itype in [self.itype_PUSH, self.itype_PUSHn]:
            # spofs = dt_to_bits(insn.Op1.dtype) // 8
            spofs = self.dt_to_bits(insn.Op1.dtype) // 8
            self.add_stkpnt(insn, pfn, -spofs)
        elif insn.itype in [self.itype_POP, self.itype_POPn]:
            # spofs = dt_to_bits(insn.Op1.dtype) // 8
            spofs = self.dt_to_bits(insn.Op1.dtype) // 8
            self.add_stkpnt(insn, pfn, spofs)

    # ----------------------------------------------------------------------
    def notify_emu(self, insn):
        """
        Emulate instruction, create cross-references, plan to analyze
        subsequent instructions, modify flags etc. Upon entrance to this function
        all information about the instruction is in 'insn' structure.
        If zero is returned, the kernel will delete the instruction.
        """
        aux = self.get_auxpref(insn)
        Feature = insn.get_canon_feature()

        if Feature & CF_USE1:
            self.handle_operand(insn, insn.Op1, 1)
        if Feature & CF_CHG1:
            self.handle_operand(insn, insn.Op1, 0)
        if Feature & CF_USE2:
            self.handle_operand(insn, insn.Op2, 1)
        if Feature & CF_CHG2:
            self.handle_operand(insn, insn.Op2, 0)
        if Feature & CF_JUMP:
            remember_problem(PR_JUMP, insn.ea)

        # is it an unconditional jump?
        uncond_jmp = insn.itype in [self.itype_JMP8, self.itype_JMP] and (aux & (self.FLa_NCS|self.FLa_CS)) == 0

        # add flow
        flow = (Feature & CF_STOP == 0) and not uncond_jmp
        if flow:
            add_cref(insn.ea, insn.ea + insn.size, fl_F)

        # trace the stack pointer if:
        #   - it is the second analysis pass
        #   - the stack pointer tracing is allowed
        if may_trace_sp():
            if flow:
                self.trace_sp(insn) # trace modification of SP register
            else:
                recalc_spd(insn.ea) # recalculate SP register for the next insn

        return 1

    # ----------------------------------------------------------------------
    def notify_out_operand(self, ctx, op):
        """
        Generate text representation of an instructon operand.
        This function shouldn't change the database, flags or anything else.
        All these actions should be performed only by u_emu() function.
        The output text is placed in the output buffer initialized with init_output_buffer()
        This function uses out_...() functions from ua.hpp to generate the operand text
        Returns: 1-ok, 0-operand is hidden.
        """
        optype = op.type
        fl     = op.specval
        signed = OOF_SIGNED if fl & self.FLo_SIGNED != 0 else 0
        def_arg = is_defarg(get_flags(ctx.insn.ea), op.n)

        if optype == o_reg:
            ctx.out_register(self.reg_names[op.reg])

        elif optype == o_imm:
            # for immediate loads, use the transfer width (type of first operand)
            if op.n == 1:
                width = self.dt_to_width(ctx.insn.Op1.dtype)
            else:
                width = OOFW_32 if self.PTRSZ == 4 else OOFW_64
            ctx.out_value(op, OOFW_IMM | signed | width)

        elif optype in [o_near, o_mem]:
            r = ctx.out_name_expr(op, op.addr, BADADDR)
            if not r:
                ctx.out_tagon(COLOR_ERROR)
                ctx.out_btoa(op.addr, 16)
                ctx.out_tagoff(COLOR_ERROR)
                remember_problem(PR_NONAME, ctx.insn.ea)

        elif optype == o_displ:
            indirect = fl & self.FLo_INDIRECT != 0
            if indirect:
                ctx.out_symbol('[')

            ctx.out_register(self.reg_names[op.reg])

            if op.addr != 0 or def_arg:
                ctx.out_value(op, OOF_ADDR | (OOFW_32 if self.PTRSZ == 4 else OOFW_64) | signed | OOFS_NEEDSIGN)

            if indirect:
                ctx.out_symbol(']')
        else:
            return False

        return True

    # ----------------------------------------------------------------------
    # Generate the instruction mnemonics
    def out_mnem(self, ctx):
        # Init output buffer

        postfix = ""

        # First display size of first operand if it exists
        if ctx.insn.auxpref & self.FLa_OP1 != 0:
            postfix += self.fl_to_str(ctx.insn.Op1.specval)

        # Display opertion size
        if ctx.insn.auxpref & self.FLa_32:
            postfix += "32"
        elif ctx.insn.auxpref & self.FLa_64:
            postfix += "64"

        # Display if local or extern CALL
        if ctx.insn.auxpref & self.FLa_EXTERN:
            postfix += "EX"

        # Display if absolute call
        if ctx.insn.auxpref & self.FLa_ABS:
            postfix += "a"

        # Display size of instruction
        if ctx.insn.auxpref & (self.FL_B | self.FL_W | self.FL_D | self.FL_Q) != 0:
            postfix += self.fl_to_str(ctx.insn.auxpref)

        # Display JMP condition
        if ctx.insn.auxpref & self.FLa_CS:
            postfix += "cs"
        elif ctx.insn.auxpref & self.FLa_NCS:
            postfix += "cc"

        # Display CMP condition
        if ctx.insn.auxpref & self.FLa_CMPMASK:
            postfix += self.get_cmp(ctx.insn)

        ctx.out_mnem(12, postfix)
    # ----------------------------------------------------------------------
    # Generate text representation of an instruction in 'ctx.insn' structure.
    # This function shouldn't change the database, flags or anything else.
    # All these actions should be performed only by u_emu() function.
    def notify_out_insn(self, ctx):

        ctx.out_mnemonic()

        ctx.out_one_operand(0)

        for i in xrange(1, 3):
            op = ctx.insn[i]

            if op.type == o_void:
                break

            ctx.out_symbol(',')
            ctx.out_char(' ')
            ctx.out_one_operand(i)

        if ctx.insn.itype == self.itype_MOVREL:
            fnaddr = self.check_thunk(ctx.insn.Op2.addr)
            if fnaddr != None:
                nm = get_ea_name(fnaddr, ida_name.GN_VISIBLE)
                if nm:
                    ctx.out_line("; Thunk to " + nm, COLOR_AUTOCMT)

        ctx.set_gen_cmt()
        ctx.flush_outbuf()

    # ----------------------------------------------------------------------
    def notify_ana(self, insn):
        """
        Decodes an instruction into insn
        """
        # take opcode byte
        b = insn.get_next_byte()

        # the 6bit opcode
        opcode = b & 0x3F

        # opcode supported?
        try:
            ins = self.itable[opcode]
            # set default itype
            insn.itype = getattr(self, 'itype_' + ins.name)
        except:
            return 0
        # call the decoder
        return insn.size if ins.d(insn, b) else 0

    # ----------------------------------------------------------------------
    def init_instructions(self):
        class idef:
            """
            Internal class that describes an instruction by:
            - instruction name
            - instruction decoding routine
            - canonical flags used by IDA
            """
            def __init__(self, name, cf, d, cmt = None):
                self.name = name
                self.cf  = cf
                self.d   = d
                self.cmt = cmt

        #
        # Instructions table (w/ pointer to decoder)
        #
        self.itable = {
            0x00: idef(name='BREAK',        d=self.decode_BREAK, cf = CF_USE1, cmt = self.cmt_BREAK),

            0x01: idef(name='JMP',          d=self.decode_JMP,  cf = CF_USE1 | CF_JUMP, cmt = self.cmt_JMP),
            0x02: idef(name='JMP8',         d=self.decode_JMP8, cf = CF_USE1 | CF_JUMP, cmt = self.cmt_JMP),

            0x03: idef(name='CALL',         d=self.decode_CALL, cf = CF_USE1 | CF_CALL, cmt = self.cmt_CALL),
            0x04: idef(name='RET',          d=self.decode_RET, cf = CF_STOP,            cmt = lambda insn: "Return from subroutine" ),
            0x05: idef(name='CMP',          d=self.decode_CMP, cf = CF_USE1 | CF_USE2,  cmt = self.cmt_CMP),
            0x06: idef(name='CMP',          d=self.decode_CMP, cf = CF_USE1 | CF_USE2,  cmt = self.cmt_CMP),
            0x07: idef(name='CMP',          d=self.decode_CMP, cf = CF_USE1 | CF_USE2,  cmt = self.cmt_CMP),
            0x08: idef(name='CMP',          d=self.decode_CMP, cf = CF_USE1 | CF_USE2,  cmt = self.cmt_CMP),
            0x09: idef(name='CMP',          d=self.decode_CMP, cf = CF_USE1 | CF_USE2,  cmt = self.cmt_CMP),

            0x0A: idef(name='NOT',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 = ~Op2" ),
            0x0B: idef(name='NEG',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 = -Op2" ),
            0x0C: idef(name='ADD',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 += Op2" ),
            0x0D: idef(name='SUB',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 -= Op2" ),
            0x0E: idef(name='MUL',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 *= Op2 (signed multiply)" ),
            0x0F: idef(name='MULU',         d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 *= Op2 (unsigned multiply)" ),
            0x10: idef(name='DIV',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 /= Op2 (signed division)" ),
            0x11: idef(name='DIVU',         d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 /= Op2 (unsigned division)" ),
            0x12: idef(name='MOD',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 %= Op2 (signed modulo)" ),
            0x13: idef(name='MODU',         d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 %= Op2 (unsigned modulo)" ),
            0x14: idef(name='AND',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 &= Op2" ),
            0x15: idef(name='OR',           d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 |= Op2" ),
            0x16: idef(name='XOR',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Op1 ^= Op2" ),
            0x17: idef(name='SHL',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1 | CF_SHFT, cmt = lambda insn: "Op1 <<= Op2" ),
            0x18: idef(name='SHR',          d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1 | CF_SHFT, cmt = lambda insn: "Op1 >>= Op2 (unsigned shift)" ),
            0x19: idef(name='ASHR',         d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1 | CF_SHFT, cmt = lambda insn: "Op1 >>= Op2 (signed shift)" ),

            0x1A: idef(name='EXTNDB',       d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Sign-extend a byte value" ),
            0x1B: idef(name='EXTNDW',       d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Sign-extend a word value" ),
            0x1C: idef(name='EXTNDD',       d=self.decode_BINOP_FORM1, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Sign-extend a dword value" ),

            0x1D: idef(name='MOVbw',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move byte"  ),
            0x1E: idef(name='MOVww',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move word"  ),
            0x1F: idef(name='MOVdw',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move dword" ),
            0x20: idef(name='MOVqw',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move qword" ),
            0x21: idef(name='MOVbd',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move byte"  ),
            0x22: idef(name='MOVwd',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move word"  ),
            0x23: idef(name='MOVdd',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move dword" ),
            0x24: idef(name='MOVqd',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move qword" ),

            0x25: idef(name='MOVsnw',       d=self.decode_MOVSN, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move signed natural value"),
            0x26: idef(name='MOVsnd',       d=self.decode_MOVSN, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move signed natural value"),

            #  0x27: reserved

            0x28: idef(name='MOVqq',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move qword" ),

            0x29: idef(name='LOADSP',       d=self.decode_LOADSP, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Load a VM dedicated register from a general-purpose register"),
            0x2A: idef(name='STORESP',      d=self.decode_STORESP, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Store a VM dedicated register into a general-purpose register"),

            # PUSH/POP
            0x2B: idef(name='PUSH',         d=self.decode_PUSH, cf = CF_USE1, cmt = lambda insn: "Push value on the stack" ),
            0x2C: idef(name='POP',          d=self.decode_PUSH, cf = CF_USE1, cmt = lambda insn: "Pop value from the stack" ),

            # CMPI
            0x2D: idef(name='CMPI',         d=self.decode_CMPI, cf = CF_USE1 | CF_USE2, cmt = self.cmt_CMP),
            0x2E: idef(name='CMPI',         d=self.decode_CMPI, cf = CF_USE1 | CF_USE2, cmt = self.cmt_CMP),
            0x2F: idef(name='CMPI',         d=self.decode_CMPI, cf = CF_USE1 | CF_USE2, cmt = self.cmt_CMP),
            0x30: idef(name='CMPI',         d=self.decode_CMPI, cf = CF_USE1 | CF_USE2, cmt = self.cmt_CMP),
            0x31: idef(name='CMPI',         d=self.decode_CMPI, cf = CF_USE1 | CF_USE2, cmt = self.cmt_CMP),

            0x32: idef(name='MOVnw',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move unsigned natural value"),
            0x33: idef(name='MOVnd',        d=self.decode_MOV, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move unsigned natural value"),

            #  0x34: reserved

            # PUSHn/POPn
            0x35: idef(name='PUSHn',        d=self.decode_PUSH, cf = CF_USE1, cmt = lambda insn: "Push natural value on the stack" ),
            0x36: idef(name='POPn',         d=self.decode_PUSH, cf = CF_USE1, cmt = lambda insn: "Pop natural value from the stack" ),

            0x37: idef(name='MOVI',         d=self.decode_MOVI, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move immediate value"),
            0x38: idef(name='MOVIn',        d=self.decode_MOVI, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Move immediate value"),

            0x39: idef(name='MOVREL',       d=self.decode_MOVREL, cf = CF_USE1 | CF_USE2 | CF_CHG1, cmt = lambda insn: "Load IP-relative address")
            #  0x3A: reserved
            #  0x3B: reserved
            #  0x3C: reserved
            #  0x3D: reserved
            #  0x3E: reserved
            #  0x3F: reserved
        }

        # Now create an instruction table compatible with IDA processor module requirements
        Instructions = []
        i = 0
        for x in self.itable.values():
            d = dict(name=x.name, feature=x.cf)
            if x.cmt != None:
                d['cmt'] = x.cmt
            Instructions.append(d)
            setattr(self, 'itype_' + x.name, i)
            i += 1

        # icode of the last instruction + 1
        self.instruc_end = len(Instructions) + 1

        # Array of instructions
        self.instruc = Instructions

        # Icode of return instruction. It is ok to give any of possible return
        # instructions
        self.icode_return = self.itype_RET

    # ----------------------------------------------------------------------
    def init_registers(self):
        """This function parses the register table and creates corresponding ireg_XXX constants"""

        # Registers definition
        self.reg_names = [
            # General purpose registers
            "SP", # aka R0
            "R1",
            "R2",
            "R3",
            "R4",
            "R5",
            "R6",
            "R7",
            # VM registers
            "FLAGS", # 0
            "IP",    # 1
            "VM2",
            "VM3",
            "VM4",
            "VM5",
            "VM6",
            "VM7",
            # Fake segment registers
            "CS",
            "DS"
        ]

        # Create the ireg_XXXX constants
        for i in xrange(len(self.reg_names)):
            setattr(self, 'ireg_' + self.reg_names[i], i)

        # Segment register information (use virtual CS and DS registers if your
        # processor doesn't have segment registers):
        self.reg_first_sreg = self.ireg_CS
        self.reg_last_sreg  = self.ireg_DS

        # number of CS register
        self.reg_code_sreg = self.ireg_CS

        # number of DS register
        self.reg_data_sreg = self.ireg_DS

    # ----------------------------------------------------------------------
    def __init__(self):
        processor_t.__init__(self)
        self.PTRSZ = 4 # Assume PTRSZ = 4 by default
        self.init_instructions()
        self.init_registers()

# ----------------------------------------------------------------------
def PROCESSOR_ENTRY():
    return ebc_processor_t()
