SuperMario
----------

The challenge name, and also looking at the binary, we can tell that this is referring to the Dirty Pipe vulnerability in the Linux Kernel.

The challenge gives us the exact primitives we need:

* Read from a Pipe
* Write to a Pipe
* Open a file in read only mode.

We can just follow the steps in the original Dirty Pipe blog: https://dirtypipe.cm4all.com/

We use the vulnerability to overwrite the init.sh file with our own commands and run it.

This gives us a shell. However the flag is only readable by root.

So we just use a generic dirty pipe exploit to escalate privileges to root and read the flag.

The exploit can be found in `solve.py`.
