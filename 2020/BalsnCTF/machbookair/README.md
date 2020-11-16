Machbook Air
============

We can use Unicode Normalization on HFS+ File System to overwrite admin file with our own content.

Using this, we can bypass the password check and then do a overflow in the admin area.
We brute force the canary and PIE address using uninitialized memory on the stack and controlled data in the admin file.

MacOS randomizes library addresses at boot, so we can run a initial exploit (solve.py) to leak a library address, and then do
another exploit (solve_final.py) where we use this leaked library address to do a ROP and print the flag.
