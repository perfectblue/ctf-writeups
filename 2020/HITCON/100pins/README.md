We need to recover the state of V8's RNG used in `Math.random()`.
We have two leaks (generated in order):

1. ~51.69 bits from the PoW challenge
2. at most 73.8 bits from recovering a few first pins by trial and error

V8's RNG, XorShift128, has 128-bit state so we have just about enough to recover it.

Closer inspection of V8's sources revealed that the RNG
is seeded only from 64 bits using a murmurhash inspired expansion function.
But unfortunately solving the resulting system turned out to be too hard for Z3/Boolector/CVC4/MathSat.

So we tried different approach: since state update and output generation of XorShift128 is
purely linear, we don't need a SMT solver like Z3 and instead use good old matrix arithmetic and
Gaussian Ellimination to combine all state leaks into one linear system. Then we can very efficiently
bruteforce the missing bits 

How XorShift128 works
---------------------

	def next64(xorshift):
		s1 = xorshift.state0
		s0 = xorshift.state1
		xorshift.state0 = s0
		s1 = s1 ^ (s1 << 23)
		s1 = s1 ^ (s1 >> 17)
		s1 = s1 ^ s0
		s1 = s1 ^ (s0 >> 26)
		xorshift.state1 = s1

		return s0

As you can see state update and output of XorShift128 is completely linear.

How Math.random() works
-----------------------

1. 64 bits are taken from XorShift128
2. low 20 of them are discarded
3. the high 54 bits are used as a mantissa of double precision float between 1 and 2
4. 1.0 is substracted from the float, yielding a random number from 0 to 1

Recovering bits from PoW
-----------------------

The exact behaviour of `Number.toString(36)` is not strictly specified by the ECMA standard and
I didn't bother studying V8's implementation.
But here's a quick and dirty approach that will work well enough for us:

1. Assume the output of `toString(36)` had precisely 10 digits after the dot (happens ~26% of the time)
2. Convert the base-36 string to an integer
3. Divide the integer by `36**10`
4. Add 1.0 to it
5. Bitcast to int and take the low 54 bits

This can give invalid output when assumption 1 was incorrect or due do roundoff errors, but it works ~20% of the time.

See `bounds.*` for details.

Recovering bits from pins
-------------------------

There are 5040 possible pins in total, so the theoretical maximum is `log2(5040) = 12.3` bits.
However the precise relation between RNG's output and the chosen pin is rather complicated, so we'll use an approximation:

For each pin we will find (by binary search) the lowest (when interpreted as uint64) XorShift128 output that gives the pin
and the highest one. Then we will find how many high bits these two have in common.
This way we can transform each guessed pin to 100% reliable, linear constraint on XorShift128 state.

On average this gives 10.4 bits per pin.

Solving for the state
---------------------

Rust program in `solver/src/main.rs` takes as input bit leaks and pin values themselves.
It builds a linear system from the bit leaks, enumerates all possible solutions and checks them
against the pin values to make use of the all 12.3 leaked bits from guessed pins.

Guessing pins
-------------

We'll call the set of all currently possible pins (initially of size 5040) state, and with each state
associate a guess to send to the challenge server. The returned hint will split the state into substates
of now-possible pins, for each of which we will have a next guess to send until the state contains only
one possible pin.

Finding an optimal tree of guesses to send seems quite hard, so we'll use a heuristic: given a state (i.e. a set of pins)
we'll greedily find a split that maximizes entropy and then recursively split the substates.
This solution takes `4.3` guesses per pin on average.

See `mastermind.py`.

Bringing all this together
--------------------------

The main script is `solve.py`. It connects, solves the PoW, tries to guess at least 6 pins, feeds all that into
the linear solver, and hopefully gets the correct XorShift128 state back.
