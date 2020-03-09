# Syscallkit

Use brk to leak heap pointers. Use shmat to craft a special address whose lower
32-bit word is 0. This allows us to craft an iovec with an address we control.
From there just write payload into our controlled memory block to get shell.


