from binaryninja import *
from binaryninja.enums import *
from struct import unpack

INSN_BYTE_LENGTHS = {
    "nop": 1,
    "jcn": 2,
    "fim": 2,
    "src": 1,
    "fin": 1,
    "jin": 1,
    "jun": 2,
    "jms": 2,
    "inc": 1,
    "isz": 2,
    "add": 1,
    "sub": 1,
    "ld": 1,
    "xch": 1,
    "bbl": 1,
    "ldm": 1,
    "wrm": 1,
    "wmp": 1,
    "wrr": 1,
    "wpm": 1,
    "wr0": 1,
    "wr1": 1,
    "wr2": 1,
    "wr3": 1,
    "sbm": 1,
    "rdm": 1,
    "rdr": 1,
    "adm": 1,
    "rd0": 1,
    "rd1": 1,
    "rd2": 1,
    "rd3": 1,
    "clb": 1,
    "clc": 1,
    "iac": 1,
    "cmc": 1,
    "cma": 1,
    "ral": 1,
    "rar": 1,
    "tcc": 1,
    "dac": 1,
    "tcs": 1,
    "stc": 1,
    "daa": 1,
    "kbp": 1,
    "dcl": 1,
}


def get_opcode(opbyte1):
    opbyte1 = unpack("B", bytes([opbyte1]))[0]
    if (opbyte1 >> 4) == 0b0000:
        return "nop"
    if (opbyte1 >> 4) == 0b0001:
        return "jcn"
    if (opbyte1 >> 4) == 0b0010:
        if (opbyte1 & 0b1) == 0b0:
            return "fim"
        if (opbyte1 & 0b1) == 0b1:
            return "src"
    if (opbyte1 >> 4) == 0b0011:
        if (opbyte1 & 0b1) == 0b0:
            return "fin"
        if (opbyte1 & 0b1) == 0b1:
            return "jin"
    if (opbyte1 >> 4) == 0b0100:
        return "jun"
    if (opbyte1 >> 4) == 0b0101:
        return "jms"
    if (opbyte1 >> 4) == 0b0110:
        return "inc"
    if (opbyte1 >> 4) == 0b0111:
        return "isz"
    if (opbyte1 >> 4) == 0b1000:
        return "add"
    if (opbyte1 >> 4) == 0b1001:
        return "sub"
    if (opbyte1 >> 4) == 0b1010:
        return "ld"
    if (opbyte1 >> 4) == 0b1011:
        return "xch"
    if (opbyte1 >> 4) == 0b1100:
        return "bbl"
    if (opbyte1 >> 4) == 0b1101:
        return "ldm"
    if (opbyte1 >> 4) == 0b1110:
        if (opbyte1 & 0xf) == 0b0000:
            return "wrm"
        if (opbyte1 & 0xf) == 0b0001:
            return "wmp"
        if (opbyte1 & 0xf) == 0b0010:
            return "wrr"
        if (opbyte1 & 0xf) == 0b0011:
            return "wr0"
        if (opbyte1 & 0xf) == 0b0100:
            return "wr1"
        if (opbyte1 & 0xf) == 0b0101:
            return "wr2"
        if (opbyte1 & 0xf) == 0b0110:
            return "wr3"
        if (opbyte1 & 0xf) == 0b0111:
            return "sbm"
        if (opbyte1 & 0xf) == 0b1001:
            return "rdm"
        if (opbyte1 & 0xf) == 0b1010:
            return "rdr"
        if (opbyte1 & 0xf) == 0b1011:
            return "adm"
        if (opbyte1 & 0xf) == 0b1100:
            return "rd0"
        if (opbyte1 & 0xf) == 0b1101:
            return "rd1"
        if (opbyte1 & 0xf) == 0b1110:
            return "rd2"
        if (opbyte1 & 0xf) == 0b1111:
            return "rd3"
    if (opbyte1 >> 4) == 0b1111:
        if (opbyte1 & 0xf) == 0b0000:
            return "clb"
        if (opbyte1 & 0xf) == 0b0001:
            return "clc"
        if (opbyte1 & 0xf) == 0b0010:
            return "iac"
        if (opbyte1 & 0xf) == 0b0011:
            return "cmc"
        if (opbyte1 & 0xf) == 0b0100:
            return "cma"
        if (opbyte1 & 0xf) == 0b0101:
            return "ral"
        if (opbyte1 & 0xf) == 0b0110:
            return "rar"
        if (opbyte1 & 0xf) == 0b0111:
            return "tcc"
        if (opbyte1 & 0xf) == 0b1000:
            return "dac"
        if (opbyte1 & 0xf) == 0b1001:
            return "tcs"
        if (opbyte1 & 0xf) == 0b1010:
            return "stc"
        if (opbyte1 & 0xf) == 0b1011:
            return "daa"
        if (opbyte1 & 0xf) == 0b1100:
            return "kbp"
        if (opbyte1 & 0xf) == 0b1101:
            return "dcl"


def xxd(v):
    """ better than hex(v) because it doesn't put an L at the end """
    return "0x{:x}".format(v)


class Intel4004(Architecture):
    name = "Intel 4004"
    regs = {
        # regular registers:
        # these are actually all .5 bytes long, but don't tell anyone
        "r0": RegisterInfo("r0", 1),
        "r1": RegisterInfo("r1", 1),
        "r2": RegisterInfo("r2", 1),
        "r3": RegisterInfo("r3", 1),
        "r4": RegisterInfo("r4", 1),
        "r5": RegisterInfo("r5", 1),
        "r6": RegisterInfo("r6", 1),
        "r7": RegisterInfo("r7", 1),
        "r8": RegisterInfo("r8", 1),
        "r9": RegisterInfo("r9", 1),
        "r10": RegisterInfo("r10", 1),
        "r11": RegisterInfo("r11", 1),
        "r12": RegisterInfo("r12", 1),
        "r13": RegisterInfo("r13", 1),
        "r14": RegisterInfo("r14", 1),
        "r15": RegisterInfo("r15", 1),
        # pair registers
        "p0": RegisterInfo("p0", 1),
        "p1": RegisterInfo("p1", 1),
        "p2": RegisterInfo("p2", 1),
        "p3": RegisterInfo("p3", 1),
        "p4": RegisterInfo("p4", 1),
        "p5": RegisterInfo("p5", 1),
        "p6": RegisterInfo("p6", 1),
        "p7": RegisterInfo("p7", 1),
    }
    flags = ["c"]
    flag_roles = {"c": FlagRole.CarryFlagRole}
    stack_pointer = None

    def get_operands(self, data, addr):
        space = InstructionTextToken(InstructionTextTokenType.TextToken, " ")
        opcode, insn_len = self.decode_instruction(data, addr)
        if opcode in {"inc", "add", "sub", "ld", "xch"}:
            # single op, 4-bit reg insns:
            reg_num = unpack("B", bytes([data[0]]))[0] & 0xf
            reg = "r{}".format(reg_num)
            return [
                space,
                InstructionTextToken(InstructionTextTokenType.RegisterToken, reg),
            ]
        elif opcode in {"fin", "jin", "src"}:
            # single op, 8-bit reg insns:
            reg_num = (unpack("B", bytes([data[0]]))[0] & 0b00001110) >> 1
            reg = "p{}".format(reg_num)
            return [
                space,
                InstructionTextToken(InstructionTextTokenType.RegisterToken, reg),
            ]
        elif opcode in {
            "clb",
            "clc",
            "iac",
            "cmc",
            "cma",
            "ral",
            "rar",
            "tcc",
            "dac",
            "tcs",
            "stc",
            "daa",
            "kbp",
        }:
            # no operand insns
            return []
        elif opcode in {"jun", "jms"}:
            # jump to full address insns
            target = unpack(">H", data[0:2])[0] & 0xfff
            return [
                space,
                InstructionTextToken(
                    InstructionTextTokenType.PossibleAddressToken, xxd(target), target
                ),
            ]
        elif opcode in {"jcn", "isz"}:
            # jumps with imm opcodes
            target = ((addr + insn_len) & 0xf00) | struct.unpack("B", bytes([data[1]]))[0]
            return [
                space,
                InstructionTextToken(
                    InstructionTextTokenType.PossibleAddressToken, xxd(target), target
                ),
            ]
        elif opcode == "fim":
            # fim pX, XX
            reg_num = (unpack("B", bytes([data[0]]))[0] & 0b00001110) >> 1
            reg = "p{}".format(reg_num)
            target = struct.unpack("B", bytes([data[1]]))[0]
            return [
                space,
                InstructionTextToken(InstructionTextTokenType.RegisterToken, reg),
                space,
                InstructionTextToken(
                    InstructionTextTokenType.IntegerToken, xxd(target), target
                ),
            ]
        elif opcode in {"ldm", "bbl"}:
            # imm in the low nibble
            imm = unpack("B", bytes([data[0]]))[0] & 0xf
            return [
                space,
                InstructionTextToken(
                    InstructionTextTokenType.IntegerToken, xxd(imm), imm
                ),
            ]
        elif opcode in {
            "nop",
            "wrm",
            "wmp",
            "wrr",
            "wr0",
            "wr1",
            "wr2",
            "wr3",
            "sbm",
            "rdm",
            "rdr",
            "adm",
            "rd0",
            "rd1",
            "rd2",
            "rd3",
            "clb",
            "clc",
            "iac",
            "cmc",
            "cma",
            "ral",
            "rar",
            "tcc",
            "dac",
            "tcs",
            "stc",
            "daa",
            "kbp",
            "dcl",
        }:
            # no operand opcodes :)
            return []

    def decode_instruction(self, data, addr):
        opcode_name = get_opcode(data[0])
        return opcode_name, INSN_BYTE_LENGTHS.get(opcode_name, 0)

    def perform_get_instruction_text(self, data, addr):
        opcode_name, insn_len = self.decode_instruction(data, addr)
        if opcode_name is None:
            return None

        tokens = []
        tokens.append(
            InstructionTextToken(InstructionTextTokenType.TextToken, opcode_name)
        )
        tokens.extend(self.get_operands(data, addr))
        return tokens, insn_len

    def perform_get_instruction_info(self, data, addr):
        opcode_name, insn_len = self.decode_instruction(data, addr)
        if opcode_name is None:
            return None
        res = InstructionInfo()
        res.length = insn_len

        if opcode_name == "jun":
            target = unpack(">h", data[0:2])[0] & 0xfff
            res.add_branch(BranchType.UnconditionalBranch, target)
        elif opcode_name == "jms":
            target = unpack(">h", data[0:2])[0] & 0xfff
            res.add_branch(BranchType.CallDestination, target)
        elif opcode_name == "bbl":
            res.add_branch(BranchType.FunctionReturn)
        elif opcode_name == "jin":
            res.add_branch(BranchType.UnresolvedBranch)
        elif opcode_name in {"jcn", "isz"}:
            target = ((addr + insn_len) & 0xf00) | struct.unpack("B", bytes([data[1]]))[0]
            res.add_branch(BranchType.TrueBranch, target)
            res.add_branch(BranchType.FalseBranch, addr + insn_len)
        return res

    def perform_get_instruction_low_level_il(self, data, addr, il):
        return None


Intel4004.register()
