# Asterisk Alloc

The bug is UAF, so we can double free. However we can only store three chunks at a time, using calloc, realloc, and malloc, and this is leakless. With the double free vulnerability, we can careful obtain overlapping chunks, use unsorted bins fd and bk to spray libc pointers, partial overwrite the libc pointers to point to stdout file structure and malloc hook. Then we obtain a tcache chunk in stdout to clobber it and obtain leaks. Then, we overwrite malloc hook to system and win.
