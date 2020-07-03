import struct

heap = open('image', 'rb').read()

pie = 0x56555000
heap_start = 0x56572000

top = 0x5657c1d0

s_node = struct.Struct('<IIIII')
class Node:
    def __init__(self, addr=None):
        if type(addr) == int:
            vals = s_node.unpack_from(heap, addr - heap_start)
        else:
            vals = addr

        self.typ, self.arg, self.executor, self.jobs, chld = vals
        self.executor -= pie
        if self.jobs:
            self.children = struct.unpack_from('<' + 'I' * self.jobs, heap,
                    chld - heap_start)
        else:
            self.children = []
        self.children = [node(c) for c in self.children]
    def const(self):
        return None
    def __str__(self):
        return f'Node(0x{self.executor:08x})'
    def __repr__(self):
        return str(self)
    def dumpTree(self, thispref='', recpref=''):
        print(f'{thispref}{self}')
        for i, child in enumerate(self.children):
            if i == len(self.children) - 1:
                nrecpref = recpref + '   '
            else:
                nrecpref = recpref + '|  '
            child.dumpTree(recpref + '+- ', nrecpref)
class SubJobNode(Node):
    def __str__(self):
        return 'SubJob()'
    def code(self, indent=0):
        idt = indent * '  '
        lines = f';\n{idt}'.join(job.code(indent) for job in self.children)
        return ''.join(lines)
        
class ApplicationNode(Node):
    def __str__(self):
        return f'Apply() [{len(self.children) - 1}]'
    def code(self, indent=0):
        fn = self.children[0].code(indent)
        args = [chld.code(indent+1) for chld in self.children[1:]]
        if len(fn + ''.join(args)) > 80:
            join = ',\n' + '  ' * (indent+1)
            return f'{fn}(\n{idt}{join.join(args)})'
        else:
            return f'{fn}({", ".join(args)})'
class IfNode(Node):
    def __init__(self, addr):
        super().__init__(addr)
        assert self.jobs == 3
    def __str__(self):
        return 'If()'
    def code(self, indent=0):
        opends = [c.code(indent + 1) for c in self.children]
        expr, thenS, elseS = opends
        idt = '  ' * (indent + 1)
        idt2 = '  ' * indent
        return f'if ({expr}) {{\n{idt}{thenS}\n{idt2}}} else {{\n{idt}{elseS}\n{idt2}}}'

ops = ['==', '<<', '>>', '^', '+', '-', '*', '&&', '<', '[MEM]']
class OpNode(Node):
    def __init__(self, addr):
        super().__init__(addr)
        assert self.jobs == 2
    def __str__(self):
        return f'Op(typ={ops[self.typ]})'
    def const(self):
        a = self.children[0].const()
        b = self.children[1].const()
        if a == None or b == None:
            return None
        ops = [lambda a, b: a == b,
                lambda a, b: a << b,
                lambda a, b: a >> b,
                lambda a, b: a ^ b,
                lambda a, b: a + b,
                lambda a, b: a - b,
                lambda a, b: a * b,
                lambda a, b: a and b,
                lambda a, b: a < b,
                lambda a, b: None]
        return ops[self.typ](a, b)
    def code(self, indent=0):
        opends = [c.code(indent) for c in self.children]
        if self.typ == 9:
            return  f'*{opends[0]} = {opends[1]}'
        else:
            return  f'({opends[0]} {ops[self.typ]} {opends[1]})'
class ImmNode(Node):
    def __str__(self):
        return f'Imm(num={hex(self.typ)})'
    def const(self):
        return self.typ
    def code(self, indent=0):
        return hex(self.typ)
class ZeroNode(Node):
    def __str__(self):
        return f'Zero()'
    def const(self):
        return 0
    def code(self, indent=0):
        return str(self)
class NopNode(Node):
    def __str__(self):
        return f'Nop()'
    def const(self):
        return self.children[0].const()
    def code(self, indent=0):
        return self.children[0].code(indent)
class DerefNode(Node):
    def __str__(self):
        if self.typ != 1:
            return 'Nop2()'
        else:
            return f'Deref(size={self.arg})'
    def const(self):
        if self.typ != 1:
            return self.children[0].const()
        else:
            return None
    def code(self, indent=0):
        if self.typ == 1:
            sizes = {1: 'char', 4: 'int'}
            return f'*({sizes[self.arg]}*){self.children[0].code(indent)}'
        else:
            return self.children[0].code(indent)
class ForNode(Node):
    def __str__(self):
        return 'For [init, ??, cond, incr, body]'
    def code(self, indent=0):
        opends = [c.code(indent + 1) for c in self.children]
        body = opends[4]
        idt = '  ' * (indent+1)
        idt2 = '  ' * indent
        return f'for ({opends[0]}; {opends[2]}; {opends[3]}) {{\n{idt}{body}\n{idt2}}}'

class ScalarNode(Node):
    def __str__(self):
        return f'Scaled [base + scale * {self.typ}]'
    def code(self, indent=0):
        opends = [c.code(indent) for c in self.children]
        return f'({opends[0]} + {opends[1]} * {self.typ})'

varNames = ['memset', 'scanf', 'puts', 'var3', 'sAh', 
        'sFmt', 'var6', 'var7', 'sWow', 'sOw']
class GetVarNode(Node):
    def __str__(self):
        return f'GetVar(name={varNames[self.arg]})'
    def code(self, indent=0):
        return varNames[self.arg]
class AllocVarNode(Node):
    def __str__(self):
        return f'AllocVar(size=0x{self.typ:x}, name={varNames[self.arg]})'
    def code(self, indent=0):
        return f'{varNames[self.arg]} = malloc(0x{self.typ:x})'


spc_nodes = {
    0x1B670: OpNode,
    0x1b370: SubJobNode,
    0x1b430: SubJobNode,
    0x1B570: ApplicationNode,
    0x1b420: ImmNode,
    0x1B4F0: NopNode,
    0x1b3c0: NopNode, 
    0x1B510: NopNode,
    0x1b7e0: DerefNode,
    0x1b3e0: GetVarNode,
    0x1b400: GetVarNode,
    0x1b540: AllocVarNode,
    0x1b850: IfNode,
    0x1b480: ZeroNode,
    0x1b530: ZeroNode,
    0x1b490: ForNode,
    0x1B760: ScalarNode,
}
def node(addr):
    executor = s_node.unpack_from(heap, addr-heap_start)[2] - pie
    if executor in spc_nodes:
        n = spc_nodes[executor](addr)
        cst = n.const()
        if cst != None: return ImmNode((cst, 0, 0, 0, 0))
        else: return n
    else:
        return Node(addr)



n = node(top)
n.dumpTree(n)
#print(n.code())
