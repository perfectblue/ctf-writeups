First Part
==========

The hash is only 64 bits, so we only need `n^32` operations to find a collision (birthday paradox).

Second Part
===========

The hash is now 128 bits, but it's a sponge contruction with rate of 64 and capacity of 64.
We only need to cause a collision in the capacity part (`n^32` effort) and the rate part can
be trivially made to collide.
