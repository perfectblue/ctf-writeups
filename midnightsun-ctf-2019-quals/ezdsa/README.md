# EZDSA

**Category**: Crypto

223 Points

57 Solves

**Problem description**: Someone told me not to use DSA, so I came up with this.

---

Looking through the algorithm, we notice the main difference between this algorithm and classical DSA is the way k is generated: instead of being completely random, it is generated using

```python
pow(self.gen, u * bytes_to_long(m), self.q)
```

After thinking about it, I thought about trying sending \x00 as message, so that k would be just 1. However, this did not work, because of the check:

```python
assert(bytes_to_long(m) % (self.q - 1) != 0)
```

However, after some more math, we realize that a factor of q-1 may work, since it is multiplied by u. I sent `m = (self.q-1)/2 = STZM6SXqato9bbrezJnvRfLJl6U=` to the server, and we always get the same result back:

```(698847418084580852997663919979623019513778951409L, 629758878500372559472644038362239654961033814558L)```.

This means that k=1, and our attack was successful. From here, it is a simple matter of algebra to find the secret.

```python
r,s=(698847418084580852997663919979623019513778951409L, 629758878500372559472644038362239654961033814558L)
k=1
h = bytes_to_long(sha1('49364ce925ea6ada3d6dbadecc99ef45f2c997a5'.decode('hex')).digest())
rinv = pow(r, 0x926c99d24bd4d5b47adb75bd9933de8be5932f4bL - 2, 0x926c99d24bd4d5b47adb75bd9933de8be5932f4bL)
print ((s*k)-h) * rinv % 0x926c99d24bd4d5b47adb75bd9933de8be5932f4bL
```

```python
>>> 39611266634150218411162254052999901308991
39611266634150218411162254052999901308991L
>>> hex(39611266634150218411162254052999901308991)
'0x746834745f7734735f653473795f65683fL'
>>> '746834745f7734735f653473795f65683f'.decode('hex')
'th4t_w4s_e4sy_eh?'
```

Flag: `th4t_w4s_e4sy_eh?`