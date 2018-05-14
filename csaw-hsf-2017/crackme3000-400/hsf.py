# Copyright (c) Microsoft Corporation 2015, 2016

# The Z3 Python API requires libz3.dll/.so/.dylib in the 
# PATH/LD_LIBRARY_PATH/DYLD_LIBRARY_PATH
# environment variable and the PYTHON_PATH environment variable
# needs to point to the `python' directory that contains `z3/z3.py'
# (which is at bin/python in our binary releases).

# If you obtained example.py as part of our binary release zip files,
# which you unzipped into a directory called `MYZ3', then follow these
# instructions to run the example:

# Running this example on Windows:
# set PATH=%PATH%;MYZ3\bin
# set PYTHONPATH=MYZ3\bin\python
# python example.py

# Running this example on Linux:
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:MYZ3/bin
# export PYTHONPATH=MYZ3/bin/python
# python example.py

# Running this example on OSX:
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:MYZ3/bin
# export PYTHONPATH=MYZ3/bin/python
# python example.py


from z3 import *
init('/mnt/e/Documents/ctf/csaw-hsf-2017/crackme3000-400/z3/bin')

s = Solver()

def back_iter(s,i,a_f,b_f,c_f,d_f,z_f):
    i -= 1 # we've got to go back

    # --- declare ---
    buf_i = BitVec('buf_%d' % (i,), 8)
    # initial states
    a_i = BitVec('a_%d' % (i,), 32)
    b_i = BitVec('b_%d' % (i,), 32)
    c_i = BitVec('c_%d' % (i,), 32)
    d_i = BitVec('d_%d' % (i,), 32)
    z_i = BitVec('z_%d' % (i,), 8)

    # --- equations ---
    # assert buf_i ascii
    s.add(Or(Or(Or(
        And(UGE(buf_i, BitVecVal(ord('0'), 8)), ULE(buf_i, BitVecVal(ord('9'), 8))),
        And(UGE(buf_i, BitVecVal(ord('a'), 8)), ULE(buf_i, BitVecVal(ord('z'), 8)))),
        And(UGE(buf_i, BitVecVal(ord('A'), 8)), ULE(buf_i, BitVecVal(ord('Z'), 8)))),
        Or(Or(buf_i == BitVecVal(ord('{'), 8), buf_i == BitVecVal(ord('}'), 8)), buf_i == BitVecVal(ord('_'), 8)))
    )
    if i != 31:
        s.add(buf_i != BitVecVal(ord('}'), 8))
    if i != 4:
        s.add(buf_i != BitVecVal(ord('{'), 8))

    # iteration
    s.add(a_f == a_i - SignExt(24, z_i ^ buf_i) - BitVecVal(1, 32))
    s.add(b_f == a_f * ZeroExt(24, buf_i))
    s.add(c_f == b_f + a_f)
    s.add(d_f == a_f * (b_f + a_f))
    s.add(z_f == Extract(7, 0, a_f))

    return (i,a_i,b_i,c_i,d_i,z_i), buf_i # updated state vector

state = (32, # i=32
    BitVecVal(0x4141413A, 32), # a_32
    BitVecVal(0xDCDCD952, 32), # b_32
    BitVecVal(0x1E1E1A8C, 32), # c_32
    BitVecVal(0xC11B8FB8, 32), # d_32
    BitVec('z_32', 8)) # z_32

buf = [None] * 32

for i in range(31, -1, -1):
    state, buf_i = back_iter(s,*state)
    buf[state[0]] = buf_i

# initial conditions
s.add(state[1] == BitVecVal(0x41414141, 32)) # a_0
s.add(state[2] == BitVecVal(0xDEADBEEF, 32)) # b_0
s.add(state[3] == BitVecVal(0, 32)) # c_0
s.add(state[4] == BitVecVal(0, 32)) # d_0
s.add(state[5] == BitVecVal(ord('A'), 8)) # z_0

for i, c in enumerate(list('flag{')):
    s.add(buf[i] == BitVecVal(ord(c), 8))
s.add(buf[31] == BitVecVal(ord('}'), 8))

while s.check() == sat:
    model = s.model()
    flag = map(lambda sym: model[sym], buf)
    flag = map(lambda val: int(str(val)), flag) # wtf
    flag = map(chr, flag)
    print ''.join(flag)

    # Exclude this solution
    circuit = False
    for i in range(0, 32):
        circuit = Or(circuit, buf[i] != model[buf[i]])
    s.add(circuit)

else:
    print 'unsat'
