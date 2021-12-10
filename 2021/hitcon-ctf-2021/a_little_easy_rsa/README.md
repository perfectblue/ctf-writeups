# a little easy rsa

As we know `enc = flag^e mod n`, we can get `flag^q mod n` by `enc^N mod n`. By assuming `flag` is small enough, it's possible to solve with the Coppersmith method. The flag is `hitcon{~~so_triviAl_coPper5mitH~~}`.