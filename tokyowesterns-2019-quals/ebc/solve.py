from __future__ import print_function

# MOVqw       R1, [SP+arg_0]    ; Move qword

# MOVqw       R1, [SP+arg_0]            ; Move qword
stage1 = """
MOVIqq      R2, 0xBB5D75B895F628F2    ; Move immediate value
MOVIqq      R3, 0xD30A286EC6737B8B    ; Move immediate value
MOVIqq      R4, 0x1BFA530D5D685155    ; Move immediate value
MOVIqq      R5, 0xA29C4DB3D2083355    ; Move immediate value
MOVIqq      R6, 0xAB0A0D83B2FF5134    ; Move immediate value
MOVIqq      R7, 0x67518339E369AB3D    ; Move immediate value
ADD64       R1, R6                    ; Op1 += Op2
SUB64       R1, R5                    ; Op1 -= Op2
MOVIqq      R7, 0xDA1298C4CBB452AE    ; Move immediate value
XOR64       R1, R7                    ; Op1 ^= Op2
SUB64       R1, R6                    ; Op1 -= Op2
XOR64       R1, R7                    ; Op1 ^= Op2
ADD64       R1, R2                    ; Op1 += Op2
SUB64       R1, R2                    ; Op1 -= Op2
MOVIqq      R3, 0x48F0E6421AC66DEA    ; Move immediate value
XOR64       R1, R7                    ; Op1 ^= Op2
SUB64       R1, R6                    ; Op1 -= Op2
XOR64       R1, R6                    ; Op1 ^= Op2
ADD64       R1, R5                    ; Op1 += Op2
SUB64       R1, R3                    ; Op1 -= Op2
ADD64       R1, R5                    ; Op1 += Op2
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R6, 0x4303F92241DD9A9F    ; Move immediate value
XOR64       R1, R7                    ; Op1 ^= Op2
SUB64       R1, R2                    ; Op1 -= Op2
MOVIqq      R5, 0xE0A9467740C7C159    ; Move immediate value
SUB64       R1, R4                    ; Op1 -= Op2
SUB64       R1, R7                    ; Op1 -= Op2
MOVIqq      R6, 0x58E8ABFC7618F5FD    ; Move immediate value
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R6, 0x310791BB36B87E69    ; Move immediate value
ADD64       R1, R5                    ; Op1 += Op2
NEG64       R1, R1                    ; Op1 = -Op2
SUB64       R1, R4                    ; Op1 -= Op2
MOVIqq      R6, 0xEDF86D309FF95CCA    ; Move immediate value
XOR64       R1, R6                    ; Op1 ^= Op2
SUB64       R1, R2                    ; Op1 -= Op2
ADD64       R1, R4                    ; Op1 += Op2
XOR64       R1, R3                    ; Op1 ^= Op2
MOVIqq      R4, 0x9483F54870A8211B    ; Move immediate value
XOR64       R1, R4                    ; Op1 ^= Op2
SUB64       R1, R6                    ; Op1 -= Op2
MOVIqq      R6, 0xB1AC56A275F53E2A    ; Move immediate value
SUB64       R1, R7                    ; Op1 -= Op2
MOVIqq      R5, 0xE885B64F981D1BAA    ; Move immediate value
XOR64       R1, R2                    ; Op1 ^= Op2
SUB64       R1, R3                    ; Op1 -= Op2
MOVIqq      R6, 0xD606E0B4D21B0CB     ; Move immediate value
ADD64       R1, R3                    ; Op1 += Op2
XOR64       R1, R5                    ; Op1 ^= Op2
MOVIqq      R7, 0x7F0B4C558F78A664    ; Move immediate value
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R7, 0x9D823B35BBA0CBD5    ; Move immediate value
XOR64       R1, R6                    ; Op1 ^= Op2
MOVIqq      R6, 0xA5D53BC4390AE888    ; Move immediate value
XOR64       R1, R6                    ; Op1 ^= Op2
MOVIqq      R6, 0xE858138103ED8FAF    ; Move immediate value
SUB64       R1, R7                    ; Op1 -= Op2
MOVIqq      R3, 0xE97AD106A47BFE3F    ; Move immediate value
SUB64       R1, R3                    ; Op1 -= Op2
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R6, 0x12E9831D31B56DA5    ; Move immediate value
NOT64       R1, R1                    ; Op1 = ~Op2
NEG64       R1, R1                    ; Op1 = -Op2
MOVIqq      R4, 0xEEEFF2448CDA8E87    ; Move immediate value
SUB64       R1, R7                    ; Op1 -= Op2
ADD64       R1, R7                    ; Op1 += Op2
MOVIqq      R7, 0xD9F6BCA7D86E01E0    ; Move immediate value
SUB64       R1, R4                    ; Op1 -= Op2
SUB64       R1, R6                    ; Op1 -= Op2
MOVIqq      R6, 0xCD07F7535FC427E8    ; Move immediate value
SUB64       R1, R4                    ; Op1 -= Op2
MOVIqq      R4, 0xDA77D7F1ACB7403E    ; Move immediate value
ADD64       R1, R4                    ; Op1 += Op2
MOVIqq      R5, 0x6AFAF64C28707959    ; Move immediate value
SUB64       R1, R7                    ; Op1 -= Op2
ADD64       R1, R4                    ; Op1 += Op2
MOVIqq      R7, 0xC1A11DFF8BF2B90F    ; Move immediate value
NEG64       R1, R1                    ; Op1 = -Op2
SUB64       R1, R2                    ; Op1 -= Op2
ADD64       R1, R6                    ; Op1 += Op2
MOVIqq      R6, 0x9764535895A1024F    ; Move immediate value
XOR64       R1, R3                    ; Op1 ^= Op2
NOT64       R1, R1                    ; Op1 = ~Op2
XOR64       R1, R5                    ; Op1 ^= Op2
ADD64       R1, R2                    ; Op1 += Op2
XOR64       R1, R7                    ; Op1 ^= Op2
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R5, 0x369320C5F4D932FD    ; Move immediate value
ADD64       R1, R5                    ; Op1 += Op2
SUB64       R1, R4                    ; Op1 -= Op2
MOVIqq      R2, 0x9EED7637CD5EAA26    ; Move immediate value
NEG64       R1, R1                    ; Op1 = -Op2
MOVIqq      R6, 0x7BFB015F62EC9678    ; Move immediate value
NOT64       R1, R1                    ; Op1 = ~Op2
NEG64       R1, R1                    ; Op1 = -Op2
ADD64       R1, R6                    ; Op1 += Op2
XOR64       R1, R3                    ; Op1 ^= Op2
MOVIqq      R6, 0x29C1FCF3B2FEFD09    ; Move immediate value
NOT64       R1, R1                    ; Op1 = ~Op2
MOVIqq      R3, 0x1FA7EF6F5A0A0ADD    ; Move immediate value
ADD64       R1, R2                    ; Op1 += Op2
SUB64       R1, R5                    ; Op1 -= Op2
MOVIqq      R7, 0xB69E2DBB5C40A5C7    ; Move immediate value
XOR64       R1, R5                    ; Op1 ^= Op2
NOT64       R1, R1                    ; Op1 = ~Op2
NEG64       R1, R1                    ; Op1 = -Op2
SUB64       R1, R7                    ; Op1 -= Op2
ADD64       R1, R3                    ; Op1 += Op2
XOR64       R1, R5                    ; Op1 ^= Op2
ADD64       R1, R2                    ; Op1 += Op2
MOVIqq      R6, 0x23CBAB5DEF58301D    ; Move immediate value
ADD64       R1, R4                    ; Op1 += Op2
SUB64       R1, R5                    ; Op1 -= Op2
XOR64       R1, R4                    ; Op1 ^= Op2
SUB64       R1, R5                    ; Op1 -= Op2
ADD64       R1, R5                    ; Op1 += Op2
SUB64       R1, R5                    ; Op1 -= Op2
SUB64       R1, R4                    ; Op1 -= Op2
NEG64       R1, R1                    ; Op1 = -Op2
MOVIqq      R2, 0x91594A52A4AAC9C5    ; Move immediate value
XOR64       R1, R3                    ; Op1 ^= Op2
MOVIqq      R3, 0xADAFA5F55917D2AF    ; Move immediate value
NEG64       R1, R1                    ; Op1 = -Op2
MOVIqq      R2, 0x8D1288746F13D07A    ; Move immediate value
ADD64       R1, R3                    ; Op1 += Op2
MOVIqq      R4, 0x1A333E9807D1B965    ; Move immediate value
XOR64       R1, R3                    ; Op1 ^= Op2
MOVIqq      R6, 0x3F4674F357E7F058    ; Move immediate value
SUB64       R1, R3                    ; Op1 -= Op2
MOVIqq      R3, 0xE90BE33165417B8C    ; Move immediate value
XOR64       R1, R4                    ; Op1 ^= Op2
MOVIqq      R5, 0x84850F19B7EE2086    ; Move immediate value
XOR64       R1, R6                    ; Op1 ^= Op2
ADD64       R1, R3                    ; Op1 += Op2
MOVIqq      R5, 0x7038AD525045D6CE    ; Move immediate value
XOR64       R1, R5                    ; Op1 ^= Op2
XOR64       R1, R4                    ; Op1 ^= Op2
ADD64       R1, R5                    ; Op1 += Op2
MOVIqq      R4, 0x703F95BED6E34A3A    ; Move immediate value
ADD64       R1, R2                    ; Op1 += Op2
SUB64       R1, R4                    ; Op1 -= Op2
SUB64       R1, R7                    ; Op1 -= Op2
ADD64       R1, R7                    ; Op1 += Op2
ADD64       R1, R4                    ; Op1 += Op2
SUB64       R1, R5                    ; Op1 -= Op2
MOVIqq      R7, 0x80A7FC193032FAED    ; Move immediate value
CMP64eq     R1, R7                    ; Compare if equal
"""

import antlr4
def parse(input_stream, visitor):
    from EBCLexer import EBCLexer
    from EBCParser import EBCParser

    lexer = EBCLexer(input_stream)
    stream = antlr4.CommonTokenStream(lexer)

    stream.fill()
    # print([token.type for token in stream.tokens][:-1])
    # print([str(token.text) for token in stream.tokens][:-1])
    # print

    parser = EBCParser(stream)
    tree = parser.asm()
    walker = antlr4.ParseTreeWalker()
    walker.walk(visitor, tree)


from z3 import *
class _SSAModel(object):
    def __init__(self, register_set, reg_sort):
        self.reg_sort = reg_sort
        self.solver = Solver()

        self.registers = {}
        self.version_map = {}
        for reg in register_set:
            if not reg[0].isupper(): raise ValueError('register must be uppercase')
            self.version_map[reg] = 0
            self.new_reg(reg)

    @staticmethod
    def version_reg(reg, version):
        return reg + '_' + str(version)

    def get(self, name, version=None):
        if version is None:
            version = self.version_map[name]
        return self.registers[self.version_reg(name, version)]

    def new_reg(self, name):
        reg_name = self.version_reg(name, self.version_map[name])
        reg = Const(reg_name, self.reg_sort)
        self.registers[reg_name] = reg
        return reg

    def set(self, name, value):
        self.version_map[name] += 1
        reg = self.new_reg(name)
        self.assert_true(reg == value)

    def assert_true(self, cond):
        self.solver.add(cond)

class SSAModel(object):
    def __init__(self, register_set, reg_sort):
        super(SSAModel, self).__setattr__('_obj', _SSAModel(register_set, reg_sort))

    def __getattribute__(self, name):
        _obj = super(SSAModel, self).__getattribute__('_obj')
        if name in _obj.version_map:
            return _obj.get(name)
        else:
            return _obj.__getattribute__(name)

    def __setattr__(self, name, value):
        _obj = super(SSAModel, self).__getattribute__('_obj')
        if name in _obj.version_map:
            _obj.set(name, value)
        else:
            _obj.__setattr__(name, value)        

def crc32(data,size):
    polynomial=0xEDB88320
    crc = 0xFFFFFFFF
    for i in range(0,size,8):
        crc = crc ^ (LShR(data,i) & 0xFF)
        for _ in range(8):
            crc = If(crc & 1 == BitVecVal(1, size), LShR(crc,1) ^ polynomial, LShR(crc,1))
    return crc ^ 0xFFFFFFFF

def crc32_unit_test():
    data = bytes('12345678')
    import zlib
    correct = zlib.crc32(data) & 0xffffffff
    print(hex(correct))

    import struct
    n = struct.unpack('<Q', data)[0]
    assert n == 0x3837363534333231
    s = Solver()
    result = BitVec('result', 64)
    s.add(result == crc32(BitVecVal(n,64), 64))
    s.check()
    z3_crc = s.model()[result].as_long()
    print(hex(z3_crc))
    assert z3_crc == correct
    print('OK')

    import sys
    sys.exit(0)

from EBCListener import EBCListener
class ASTVisitor(EBCListener):
    def __init__(self):
        self.model = SSAModel(['R0', 'R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7'], BitVecSort(64))
        self.input_reg = self.model.get('R1', 0)
        self.input_crc = crc32(self.input_reg, 64)

    def getOperandValue(self, op_ctx):
        if op_ctx.Register():
            return self.model.get(op_ctx.Register().getText())
        elif op_ctx.Number():
            num = op_ctx.Number().getText()
            if num.startswith('0x'):
                return int(num, 16)
            else:
                return int(num)
        elif op_ctx.derefExpr():
            addr_expr = op_ctx.derefExpr().expr()
            if addr_expr.stackExpr():
                stack_var = addr_expr.stackExpr().StackVar().getText()
                if stack_var == 'var_s8':
                    return self.input_reg
                if stack_var == 'var_sC':
                    return self.input_crc
        raise ValueError(op_ctx.getText())


    def enterInsn(self, ctx):
        op = ctx.op.text
        # control flow
        if op == 'JMP8cc':
            return # do nothing. we assert on the cmp condition

        dst_val, src_val = self.getOperandValue(ctx.dst), self.getOperandValue(ctx.src)
        dst_reg = ctx.dst.getText()
        # print("%s\t%s <- %s,\t%s" % (op, dst_reg, dst_val, src_val))

        # comparisons
        if op == 'CMP64eq':
            self.model.assert_true(dst_val == src_val) # assert the lhs equal rhs

        # arithmetic/logical
        elif op in ['MOVIqq', 'MOVIqw', 'MOVIqd']:
            self.model.set(dst_reg, src_val)
        elif op == 'MOVqw':
            self.model.set(dst_reg, src_val)
        elif op == 'ADD64':
            self.model.set(dst_reg, dst_val + src_val)
        elif op == 'SUB64':
            self.model.set(dst_reg, dst_val - src_val)
        elif op == 'MULU64':
            self.model.set(dst_reg, dst_val * src_val)
        elif op == 'XOR64':
            self.model.set(dst_reg, dst_val ^ src_val)
        elif op == 'OR64':
            self.model.set(dst_reg, dst_val | src_val)
        elif op == 'AND64':
            self.model.set(dst_reg, dst_val & src_val)
        elif op == 'NOT64':
            self.model.set(dst_reg, ~src_val)
        elif op == 'NEG64':
            self.model.set(dst_reg, -src_val)
        elif op == 'SHL64':
            self.model.set(dst_reg, dst_val << src_val)
        elif op == 'SHR64':
            self.model.set(dst_reg, LShR(dst_val, src_val))
        elif op == 'NEG64':
            self.model.set(dst_reg, -src_val)
        else:
            raise ValueError('unsupported opcode', op)

input_stream = antlr4.InputStream(stage1) # stage1
input_stream = antlr4.FileStream('penis_11d4.dec.asm') # stage2
input_stream = antlr4.FileStream('penis_193c.dec.asm') # stage3
input_stream = antlr4.FileStream('penis_2174.dec.asm') # stage4

visitor = ASTVisitor()
parse(input_stream, visitor)
# print(visitor.model.solver)
print()

assert(str(visitor.model.solver.check()) == 'sat')
m = visitor.model.solver.model()
print(hex(m[visitor.model.get('R1', 0)].as_long()))
import struct
input_str = struct.pack('<Q', m[visitor.input_reg].as_long())
print(input_str)
import zlib
print(hex(zlib.crc32(input_str) & 0xffffffff))

# TWCTF{EBC_1n7erpret3r_1s_m4d3_opt10n4l}
