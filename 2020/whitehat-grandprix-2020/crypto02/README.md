WhiteHat 2020 Quals: Crypto 02
===============================

In this challenge, we have a secret question that is first base64-encoded and then encrypted using AES-CTR and sent to us. We then have to answer this question to get the flag.

```py
def encrypt(s, nonce):
        s = b64encode(s)
        crypto = AES.new(key, AES.MODE_CTR, counter=lambda: nonce)
        return b64encode(crypto.encrypt(s))
```

The AES-CTR implementation uses `lambda: nonce` as the counter, which means that it will use the same nonce for every block. This means, we essentially have a repeating xor with a 16-byte key.

We cannot use normal crib dragging techniques here as the plaintext is base64-encoded first. The nonce is also randomly generated every time we get a new question, so we have to treat each 
question as a independent problem. This also means we can only answer the question we last asked for. We have a wrong decryption oracle here, which means we can send arbitrary ciphertext and know
if it was correct or not.

Using all these knowledge, I tried to reduce the keyset by exploiting the property that the plaintext was a base64 encoded string.

```py
charset = '=+/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

key_sice = []

for i in range(16):
    sice = []
    for j in range(256):
        corr = True
        for k in range(i, len(enc), 16):
            if xor(enc[k], chr(j)) not in charset:
                corr = False
                break
        if corr:
            sice.append(j)
    print sice
    key_sice += [sice]
```

First, for each character of the 16 byte key, we try all possible values from 0 to 256 and find the values which decrypt the ciphertext to a
valid base64 character in the positions where the key is repeated. This reduces our search space for each byte by almost 1/4 th.

Next we use the property that, every 4 contiguous base64 characters are converted to 3 bytes of actual data. This means, we can group the key bytes into groups of 4,
and try all possible combinations of making these 4 groups. For each possible key group, we use it to decode the ciphertext into some base64 data, which we try to decode.
If it succesfully decodes into printable english characters, then we add the key combination to our options.

```py
charset2 = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[]^_`{|}~ '

opts = []
for i in range(0, 16, 4):
    curr_opts = []
    print i
    curr_keys = key_sice[i:i+4]
    for comb in itertools.product(*curr_keys):
        corr = True
        for j in range(i, len(enc)/16 * 16, 16):
            curr_block = enc[j:j+4]
            curr_dec = None
            try:
                curr_dec = b64decode(xor(curr_block, ''.join(map(chr, comb))))
            except TypeError:
                corr = False

            if corr == False:
                break

            corr_2 = True
            for c in curr_dec:
                if c not in charset2:
                    corr_2 = False
                    break
            if not corr_2:
                corr = False
                break
        if corr:
            curr_opts.append(comb)
    print len(curr_opts)
    opts.append(curr_opts)
    print ""
```

Once we have a set of key groups, ie key options for [0:4], [4:8], [8:12], [12:16], we can combine all of those to generate all possible valid keys, and use those to decrypt the entire
plaintext. Now, this will obviously generate a lot of keys, so we have to use some heuristics to reduce our keyspace. At first I tried picking around 10-20 random keys from the keyspace
and using them to decrypt the ciphertext. From this I noticed that many of the decrypted plaintexts had curly braces at the beginning or the end. I took an educated guess that
the original question was a json object and added checks in my second key-group brute to make sure the first and the last block would have the curly braces ensuring JSON object.

```py
            if j == 0 and curr_dec[:2] != '{"':
                corr_2 = False
            if j == 92 and curr_dec[-2:] != '"}':
                corr_2 = False
```

Using this reduced my keyspaces further, but I still had a lot of keys and no good way of determining the correct one. So I went back to my random decryption method,
and noticed a number of plaintexts had a misspelling the word "answer" with different cases in them. So I tried to look for plaintexts which had answer as a key in the JSON object.

```py
for key_comb in itertools.product(*opts):
    test_key = []
    for i in range(4):
        test_key += list(key_comb[i])
    dec_b64 = xor(enc, ''.join(map(chr, test_key)))
    dec = b64decode(dec_b64)
    if '"answer=' in dec:
        print repr(dec)
```

We have to try this on multiple ciphertexts, because often our checks are too strong and it does not find any good keys, or it finds too many possible keys and it is not feasible for us
to go through all the key combinations. After a couple of tries, we find a ciphertext that hits the sweet spot, and we get a large number of valid ciphertexts.

```py
0
32

4
175

8
220

12
2

Total:  2464000
'{"a":593e0,"b":9157<a"y":16085,%>m":"yf05j"(kZ":1495,"atk:"answer=a*3"}'
'{"a":593j0,"b":9157<n"y":16085,%:m":"yf05j"(hZ":1495,"ath:"answer=a* "}'
'{"a":595%0,"b":91577!"y":16085,#~m":"yf05j"++Z":1495,"ar+:"answer=a+s"}'
'{"a":59500,"b":91577,"y":16085,#tm":"yf05j"+"Z":1495,"ar":"answer=a+Z"}'
'{"a":595-0,"b":91577)"y":16085,#wm":"yf05j"+#Z":1495,"ar#:"answer=a+["}'
'{"a":595+0,"b":91577/"y":16085,#ym":"yf05j"+%Z":1495,"ar%:"answer=a+]"}'
.
.
.
```

As we can see, these look almost like valid JSON with some typos in it. So we can filter the ciphertexts even more by printing the ones that are valid JSON.

```py
    if '"answer=' in dec:
        try:
            json.loads(dec)
            print repr(dec)
        except ValueError:
            pass
```

Using this, we find the right plaintext:

```py
0
32

4
175

8
220

12
2

Total:  2464000
'{"a":59400,"b":91578,"y":16085,"tm":"yf05j","Z":1495,"as":"answer=a*Z"}'
```

We can now submit this answer to the remote and get the flag:

```
Your choice: 1
 iMeec1JxJBSHe4zO8wdMmrTXnS1UTw4UhlW6yvcqUJqi1JEpVl8sFIRsl4ncF3LFpNC4dlZfHVSBRqrQ6S1yxaDqhS5VSDxMkXeQ0PEtcZuP0JooQUMCHJF8rdj3KgvO
1. Get challenge
2. Solve challenge
Your choice: 2
 Your question: iMeec1JxJBSHe4zO8wdMmrTXnS1UTw4UhlW6yvcqUJqi1JEpVl8sFIRsl4ncF3LFpNC4dlZfHVSBRqrQ6S1yxaDqhS5VSDxMkXeQ0PEtcZuP0JooQUMCHJF8rdj3KgvO
 Your answer: 88803000
 Right! Here is your flag: w0rk_sm4ter_n0t_h4rd3r_!@&#^!!!
1. Get challenge
2. Solve challenge
Your choice:
```

Check `solve.py` for the full script.
