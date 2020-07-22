## The bug

`StdVecIter` keeps pointers right into `StdVec` storage. When `StdVec` is resized iterator's pointers become dangling.

## The exploit

We use the UAF bug to create a fake bytearray that spans the entire memory space, use it to leak a dict with every
loaded python module (see `PyImport_GetModuleDict()`), and finally read the flag with `io.FileIO`.
Python's `id()` function trivially leaks object addresses, so the exploit is quite straightforward.
