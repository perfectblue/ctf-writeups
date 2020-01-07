# Pwn 02

This challenge is just a basic SQLi to fake the number of points, followed by
a standard fsb to modify the `__free_hook` pointer to point to system, ending
with creating a book with `/bin/sh` and then sell that book, issuing a call to
free.
