# backend

We are given a precompiled [https://www.llvm.org/docs/CommandGuide/llc.html](llc) binary
with only a single arch called 'chal'. The service wants us to supply a LLVM IR file that
compiles to a single NUL in the ".text" section.

First we try the equivalent of C `__attribute__((section(".text"))) const char foobar[1];`:

```
@foobar = dso_local constant [1 x i8] zeroinitializer, section ".text", align 1
```

This compiles to exactly what we want and solves the challenge.
