# RE02

## Preface
This challenge, I say was a pretty guessy one. I'd say, definitely not what you
would want to be going for when writing an RE challenge. Probably a good RE
challenge should give pretty much everything the solver needs to get the flag.
(For example, the binary could give some reversible progression of steps that
somehow derives some user input to make the actual flag). 

So I started out doing the basic rev (there wasn't much to reverse), but my 
teammates did some of the guessing parts.

## Reversing work

When extracting the binary, we find that it is packed by UPX, simply run:
```bash
upx -d linux_chall
```
When opening up this binary, we note that it is statically linked.

We find locate the main function (the address pointed in RDI in the _start
function) and start doing RE'ing (see the [`linux_chall.c`][1]) for the clean
version of the code.

The program starts with checking if there's a debugger/strace running. This then
sets a variable, (which should be 0xe27fdee2 if no debugger is present). Then it
provides some message asking us to guess the key and a hexdump
DF6C24C58419A0A15127F614BCE0CA05 (which happens to be 16 bytes long), and writes
somewhere in memory some value 00000000e27fdee2. 

In the final step, it requests a password, purposesly allows for a long read
(for buffer overflowing), and checks whether if some cookie value is 0xcocaco1a,
(without this ever being modified directly). If that's the case, it XOR's
something and prints out an incomplete flag: `e27fdee2........ee5ff721e3595e9e`

## Guess G0d
There shouldn't ever be a case where you need to guess something. One of my
teammates decided to relook at this, and find that this hexdump provided earlier
is actually a AES encrypted message!!! :(
```python
from Crypto.Cipher import AES
key = "00000000e27fdee2"
ct = "DF6C24C58419A0A15127F614BCE0CA05".decode("hex")
cipher = AES.new(key, AES.MODE_ECB)
res = cipher.decrypt(ct)
print res
```

This gives us a properly decoded message (properly padded and all) of ccbf9759.
This took us probably hours to figure out. Now we have
`e27fdee2ccbf9759ee5ff721e3595e9e`. 

The next guess component was trying to incorporate some base64url thing into
this :( Again this took us hours to figure out

At the very last moment another teammate suggested dehexing it and then
reencoding it with base64. Okay fine. Turns out to gives us the flag!

```bash
echo e27fdee2ccbf9759ee5ff721e3595e9e | xxd -r -p | base64 | tr '/' '_'
```

[1]: ./linux_chall.c
