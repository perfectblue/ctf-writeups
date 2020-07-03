duet
====

smallbin to tcache attack on global max fast, fastbin freelist hack to control top chunk, top chunk overlap with main arena, control top chunk (again), and craft a 0x5000ish fastbin on heap, free fastbin to get fastbin chunk ptr written right above free hook, point top chunk there, overwrite freehook to printf, format string stack to write ropchain, rop to second stager, mprotect stack, execute /bin/sh shellcode
