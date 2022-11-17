import angr
import claripy
p = angr.Project('./chall.baby')
flag = claripy.BVS('flag', 50 * 8)
st = p.factory.entry_state(argc=2, args=[b'prog', flag])
sim = p.factory.simulation_manager(st)
sim.explore(find=0x4012c2, avoid=0x40127d)
sim.move('found', 'active')
print(sim.active[-1].solver.eval(flag).to_bytes(50, 'big'))