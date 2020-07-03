We mount a slidex attack on a 58-bit Additive Even-Mansour scheme.
The attack is described in greater detail in: https://eprint.iacr.org/2011/541.pdf

Let `f(x) = x * C % M % P`. We will treat `f(x)` as an random unkeyed permutation.
Let `e(x) = K1*f(K0*x%P)%P`, the block encryption function.

In short, we:
1. Pick a random block `diff`
2. Find two known plaintexts `a` and `b` s.t. `a*b = diff/K0`.
   Having `D` known plaintexts we can check all `D*(D-1)/2` pairs for the above property in only `O(D)` time.
   Since `a*b = diff/K0`, we have `e(a) = K1 * f(diff/b)`, `e(b) = K1 * f(diff/a)`, and `e(a)*f(diff/a) = e(b)*f(diff/b)`.
   So we calculate `e(x)*f(diff/x)` for every known plaintext `x` and check for collisions using a hash table.
3. In case of no collisions we try a different `diff`
The slidex attack is implemented in './emmm/src/main.rs`


Since the encryption function is not injective we have to do some guesswork
when decrypting the flag. See `getflag.py` for details.
