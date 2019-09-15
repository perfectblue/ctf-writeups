def demangle_haskell_name(name):
    result = ''
    i = 0
    while i < len(name):
        c = name[i]
        i += 1
        if c != 'z' and c != 'Z':
            result += c
            continue
        c = name[i]
        i += 1
        if c == 'Z':
            count = -1
            if c in '0123456789':
                num = c
                while c in '0123456789':
                    c = name[i]
                    i += 1
                    num += c
                count = int(num)
            if c == 'T':
                result += '(' + ','*count + ')'
            elif c == '#':
                if count == 1:
                    result += '(# #)'
                else:
                    result += '(#' + ','*(count-1) + '#)'
            else:
                result += c
        escapes = {
            'L': "(",
            'R': ")",
            'M': "[",
            'N': "]",
            'C': ":",
            'a': "&",
            'b': "|",
            'c': "^",
            'd': "$",
            'e': "=",
            'g': ">",
            'h': "#",
            'i': ".",
            'l': "<",
            'm': "-",
            'n': "!",
            'p': "+",
            'q': "'",
            'r': "\\",
            's': "/",
            't': "*",
            'u': "_",
            'v': "%",
        }
        if c in escapes:
            result += escapes[c]
        else:
            result += c
    return result

def read_ptr(address):
    if bv.address_size == 4:
        unpack_string = 'L'
    elif bv.address_size == 8:
        unpack_string = 'Q'
    elif bv.address_size == 2:
        unpack_string = 'H'
    else:
        unpack_string = 'B'
    if bv.endianness == Endianness.LittleEndian:
        unpack_string = '<' + unpack_string
    return struct.unpack(unpack_string, bv.read(address, bv.address_size))[0]

def define_symbols():
    for sym in bv.symbols.values():
        if not isinstance(sym, Symbol): continue
        if sym.name.endswith('_closure'):
            print('Defining func pointer %s at %x' % (sym.name, sym.address))
            bv.define_user_data_var(sym.address, Type.pointer(bv.arch, Type.function(Type.void(), [])))
    #
    for sym in bv.symbols.values():
        if not isinstance(sym, Symbol): continue
        if sym.name.endswith('_info'):
            print('Defining function %s at %x' % (sym.name, sym.address))
            bv.create_user_function(sym.address)
    #
    for sym in bv.symbols.values():
        if not isinstance(sym, Symbol): continue
        if sym.name.endswith('_str'):
            print('Defining string %s at %x' % (sym.name, sym.address))
            i = 0
            while bv.read(sym.address + i, 1)[0]:
                i += 1
                if i > 1000:
                    print('Truncating string %s' % (sym.name,))
                    break
            bv.define_user_data_var(sym.address, Type.array(Type.char(), i))
    #
    for sym in bv.symbols.values():
        syms = []
        if isinstance(sym, Symbol):
            syms.append(sym)
        elif isinstance(sym, list):
            syms.extend(sym)
        else:
            raise ValueError(sym)
        for sym in syms:
            if sym.name.endswith('_info') and sym.type == SymbolType.DataSymbol:
                print('Killing incorrect data symbol %s at %x' % (sym.name, sym.address))
                bv.undefine_auto_symbol(sym)
    #
    for func in bv.functions:
        if func.name.endswith('_info'):
            for bb in func.llil:
                for inst in bb:
                    if inst.operation in {LowLevelILOperation.LLIL_STORE, LowLevelILOperation.LLIL_SET_REG}:
                        rhs = inst.operands[1]
                        if rhs.operation == LowLevelILOperation.LLIL_CONST:
                            ptr = rhs.value.value
                            sym = bv.get_symbol_at(ptr)
                            if sym and (sym.name.endswith('_closure')
                                or sym.name.endswith('_info')
                                or sym.name.endswith('_str')):
                                print('Fixing display %x -> %s in %s' % (ptr, sym.name, func.name))
                                func.set_int_display_type(rhs.address, value=ptr, operand=1,
                                    display_type=enums.IntegerDisplayType.PointerDisplayType)
    #
    for func in bv.functions:
        if func.name.endswith('_info'):
            demangled = demangle_haskell_name(func.name)
            print('Demangle %s -> %s' % (func.name, demangled))
            func.name = demangled
    #
    for sym in bv.symbols.values():
        if not isinstance(sym, Symbol): continue
        if sym.type == SymbolType.FunctionSymbol: continue
        if sym.name.endswith('_info') or sym.name.endswith('_closure'):
            demangled = demangle_haskell_name(sym.name)
            print('Demangle %s -> %s' % (sym.name, demangled))
            new_sym = Symbol(sym.type, sym.address, demangled, demangled, demangled, binding=sym.binding, namespace=sym.namespace, ordinal=sym.ordinal)
            bv.undefine_auto_symbol(sym)
            bv.define_auto_symbol(new_sym)

import struct

def visit(g, max_depth, func, visited, n=0, visit_callback=None):
    if func in visited: return visited[func]
    # print(' '*n + func.name)
    node = binaryninja.FlowGraphNode(g)
    visited[func] = node
    tokens = [InstructionTextToken(InstructionTextTokenType.CodeSymbolToken, func.name, address=func.start, value=func.start)]
    node.lines = [DisassemblyTextLine(tokens, address=func.start)]
    g.append(node)
    if n > max_depth: return node
    for bb in func.llil:
        for inst in bb:
            if inst.operation in {LowLevelILOperation.LLIL_STORE, LowLevelILOperation.LLIL_SET_REG}:
                rhs = inst.operands[1]
                if rhs.operation in {LowLevelILOperation.LLIL_CONST, LowLevelILOperation.LLIL_CONST_PTR}:
                    ptr = rhs.value.value
                    sym = bv.get_symbol_at(ptr)
                    if sym and (sym.name.endswith('_closure')
                                or sym.name.endswith('_info')
                                or sym.name.endswith('_str')):
                        if visit_callback is not None and not visit_callback(sym.name):
                            node.lines = node.lines + [DisassemblyTextLine([InstructionTextToken(InstructionTextTokenType.TextToken, "-> "), InstructionTextToken(InstructionTextTokenType.CodeSymbolToken, sym.name, address=inst.address, value=inst.address)], address=inst.address)]
                            continue
                        dst = sym.address
                        branch_type = BranchType.UnconditionalBranch
                        if sym.name.endswith('_str'):
                            dst_node = binaryninja.FlowGraphNode(g)
                            g.append(dst_node)
                            var = bv.get_data_var_at(sym.address)
                            if not var:
                                print('Failed to resolve string %s to data var!' % (sym.name))
                            strlen = var.type.count
                            str_val = bv.read(sym.address, strlen).decode('utf-8', errors='ignore')
                            tokens = [InstructionTextToken(InstructionTextTokenType.StringToken, '"' + str_val + '"', address=sym.address, value=sym.address)]
                            dst_node.lines = [DisassemblyTextLine(tokens, address=sym.address)]
                            node.add_outgoing_edge(branch_type, dst_node)
                        else:
                            if sym.name.endswith('_closure'):
                                dst = read_ptr(dst)
                                branch_type = BranchType.IndirectBranch
                            dst = bv.get_function_at(dst)
                            if not dst:
                                print('Failed to resolve symbol %s to function' % (sym.name))
                            dst_node = visit(g, max_depth, dst, visited, n+1, visit_callback)
                            node.add_outgoing_edge(branch_type, dst_node)
            if inst.operation in {LowLevelILOperation.LLIL_CALL, LowLevelILOperation.LLIL_TAILCALL}:
                dst = inst.dest.constant
                if not dst: continue
                dst = bv.get_function_at(dst)
                if not dst: continue
                if (dst.name.endswith('_closure')
                            or dst.name.endswith('_info')
                            or dst.name.endswith('_str')):
                    if visit_callback is not None and not visit_callback(dst.name):
                        node.lines = node.lines + [DisassemblyTextLine([InstructionTextToken(InstructionTextTokenType.TextToken, "-> "), InstructionTextToken(InstructionTextTokenType.CodeSymbolToken, dst.name, address=inst.address, value=inst.address)], address=inst.address)]
                        continue
                    dst_node = visit(g, max_depth, dst, visited, n+1, visit_callback)
                    node.add_outgoing_edge(BranchType.UnconditionalBranch, dst_node)
    return node

def show_callgraph(func, n=5):
    g = binaryninja.FlowGraph()
    callback = lambda sym: not sym.startswith('stg_') and not sym.startswith('base_') and not sym.startswith('ghc-prim_')
    visit(g, n, func, {}, visit_callback=callback)
    g.show('Haskell')

def refresh(name='Main_main_info'):
    show_callgraph(bv.get_function_at(bv.symbols[name].address), 100)

# int64_t stg_ap_p_fast(int64_t func @ rbx, int64_t arg @ r14, int64_t arg2 @ r15)