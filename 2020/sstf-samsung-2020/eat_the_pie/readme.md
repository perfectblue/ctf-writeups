# Eat the Pie

This was a 32-bit binary. There were two bugs: lack of null-byte termination and negative indexing. The lack of a null terminated input string allows us to leak PIE through the function pointers on the stack. The negative indexing allows us to use our input as a function pointer. We can rop to a pop gadget to align our input to rop to system with a controlled first argument that points to "sh\x00". See solve script for exploit.
