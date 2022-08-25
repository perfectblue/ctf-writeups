# pppr

We get a buffer overflow. First, rop to function r to get arbitrary read. Read "/bin/sh\x00" to .bss, then rop to function x to trigger system("/bin/sh")
