import binascii

CODE = [

        "5B" #JUMP DEST
        "5A", #GAS

        "60", "50", # PUSH 60

        "11", #if GT

        "5A", #GAS
        "60", "72", # PUSH 98

        "03", #SUB, calcucate jmp dest based on gas left

        "57", #Jump if greater

        "60", "00", # PUSH 0x00
        "56", #JMP back to start

]


CODE = bytes.fromhex("".join(CODE))
print(len(CODE))
assert(len(CODE) < 40)

CODE = CODE.ljust(98, b"\x5b")
CODE += b"\x00"

print(binascii.hexlify(CODE))

