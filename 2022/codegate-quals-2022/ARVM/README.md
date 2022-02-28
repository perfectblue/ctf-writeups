# ARVM

- Emulator emulates ARVM code and filters syscall numbers to ORW
- Bypass syscall number by using read to read in the syscall number to memory and loading that
- Execve /bin/sh for shell
