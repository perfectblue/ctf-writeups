import idaapi
import idc
import idautils

def get_third_arg(ea):
    """Extract the third argument address using idaapi.get_arg_addrs."""
    arg_addrs = idaapi.get_arg_addrs(ea)
    
    if arg_addrs and len(arg_addrs) >= 3:
        third_arg_addr = arg_addrs[2]  # The third argument (index 2).
        third_arg_value = idc.get_operand_value(third_arg_addr, 1)
        return third_arg_value

    return None

rename = {}
conflict = set()
for xref in idautils.XrefsTo(err_set_debug_addr, 0):
    func_addr = idc.get_func_attr(xref.frm, idc.FUNCATTR_START)
    third_arg_addr = get_third_arg(xref.frm)
    if third_arg_addr:
        func_name = idc.get_strlit_contents(third_arg_addr, -1, idc.STRTYPE_C)
        if func_name:
            func_name = func_name.decode('utf-8')  # Assuming the string is encoded in UTF-8
            existing_name = idc.get_func_name(func_addr)
            if existing_name.startswith("sub_") or existing_name == "":
                if func_addr in rename and rename[func_addr] != func_name:
                    print(f"CONFLICT: {func_addr:x} - {rename[func_addr]} vs {func_name}")
                    conflict.add(func_addr)
                else:
                    rename[func_addr] = func_name
for func_addr in conflict: del rename[func_addr]
SN_FORCE = 0x800
for func_addr, new_name in rename.items():
    existing_name = idc.get_func_name(func_addr)
    if existing_name.startswith("sub_") or existing_name == "" and not existing_name.startswith(new_name):
        idc.set_name(func_addr, new_name, idc.SN_NOWARN | SN_FORCE)