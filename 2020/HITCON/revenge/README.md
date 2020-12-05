# revenge

We obtain the stdout and stderr of the pwntools script, so we can use the assembler to leak the flag through errors. Use ".include" on the flag file to include the flag as assembly code, which will error when assembled. See [solve.py](./solve.py)
