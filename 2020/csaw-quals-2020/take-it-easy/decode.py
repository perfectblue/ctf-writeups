#!/usr/bin/env python3

import argparse
import subprocess
import re

def hexstring_to_list(hexstr):
    """Converts a hex string line 'ff 12 34' to a list of integers."""
    return [int(x, 16) for x in hexstr.split()]

def bits_to_bytes(bitlist):
    """Convert a list of booleans into a byte string"""
    # Round down to multiples of 8

    num_bytes = (len(bitlist) + 7) // 8
    bl = [0]*num_bytes

    for pos in range(len(bitlist)):
        bl[pos // 8] |= (1 if bitlist[pos] else 0) << (pos % 8)

    return bytes([b for b in bl if b != 0])

def bits_to_string(bitlist):
    """Convert a list of booleans into a string"""
    return bits_to_bytes(bitlist).decode()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Embed messages into object files')
    parser.add_argument('binary', help='The ELF binary from which to extract a message')
    args = parser.parse_args()

    instr_bytes_re = re.compile(r"[0-9a-f]+:\s+(([0-9a-f]{2} )+)\s+\S")
    # group(1) contains a hex string

    short_opc = [0x35]
    long_opc = [0x81, 0xf0]

    disassembly = subprocess.run(["objdump", "-d", args.binary], capture_output=True, check=True).stdout.decode('ascii')
    recovered_bits = []

    for line in disassembly.split('\n'):
        m = re.search(instr_bytes_re, line)
        if not m:
            continue

        byte_list = hexstring_to_list(m.group(1))

        if byte_list[:1] == short_opc or byte_list[:2] == long_opc:
            assert len(byte_list) in [5, 6]
            recovered_bits.append(byte_list[:2] == long_opc)

    print(bits_to_string(recovered_bits))

