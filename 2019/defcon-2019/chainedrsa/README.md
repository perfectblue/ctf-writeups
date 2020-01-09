# chainedrsa

**Category**: Crypto

**Problem description**:

---

Coppersmith attack problem but they use Carmichael lambda totient to generate d instead of Euler phi totient so we wasted a ton of time on this.
I don't think anyone actually understands that complicated LLL shit so rather than to modify the magic LLL code we just use a less sophisticated attack. 
We brute force some bits to make the attack more reliable. This is a stupid trick but oftentimes it is necessary. Solved by sampriti and neptunia.
