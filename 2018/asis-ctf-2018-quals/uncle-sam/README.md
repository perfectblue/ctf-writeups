# Uncle Sam
**Category**: Crypto

123 Points

35 Solves

**Problem description**:
```
Uncle Sam needs your help!
n = pubkey
```
---

Basically, we are given a [Schmidt-Samoa cryptosystem][3], and we are asked to decrypt a message.

Unlike typical RSA, both the public exponent and modulus are equal to `p^2 * q`.

We are also given the private "key" `d`, computed same as in RSA as `n^-1 (mod (p-1)(q-1))`. But obviously, this key won't work since `phi(n) = p(p-1)(q-1)`.

Instead, we can factor `n` to get `p` and `q` [1][1] [2][2].
All we need to do is choose some `f` such that `x^f = 1 (mod n)` for any `x`.
In other words, we are looking for some `f` such that `f = 0 (mod phi(n))`. Choosing `f = n*(n*d - 1)` satisfies this.

We can factor `n` into `p^2` and `q`, from which we can derive:
 - p=90283324151983679083166250902828927364621992555273501465745336481943551587398798146901458961131622319431816018269486772536549683616910647763719719203638951925052013534698144123544788985653424384928623836686010589957035828183996614812658897926484825393895459587813067203457322795425525192392782516986248456833
 - q=127988874842765807927011278292615322352371086477890531944746680884228840777503937977810152214122207912170923325889067546878570965611227431863593496509238081469536053458560448058736182314094830599199156396955908893874265915850336305616511392689582829370489026871438605804155488458502296366722426801592601778913

Now `phi(n) = p(p-1)(q-1)`, but since `phi(n)` and `e` aren't coprime, we can't simply decrypt by taking a modular inverse and applying Euler's Theorem.

Instead, we apply CRT to mod q to decrypt:
```
x = (p+q-1)^-1 (mod phi)
c_q = enc^x (mod q)
real_d = p^-1 (mod q-1)
m = c_q^real_d (mod q)
```

`ASIS{Y0u_c4N_m4n493_Schmidt_5am0A_CryP7o_SysT3M!!}`

[1]: https://crypto.stackexchange.com/a/9145

[2]: https://crypto.stackexchange.com/a/11510

[3]: https://en.wikipedia.org/wiki/Schmidt-Samoa_cryptosystem
