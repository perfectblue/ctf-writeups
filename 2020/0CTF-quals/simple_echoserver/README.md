simple echoserver
================

We can use format string to overwrite rbp such that main's return address will be a residual start address. This allows us to make the program loop, and each subsequent loop's stack alignment will be predictable, so we can consistently align the ret with start. Using the loop, we modify a stack pointer to point to a residual IO_stdin pointer, overwrite IO_stdin to `IO_stderr->_fileno`, then change the fd to 1 (stdout) instead of 2 (stderr), giving us leaks. Using leaks, we can easily ROP to system("/bin/sh")
