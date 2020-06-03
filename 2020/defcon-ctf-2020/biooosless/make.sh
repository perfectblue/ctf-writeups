#!/bin/bash
set -e
#set -x
rm -f poc.o poc.bin poc.elf
gcc -Os -ffunction-sections -fno-pie -nostdlib -m32 -c poc.c
ld -m32 -T fuck.ld -m elf_i386 poc.o -o poc.elf
objcopy -O binary poc.elf poc.bin

