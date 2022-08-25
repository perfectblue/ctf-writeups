# Dr. Strange

```py
def do_crypt(plain_text):
    out = []
    i = 0
    for p in plain_text:
        p = ord(p)
        d = (ord(KEY[ i % len(KEY) ]) ^ p) * ord(KEY[ (i+1) % len(KEY) ])
        e = (d << p) % 500009
        for pad in range (0, 6-len(str(e))): e*=10
        o = pow(p, e)
        out.append(o)
        i+=1;
    return out
```

As we can see, if we put `p = 0`, the output `o` will be 0. Therefore,
we can easily brute-force each character of `KEY` by sending
`b'\0' * i + bytes([our_input])`. 

I used [mpwn](https://github.com/lunixbochs/mpwn) to communicate with
the process. I had to run the exploit several times as there's a time
limit.