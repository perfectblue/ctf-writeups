PyAuCalc
========

We dump the source using the `SOURCE` commands and then we dump the audit sandbox ELF.

Reversing the ELF, we find that it blocks a lot of the useful python internal libraries that we could use to get shell.
So we need to bypass this audit subsystem completely somehow.

Investigating the lifecycle of these audit hooks, we find a CPython function `cpython._PySys_ClearAuditHooks ()` that is called
when Python is shutting down.

So if we manage to execute some code after this point, we won't be restricted at all.
Turns out, if we setup some code in class destructors, they are called after audit hooks are cleared.

So, we first use builtins.exec to create a class and then add our os.system command in it's destructor, so that it is executed when python
is shutdown.

While submitting the payload, we use proc.shutdown() to simulate EOFError on remote, so that it exits the python code and executes our destructor giving us RCE.
