# dr

This one is a rust binary implenting a DFA (i.e. for parsing regular
expressions). Each time it takes the input, it *derives* one step forward in the
respective DFA, and also generates a cached character map so that the exact 
derivation step will not need to be done again.

We built a dumper that attached as a gdb hook, run using this command:

```
gdb -p $(pidof dr.6bf2fe826e902621cb39cf94844bbec02bca3181424e029d4f26f477216892f2) -ex 'pie break *0x9436' -ex 'set language c' -ex 'c' -ex 'set $stuff = $rdi - 0x10' -ex 'ni' -ex 'p dump_re($stuff)' -ex 'p clobber($stuff)'
```

(where we `LD_PRELOAD` test.so into the binary so that we have a couple of
exposed functions that we can call from gdb)

To figure out final constraints, we wrote a bruter, and came up with the
insurance policy number of `10174cdbf10810c` with a diagnosis of `sore throat`
(which sets one of the constraints to have a modulus of 31337).
