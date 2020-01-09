WhiteHat 2020 Quals: Crypto 03
==============================

We are given a python implementation of some unknown cipher, ciphertext
`3de950493ad1c29b5f9ae4ac5587c88ff8a6e18bbd642f2d84ce`, key `this_is_whitehat`,
nonce `do_not_roll_your_own_crypto` and a "salt" `once_upon_a_time`.

Cipher initialization generates four 5-bit numbers `a, b, c, d` and uses them
along with the key, nonce and salt to initialize `self.rotor`, an array of five 64-bit words.
Details of this do not matter.

During encryption `self.rotor` is used like a duplex sponge:

```python
# pseudocode
def encrypt(plaintext):
	ciphertext = []
	for block in plaintext:
		rotor[0] ^= block
		ciphertext.append(rotor[0])
		permute(rotor, c)
```

Where `permute` is the unkeyed permutation from [Ascon](https://ascon.iaik.tugraz.at/).

Solution
========

All we have to do is guess the value of `a, b, c, d` and reverse `encrypt()`:

```python
# pseudocode
def decrypt(ciphertext):
	plaintext = []
	for block in ciphertext:
		block ^= rotor[0]
		rotor[0] ^= block
		plaintext.append(block)
		permute(rotor, c)

def guess():
	for abcd in generate_all_abcd():
		c = Cipher(key, nonce, salt, abcd)
		plaintext = c.decrypt(ciphertext)
		if all_ascii(plaintext):
			print(plaintext)
```

For full solution see [oracle2.py](./oracle2.py). Run it with pypy for faster execution.
