# Rustyschool

Category: Reversing

406 points, 6 solves

**Solved by: superfashi, Riatre, cts**

**Writeup author: cts**

---

This is a fairly straightforward flag decryptor style reversing challenge. The gimmick is that it's a Rust binary so it's fucking impossible to read.

https://github.com/perfectblue/ctf-writeups/assets/14918218/9d771b3f-12bd-4254-9a2a-7c84d9a64469

But first, a quick digression.

## The absolute state of reverse engineering in 2024

Unfortunately, the year is 2024 and there is yet to be a high-quality Rust decompiler on the market. We have become really good at decompiling C, and Hex-Rays is a gold standard for native decompilation. However, the pseudo-C it produces is extremely verbose for non-C languages. This is especially true considering the large amount of syntactic sugar Rust provides. Unfortunately, Rust pushes programmers to *actually consider errors and handle them* (booo!), much to the detriment of reverse engineers. A single-character `?` operator can produce dozens of lines of boilerplate in pseudo-C.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/7f1f0d26-2f2b-411e-845f-e17f3d9b0612)

Even allocation failures are handled by the compiler (instead of the Chad move of simply ignoring them), a fact I find deeply distressing. Combine that with proc macros, a powerful type system, differences in calling convention, and modern compiler optimizations and inlining, and you have a truly awful time.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/c991faca-bc65-43db-87c9-682380e4f751)

A good Rust decompiler ought to "lift away" all of these details and fold them into high level Rust code. In Binary Ninja terms, there is really a hierarchy of:

 * **machine code**; binary format has been parsed and memory maps and sections/segments have been populated; ⮐
 * **disassembly** (this is a meaningful distinction as assembly is not bijective for real-world ISAs); ⮐
 * **lifted IL**, essentially a translation of native instruction semantics to a retargetable IL instruction set with some control reconstruction ⮐
 * **low-level IL**, where control flow graph is available and statements are ASTs not [3AC](https://en.wikipedia.org/wiki/Three-address_code) ⮐
 * **medium-level IL**, where variables have been reconstructed; types have been reconstructed; the stack is not present as a concept and stack slots have been made variables; variables have been split at type boundaries ⮐
 * **high-level IL**, where high-level control flow constructs have been re-introduced ⮐
 * **target language**, which could be C, but in modern times also C++, Go, Rust, Swift, Objective-C, Zig, Crystal, Haskell, etc. Language-specific idioms have been reconstructed and reintroduced. However, the output may not exactly reflect the same semantics of the original binary.

The final step, emitting the target language, **which is nowadays often NOT C**, is our greatest weakness in 2024. A new generation of engineers and systems folk have discovered the [fruits of Chris Lattner's labor](https://llvm.org/) and staked their claim on today's software landscape. Unfortunately for reverse engineers, we continue to deal with the Cambrian explosion in binary diversity, eating shit reading worsening pseudo-C approximations of things that are not C. 

This problem will probably not get solved in the near future. There is no market for a high-quality Rust decompiler. First, no one writes exploits or malware in languages like Rust or Haskell. Unlike C/C++/Obj-C, the Rust/Haskell/etc ecosystems are predominantly open-source further decreasing the need for reverse engineering. Lastly, improved source control and ready availability of managed enterprise services (i.e. GitHub) make first-party loss of source code much rarer nowadays. So like, no one really cares about decompiling Rust other than unfortunate CTF players.

Golang is a notable exception. Golang is like, *the* language for writing malware--great standard library, good cross-platform support, brain-dead easy concurrency model, easy to cross-compile, fully statically linked, and designed with junior programmers in mind. You could shit out a Golang SSH worm in like 200 LoC crushing carts and ketamine no problem. People worry about AGI Skynet hacking the Pentagon to trigger a nuclear holocaust but really it's more gonna be like eastern European dudes rippin' it with some hella gang weed ChatGPT ransomware.

So maybe we'll get a good Golang decompiler first?

## OK, so the actual challenge

Right, so you go in your ... fucken ... IDA Pro and throw some F5 on it. The shit is illegible so you squint at it really hard and read the function names of the library calls I guess?

That didn't really go anywhere so I just started playing with the binary. First you notice it produces different output each time, so it must call `rand()` or similar. It also means for the challenge to be solveable, it needs to include something in the encrypted output that can be used to derive the original random state. Running it under `strace`, we can see it uses the `getrandom` syscall. We also notice it reads in the input in blocks of 48 bytes, and emits 60 bytes. So it's probably including 12 extra bytes of the random state so the process is invertible.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/3baec769-6e74-4909-b8b2-4519d9c2ea38)

The random value generation is likely important for the crypto, so this is probably a good starting point. So we look for a path from `main` to `getrandom`.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/35650307-343c-4262-809f-9c231855de6b)

OK, so if we go there in main, it makes some kind of iterator that generates random bytes then fills a `vec` with it.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/573aec17-ba68-4477-80e8-021f1dfee73f)

Honestly im kind of a fraud and I havent written rust in like 4 years, but that sounds like the kind of thing a Rust programmer would do--overcomplicating a simple operation with functional programming.

At this point I wanted to simplify the problem so I want to make the challenge deterministic. If we look at the actual getrandom implementation in Rust, we see the following:

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/bef753ae-3e7d-4dba-90d8-533ec91cf33b)

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/20b1b1db-bc91-49a3-b68d-81cd133db141)

So I just went in a hex editor and forced the "getrandom available" variable to `0` and patched `/dev/urandom` to `./my_urandom`. Now we can seed the program with whatever we want. I just did `ln -s /dev/zero my_urandom` to start out.

Going back to the part with the random vector, I run it under gdb and just breakpoint after the iter fill call returns. And indeed it has the same random bytes each time, depending on the seed from urandom. We can continue basically just slogging through this function, figuring out the behavior by debugger rather than code because the decompilation is nearly useless.

Sometimes the binary prints "Prime too small". We can see later in the binary there's some code related to this:

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/c4f695a4-7287-418b-9c26-e09b03e9ea4e)

It loads a BigInt from a string. This number also happens to be prime. But what's strange is there isn't any prime generation related code, so what would it mean for the prime to be "too small"? We realized that it's not that a particular random prime number is too small, but rather that our fixed prime parameter is too small as a modulus for some othe random values.

Then there is some MD5 and SHA1 shit, along with some XOR because of course there's MD5 and SHA1.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/3550996f-796a-48c9-be69-102bf58077f7)

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/4c10c654-04ae-4a96-a3de-77fe4cdac165)

It's not very easy to read the code so again it's easier to just debug it. ¯\_(ツ)_/¯

There's also some BigInt shit. It uses the prime P earlier as the modulus, which makes sense. We originally thought it may be using a RSA group ("prime too small") but it's just using a prime group.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/c2b02629-00e8-4b61-b076-17ad706a6c53)

Lastly, we noticed that the binary does 12 repeated rounds per 48-byte input block. While debugging, we just patched this to be 1 round, so the operation is easier to debug.

At this point, after a lot of guess-and-check, we deduced the round operation and fully reimplemented it in Python. Shoutout to Riatre who is a reversing God.

```python3
random_bytes = ...

def derive(seed: bytes, *, m: int) -> bytes:
    assert len(seed) == 12
    arr = [u16(seed[i * 2 : i * 2 + 2]) for i in range(6)]
    out = []
    for i in range(6):
        key = 0
        c0, c1 = arr[(i + 2 * m) % 6], arr[(i + 2 * m + 1) % 6]
        while c0 and c1:
            key ^^= c0 & -(c1 & 1)
            v17 = (c0 << 1) ^^ 0x2B
            if (c0 & 0x8000) == 0:
                v17 = c0 << 1
            c0 = v17 & 0xFFFF
            c1 >>= 1
        out.append(arr[(i + 4 + m) % 6] ^^ key)
    return b"".join(p16(x) for x in out)


def process_block(block: bytes, *, rounds=12) -> bytes:
    assert len(block) == 48
    rv0, rv1 = random_bytes(12), b"\x00"
    b = [block[i * 12 : (i + 1) * 12] for i in range(4)]
    for _ in range(rounds):
        i = [int.from_bytes(x, "little") for x in b]
        rv0, rv1 = derive(rv0, m=0), derive(rv0, m=1)
        cb1 = xor(hashlib.md5(rv0 + b[2]).digest()[:12], b[0])
        bs = ((i[1] + i[3]) * i[0] + pow(i[2], i[1], P)) % P
        cb2 = xor(hashlib.sha1(rv1 + b[2]).digest()[:12], b[1])
        b = b[2], cb1, bs.to_bytes(12, "little"), cb2
```

Analyzing the block cipher, we can see that the design is a shitty Feistel network where the round function is some bullshit based on MD5 and SHA1. The key schedule is generated by the `derive` function. The `derive` function takes in a 12 bytes and outputs 12 bytes, performing operations in [GF(2^16)](https://en.wikipedia.org/wiki/Finite_field_arithmetic), represented with 0x2B as reducing polynomial. It also is parameterized by an additional boolean parameter (which we call `m`) so it can generate two different keys per input.

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/8f062e26-0d6d-41ae-bb55-958e4314f511)

The rest of the network is easy to invert, but the problem is the `derive` function. Converting it from the bitwise implementation to finite field math, here is what we are working with. Let $a = (a_0, a_1, \cdots, a_5)$ be the six elements  vector over the finite field GF(2^16). Then:

$$\text{derive}(a) = \begin{cases}\begin{pmatrix}
a_0 * a_1 + a_4\\
a_1 * a_2 + a_5\\
a_2 * a_3 + a_0\\
a_3 * a_4 + a_1\\
a_4 * a_5 + a_2\\
a_5 * a_0 + a_3\\
\end{pmatrix} & m = 0\\
\begin{pmatrix}
a_2 * a_3 + a_5\\
a_3 * a_4 + a_0\\
a_4 * a_5 + a_1\\
a_5 * a_0 + a_2\\
a_0 * a_1 + a_3\\
a_1 * a_2 + a_4\\
\end{pmatrix} & m = 1\end{cases}$$

To invert `derive`, we have a quadratic system of 6 equations over 6 variables. We can use Sagemath to find the roots. Our equations define a ring ideal and Sage can find its algebraic variety.

```python
def solve_(solve_for, m):

    R.<x> = PolynomialRing(GF(2))   
    irreducible_poly = x^16 + x^5 + x^3 + x + 1
    F = GF(2^16, modulus=irreducible_poly, name='a')

    F_solve_for = [F.from_integer(x) for x in solve_for]

    G.<a0, a1, a2, a3, a4, a5> = F[]
    if m == 0:
        my_id = Ideal(
            a0 * a1 + a4 - F_solve_for[0],
            a1 * a2 + a5 - F_solve_for[1],
            a2 * a3 + a0 - F_solve_for[2],
            a3 * a4 + a1 - F_solve_for[3],
            a4 * a5 + a2 - F_solve_for[4],
            a5 * a0 + a3 - F_solve_for[5],
        )
    elif m == 1:
        my_id = Ideal(
            a2 * a3 + a5 - F_solve_for[0],
            a3 * a4 + a0 - F_solve_for[1],
            a4 * a5 + a1 - F_solve_for[2],
            a5 * a0 + a2 - F_solve_for[3],
            a0 * a1 + a3 - F_solve_for[4],
            a1 * a2 + a4 - F_solve_for[5],
        )
    assert my_id.dimension() == 0
    my_variety = my_id.variety()
    fuckshit = [[
        variety[a0].to_integer(),
        variety[a1].to_integer(),
        variety[a2].to_integer(),
        variety[a3].to_integer(),
        variety[a4].to_integer(),
        variety[a5].to_integer()
    ] for variety in my_variety]
    return fuckshit
```

So now we're done right? NO! There is one final snag.

There can be more than 1 solution to the system! So we need to consider all possible solutions per round recursively. An optimization we can do is that for all rounds we're trying to invert except the final round, we have both rv0 and rv1, and we can further specify the equations from the `m=1` in the ideal. (See solve.py in this repo.)

So finally, we can wrap the whole thing up and decrypt all of the blocks in the encrypted flag. Because the blocks are independent, it can be parallelized across many cores (though be careful to use `spawn` not `fork` as I think Sage uses libsingular as a subprocess and forking will make all the workers try to use the same child process, breaking things) Here's the final result:

![image](https://github.com/perfectblue/ctf-writeups/assets/14918218/c50517e5-cfb6-4d42-8910-45a44efcfd02)

🫡
