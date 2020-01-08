# Pwn 01

This challenge had an obvious format string bug. Using the format string modifier %n, we could overwrite puts_GOT to main, causing the program to continously loop. Now that we have infinite format strings, we can leak libc, calculate the offset to system, and overwrite stackchk_fail GOT to a one gadget. Then, we can point puts_GOT to stackchk_fail_GOT to get shell.
