string = "mzisthebest@notarealemail.com"
sice = 0xaed0dea
encounter = 0
#sums everything left of @ and xors everything right of @ over 0xaed0dea
for i in string:
    if i == "@":
        encounter = 1
    if encounter == 1:
        sice ^= ord(i)
    else:
        sice += ord(i)
#result should be target (hardcoded)
target = 0x0AED12F1
assert sice == target

flag = "00010001000142B0"
asdf = 0
#takes license key in blocks of 4 and xors them interpreted in base 30
for a in range(4):
    current = flag[4*a:4*a+4]
    asdf ^= int(current, 30)
print asdf
#that xor target should be 0xaecbcc2 (hardcoded as well)
assert asdf ^ target == 0xaecbcc2

print flag
