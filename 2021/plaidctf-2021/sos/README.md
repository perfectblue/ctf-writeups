# sos, sos-mirage

The goal we want to reach is to have some sort of function with the signature `a
-> b`, i.e. the "magic" function. Once we have this primitive, we can take
advantage of relatively unwrapped integers to try to fake some other pointers.

Of course, the `magic` function is sandboxed out, so we don't have access to
that. There is in fact, however, [huge hole in the ocaml type system][1], that
allows us to do just that, so lets use that to our advantage.

Once we have `a -> b`, we can mutable references to read from and write to
values, thus giving us our primitive arbitrary read and writes (there is a
slight problem with us only being able to read/write 56 bits since apparently
some of the bits are used for internal mangling of the integer).

Here the hardest part is to try to get a stable pointer on the actual ELF
binary, since any changes in our code would throw off any actual
pointers/offsets that we would have had beforehand. So what this code does, is
first searches for the ELF header (`\x7fELF\x02\x01\x01`) data to find our
program base, from our leaked pointer, then we use the entrypoint found in the
ELF header to try to locate the pointer to `__libc_start_main` in glibc, which
gives us a libc leak. At that point, we can use an arbitrary write and write
system to get shell!

[1]: https://moraprogramming.hateblo.jp/entry/2020/10/14/185946
