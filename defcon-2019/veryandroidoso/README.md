# veryandroidoso

**Category**: Reversing

---

Basically Android flag checker app, flag content is 18 hex digits, 9 bytes. These 9 bytes are passed into `Solver#solve`. This function just checks the 9 bytes values to see if they are correct. See the  'src' directory for decompiled sources. Solution is in directory `solution`

There is some really stupid crap mixed into the checking algorithm. The most annoying one is `getSecretNumber` which takes in a byte and derives some output number based on the hash of the apk's signature. You can do this statically but I was really lazy so I just used Android Studio debugger to evaluating it for all possible inputs 0-255 and cache the results. There is `sleep` which basically just returns the input in a very complicated manner. There are also some native lib functions which do some fancy math but I also did not feel like reversing these so I simply just LD_PRELOADed the Android system libraries and called the native lib functions directly to brute force. Extremely mechanical challenge with very little thinking required.

Each of the 9 inputs is checked slightly differently which is really annoying. There are some constraints on the inputs individually and some constraints on all of them combined. The solver utilizes that to narrow down the search space by selecting a set of candidate values for each of the 9 inputs, and only then trying combinations of the candidates.

In the end we get a nice flag.

```
$ LD_LIBRARY_PATH=. java -Djava.library.path=. ooo.defcon2019.quals.veryandroidoso.Solver
search space 1*1*2*2*16*64*1*1*256=1048576
.....................................................................................................................................*
true
true
true
OOO{fab43416484944beba}
```

**Update: apparently, the author wrote this intending for it to be solveable with angr. Read his writeup here:** http://antoniobianchi.me/posts/ctf-defconquals2019-veryandroidoso/
