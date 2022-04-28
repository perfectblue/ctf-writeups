pppordle
========

The bug in Level 2 is that the seed is generated using a timestamp.

First, we use the server TLS certificate to find a approximate timestamp which was used to
seed the Random Number Generator.

Next, we use the level 1 to find around 10 numbers generated.

Next we use a go script to bruteforce the seed and find a seed which generates a sequence of random
numbers such that our numbers from level 1 are a subsequence.

Once we find such a seed, we use this to generate a list of possible emojis and feed that to the level 2 solver.

Files
-----

`pppordle_good.py`: Wordle Solver
`bf_seed.go`: RNG seed bruteforcer