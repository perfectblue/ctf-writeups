Liars and Cheats
================

If we win the game, we get a overflow on the stack.

We use a negative OOB indexing to leak libc, and then we can leak the canary from libc.

We use another overflow bug while playing the game to corrupt the game state, because without a bug it's impossible to win the game.

Once we win the game, we just ROP and get shell.
