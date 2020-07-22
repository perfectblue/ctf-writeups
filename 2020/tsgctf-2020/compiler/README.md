Our compiler backdoor works by intercepting all calls to `read()`,
hashing the input consumed so far, and injecting code whenever the hash matches a known value.
At the end of compilation the backdoor executes a [quine](https://en.wikipedia.org/wiki/Quine_%28computing%29)
to include itself in newly compiled compilers.

## Files

 - `compiler_backdoor.template` — original compiler but with hooks to backdoor inserted
 - `diff.py` — script that diffs `compiler_backdoor.template` with `compiler.y` and generates
   appropriate injection and quine code.
