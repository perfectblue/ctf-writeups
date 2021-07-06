Secure Storage
=============

Steps
-----

1. Leak admin key using page fault timing attack.
2. Get RCE in ss_agent using double free in "Kick last user"
3. Get Root by exploiting the kernel driver. Bug is in negative indexing in the page fault handler if we access a address > 0xF000000 within the mmaped page.
4. Exploit qemu device by loading a kernel driver. The bug is a off-by-one in page_num (set to 0x100) which allows us to overwrite function pointers
   and get code execution on host.

Files
-----

`solve_final.py` contains the heap exploit and uploads all the necessary files such as the kernel exploit and the qemu exploit driver
