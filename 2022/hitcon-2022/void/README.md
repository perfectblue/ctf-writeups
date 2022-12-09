The challenge accepts an arbitrary python expression, but replaces `co_consts` and `co_names`
with the empty tuple. That's an excelent way to cause memory corruption, as CPython doesn't
do bound checks when bytecode indexes into them. Furthermore, the empty tuple `()` and a bunch
of other objects after it are allocated in heap during startup all at predictable offsets.

# Building Blocks

- We can load from `co_consts` from an arbitrary offset using code like: `[] and (0/0+1+2+...) or 2`.
  This will effectively do `co_consts[2]`. `[] and` is there to prevent the `+` from being actually
  evaluated and the initial `0/0` is needed to prevent the AST optimizer from folding constants.

- Loading from `co_names` is analogous: `[] and (a+b+c+...) or c`.

- We can get booleans with `not []` and `not not []`.

- We can get integer constants by doing arithmetic on booleans: `(not[])+(not[])` evaluates to 2.

- We can get local variables using the walrus operator: `(foobar:=123) and foobar` evaluates to 123.

- We can get string constants by finding them in `co_consts`, and slicing/adding them as needed.
  Also we can evaluate `f'{whatever expr}'`.

- Function calls and slicing/indexing work as usual.

- We can emulate `getattr(x, y)` with `[*object.__getattribute__(x,"__dict__").values()][1337]`,
  where `1337` is some integer constant. This way we don't need many string constants.

# The exploit

First off, we emit `[]and(倀+倁+倂+倃+...)or[]and(0/0+1+2+3+...)`. This sets us up with a bunch of indexes
into `co_names` and `co_consts` (the CJK chars are parsed as identifiers, we use CJK to make our
payload as short as possible).

Then we create and save to locals first few powers of two (to create integer constants later):

```
(厧:=not[[]])or(厨:=(not[])+厧)and(厩:=厨+厨)and(厪:=厩+厩)and(厫:=厪+厪)and ...
```

Then we effectively evaluate `eval(input())`. The intermediate steps leading to that are best explained
by reading `generate.py`. The final payload is in `code.py`.
