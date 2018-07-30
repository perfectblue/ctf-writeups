advertisement
=============

```This platform is under protection. DO NOT hack it.```


------------------------

This check in problem actually took us much longer than it should have. We spent a lot of time lost, not knowing what to do. We ended up wasting a lot of time looking at DIG records and the like. Then, I had a guess that, since the problem was titled "advertisement," the platform was "under protection," and that the DIG records had shown the site had cloudflare enabled, it had something to do with cloudflare on the site. I guessed that it had to do with a custom cloudflare error. However, I did not know how to trigger such an error.

Then, my teammates stepped in! One of us remembered that on another site, popular anime streaming site crunchyroll.com, if you attempt to SQL inject a search bar, a cloudflare error occurs.

![example](https://i.imgur.com/e3ZAIbv.png)

Trying the same thing in flag submission at realworldctf (`' OR 1=1#'`), we are faced with a custom cloudflare error with the flag. Unfortunately we cannot recreate the error now and take a screenshot since submissions are closed and we did not think to take one at the time, but the flag was `rwctf{SafeLine_1s_watch1ng_uuu}` .
