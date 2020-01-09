We can obviously seem some binary data the top of this dithered image. It sticks out like a sore thumb.
So we extract it with PIL:

```python
from PIL import Image

a = Image.open('homework.png').convert('RGB')
width, height = a.size

bitstream = ''
for y in range(0, 5):
    for x in range(0, width):
        r,g,b = a.getpixel((x,y))
        # print '%d %d %d %d %d' % (x, y, r,g,b)
        if r == 0:
            bitstream += '0'
        else:
            bitstream += '1'

numhex = []
for b in grouper(bitstream, 8, '1'):
    numhex.append(int(''.join(b),2),)
bitstream = numhex
```

Now Let's apply some critical thinking skills for a moment.
The challenge text refers to error correcting codes and the name suggests this is Reed-Solomon.
That makes sense as Reed-Solomon is extremely popular. So let's just straight up google 'ctf reed-solomon'

We can see that this question is more-or-less adapted from Google CTF 2016. So this is a 'BS' question.

Adapting [their solution](http://fadec0d3.blogspot.com/2016/05/google-ctf-2016-magic-codes-250.html):

```python
from reedsolo import *

i = 43
msglen = 117
totallen = msglen+i
copy = bitstream[0:totallen]
try:
    out = RSCodec(i,totallen).decode(copy)
    print out
except Exception as e:
    print e

```

We have to brute force around a bit for the length of the flag and the length of the ECC, but we get 117 and 43 respectively.

So:

`If you can read this then you must be very good at reeding, I guess youve earned this: flag{w0w_r_u_4n_3ngl1sh_m4j0r}`
