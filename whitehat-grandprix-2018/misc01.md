misc01 writeup
===============

we are given an iso `Hacker.iso`. Mounting it, and grepping for flag, we find one file in particular stands out:

```15334499.COM:50:Subject: Flag```

It seems that this email has a pgp encrypted image attached to it. We need to find the pgp key. After some quick exploring, in /etc/mail we find `PRIVATE.ASC`, which is his private key. Great, now we just need the passphrase!

This part actually stumped us. We looked around and found a weird facebook bot, so we used the password from that to no avail. We also decompiled the `ENCRYPT.PYC` file and used the `password_enc` as the password, but that didn't work either.

```python
#Embedded file name: ./encrypt.py
import struct
import sys
import base64
password_enc = 'JTd1XyoIbmc3PWhpOjhfVhsIbmcAAAAA'
if len(sys.argv) != 2:
    print 'Usage: %s data' % sys.argv[0]
    exit(0)
data = sys.argv[1]
padding = 4 - len(data) % 4
if padding != 0:
    data = data + '\x00' * padding
result = []
blocks = struct.unpack('I' * (len(data) / 4), data)
for block in blocks:
    result += [block ^ block >> 16]

output = ''
for block in result:
    output += struct.pack('I', block)

print base64.b64encode(output)
+++ okay decompyling ENCRYPT.PYC 
# decompiled 1 files: 1 okay, 0 failed, 0 verify failed
# 2018.08.17 22:49:27 EDT
```


Then I went to sleep.

After I woke up the next day, we tried some more things, until I went back to the encrypt.py file. Then I realized a few things and felt stupid:

1. `password_enc` itself is not used at all in the program
2. `password_enc` is base64 data, and the program outputs base64 data

I then realized `password_enc` was the encrypted password emitted from this program. I then set out to reverse this program with some very simple and lazy python scripts:

```python

>>> data2 = 'JTd1XyoIbmc3PWhpOjhfVhsIbmcAAAAA'.decode('base64')
>>> data2
'%7u_*\x08ng7=hi:8_V\x1b\x08ng\x00\x00\x00\x00'
>>> struct.unpack('I' * (len(data2) / 4), data2)
(1601517349, 1735264298, 1768439095, 1449080890, 1735264283, 0)

>>> for a in range(1601500000,1601600000):
	if (a^a>>16)==1601517349:
		print a

		
1601529936
		
>>> for a in range(1734064298,1736464298):
	if (a^a>>16)==1735264298:
		print a

		
1735290692
>>> for a in range(1754064298,1776464298):
	if (a^a>>16)==1768439095:
		print a

		
1768445023
>>> for a in range(1448080890,1449980890):
	if (a^a>>16)==1449080890:
		print a

		
1449094757
>>> for a in range(1725264283,1745264283):
	if (a^a>>16)==1735264283:
		print a

		
1735290741
>>> blocks = [1601529936, 1735290692, 1768445023, 1449094757, 1735290741, 0]
>>> output = ''
>>> for block in blocks:
	output += struct.pack('I', block)

	
>>> output
'Phu_Dong_Thien_Vuong\x00\x00\x00\x00'
```

With the password `Phu_Dong_Thien_Vuong`, we are able to extract the original SaintGiong.jpg image. By now, the second hint for outguess had come out, so we used outguess to extract data from the image:

```
While the sixth Hung Vuong Dynasty, our country, then called Van Lang was under the menace of the An , situated in the North of Vietnam’s borders.
Hung Vuong King was very worried and assembled his court to prepare a plan of defense for the country. A mandarin of the civil service reminded the King that the original founding King of the country, Lac Long Quan  had instructed that if the country were ever to face danger, it should pray for his help.
In that situation, the King then invoked the spirit of the founding King.
Three days later, a very old man appeared in the midst of a storm and said that he was Lac Long Quan himself. He prophesied that in three years the An from the North would try to invade the country; he advised that the King should send messengers all over the country to seek help from talented people, and that thereafter a general sent from heaven would come to save the country.
Event though three years later, indeed came the tempestuous foreign armies trying to take over the Southern Kingdom. At the capital city of Phong Chau, King Hung Vuong still remembered the instruction from Lac Long Quan.
However Even earlier than, at the village of Phu Dong, County of Vo Ninh, Province of Bac Ninh, a woman in her sixties reported she had seen footprints of a giant in the field.
Amazed, she tried to fit her feet in the footprints and suddenly felt that she was overcome by an unusual feeling.
Thereafter she became pregnant and delivered a boy whom she named Giong. Even at the age of three, Giong was not able to crawl, to roll over, or to say a single word.
Surprisingly, at the news of the messenger from the King, Giong suddenly sat up and spoke to his mother, asking her to invite the messenger over to their home.
He then instructed the messenger to request the King to build a horse and a sword of iron for him so that he could go and chase the invaders away.
When the horse and sword were eventually brought to his home, Giong stood up on his feet, stretched his shoulders, became a giant of colossal proportions, and asked his mother for food and new clothing.
She cooked many pots of rice for him but it was not enough for his appetite. The whole village brought over their whole supply of fabric and it was still not enough for his size.
Giong put his helmet on, carried his sword, jumped on the back of his horse and rode away, as fast as a hurricane. The iron horse suddenly spit fire, and brought Giong to the front line at the speed of lightning. The invaders saw Giong like a punishing angel overwhelming them.
Their armies were incinerated by the flame thrown from the horse's mouth. Their generals were decapitated by Giong’s sword. When it finally broke because of so much use, Giong used the bamboo trees that he pulled up from the sides of the road and wiped away the enemies.
Afterwards, he left his armor on the mountain Soc (Soc Son) and both man and horse flew into the sky.
Legend holds that lakes in the area of mountain Soc were created from the footprints of Giong’s horse. At the site of the forest where he incinerated the enemy armies is now the Chay Village ("Chay" meaning burned).
In recognition of Giong's achievement, King Hung Vuong proclaimed him Phu Dong Thien Vuong (The Heaven Sent King of Phu Dong Village). For the people of his country, he is better known as Thanh Giong ("Saint" Giong)```

While my teammate did not know what to do with this 😂, I immediately noticed that the first letters of each line spelled out words - in particular, `WHITEHATSHWSGTALI`. The flag is WhiteHat{sha1sum(flag)} so `WhiteHat{05cc532353023d5954da9507e189a55296f6db97}` is the final flag.