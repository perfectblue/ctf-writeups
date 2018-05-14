Let's apply some critical thinking skill for a moement.
RSA is a sound cryptosystem when implemented right. If this is in a CTF it must be done wrong.
While a "hard" crypto problem like this may be daunting, we realize that CTFs, especially at the high school level, are all contrived problems which require you to implement some previously discovered solution.
So we simply google for "CTF RSA exploits" and we find a cool python library RSAExploits which lets us try all the popular tricks in the book.
After about 3 minutes it tells us that there were common factors in two of the moduli and it factored them.

Common modulus factor attack works and we get one of the keys.
The problem text says PKCS1 so we use PKCS1-OAEP with PyCrypto and Lo and Behold we get the flag.

```
Python 2.7.12 (default, Nov 19 2016, 06:48:10)
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> from Crypto.Cipher import PKCS1_OAEP
>>> from Crypto.PublicKey import RSA
>>> key = RSA.importKey(open('49.key').read())
>>> cipher = PKCS1_OAEP.new(key)
>>> cipher.decrypt(open('out/49.enc','rb').read())
'flag{kent_cant_deploy_challenges}'
>>>
```
