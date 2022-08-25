# Secure Runner 2

It stores `p ^ q ^ d_p ^ d_q` and checks it when generating signatures, so it is
impossible to get signatures after modifying some of them. However, there's a new
function that re-calculates `p * q` and let us know the result.

Therefore, just modify the lowest one byte of `p`. Then we can get `p' * q`, that
`p'` is the modified `p` value of which the LSB is 0. We can calculate `q` with
`q = GCD(n, p' * q)`, and we're gonna make a signature from new `n' = p' * q` value.
But, how can we factor `p'`?

The answer is simple. Just brute-force to get `p'` that `p' // 256` is prime! Then
we can calculate `phi(p' * q) = (p' // 256 - 1) * 128 * (q - 1)`, and can generate
the signature based on that.