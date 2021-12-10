# cclemon

It's possible to read the code with reasonable assumptions. As it's similar to Python bytecode, we can guess it's using stack-based VM.

The most confusing parts are those:
- `define` defines a function, and has five arguments. The last one is where the function frame ends. The third one is the number of inputs and the fourth one is the number of local variables.
- `store` has two arguments. It seems the first argument is about the function frame. If it's `0`, it uses the memory of the current function. If it's `1`, it uses the memory of the caller function.

By assuming those, it's possible to recover the source code. I interpreted it in Python (`recovered.py`), and added `tqdm` to see the current state. The flag is `hitcon{42978937495235537896}`.