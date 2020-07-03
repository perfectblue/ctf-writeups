import jarray
from ghidra.util.task.TaskMonitorAdapter import DUMMY_MONITOR

def replace(prog, haystack, result, start, end, align=4):
    addrs = prog.getAddressFactory()
    mem = prog.getMemory()
    ram = addrs.getAddressSpace('ram').getBaseSpaceID()
    buff = jarray.zeros(len(haystack), 'b')
    cdm = prog.getCodeManager()
    assert len(haystack) == len(result)
    for addr in range(start, end, align):
        addrend = addrs.getAddress(ram, addr + len(buff))
        addr = addrs.getAddress(ram, addr)
        mem.getBytes(addr, buff)
        if haystack == buff:
            cdm.clearCodeUnits(addr, addrend, False, DUMMY_MONITOR)
            mem.setBytes(addr, result)
            print(addr)


