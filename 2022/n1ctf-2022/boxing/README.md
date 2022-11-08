# boxing

Basically a copy of Flareon-8 challenge 3 ("Antioch").

You need to arrange files from some docker layers in the correct order.
This time the binary was modified to print out `c = RSA-encrypt(hash, e, p*q)
for some image layer tags. The encryption was not uniquely invertible, because
`p`, `q` and `e` were chosen completely randomly, but we got `(c,e,p,q)` and
could just check each hash if it matched the output run from the challenge
files. I then extracted all the docker layers in that specific order,
overwriting files as I went. When I tried to run "getflag", it complained that
the file "p" was missing, so I extracted another docker layer that contained
that file, and then the flag got printed. I didn't reverse the binary, but I'm
assuming it is just XORing all the files together or something, like the
Flare-On challenge it was heavily inspired by. 