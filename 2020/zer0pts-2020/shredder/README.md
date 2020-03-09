# Shredder

Use core2ELF64 to convert coredump to elf binary. Program is just xor'ing each
byte with the C rand function. Recover srand by getting the time from stack. We
also recover stat buf from stack as well:

size = 15527
seed = 0xa31d4ea4
buf is at 0x00005635b211a260

After getting those info just extract and solve
