from pwn import *

proc = remote("crypto.chal.csaw.io", 1002)
# proc = remote('localhost', 1337)

# These are seeds which have collisions in the first 100*3 values
# seed = 71789
seed = 504551
proc.sendline(str(seed).rjust(16, '0'))

data = proc.recvuntil('Okay bye\n')
data = data[38:-9]

print len(data)

blocks = []

for i in range(0, len(data), 49):
    curr = [data[i:i+16], data[i+16:i+32], data[i+32:i+48]]
    blocks.append(curr)

print len(blocks)

# These are the indexes which have collisions

# block1 = blocks[15][2]
# block2 = blocks[38][0]

block1 = blocks[0][1]
block2 = blocks[97][2]

print repr(block1)
print repr(block2)

# print(xor(xor(block2, 'Encrypted Flag: '), block1))
print(xor(xor(block2, '_0n_m3_l1kE_123}'), block1))

# _0n_m3_l1kE_123}
# flag{U_c@n_coUn7_0n_m3_l1kE_123}
