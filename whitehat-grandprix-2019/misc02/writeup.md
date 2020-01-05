WhiteHat GrandPrix 06 - Misc 2
==============================


What are we going to do now, Elliot???

http://52.78.210.118/Elliot.zip

Hints

After finding "password" string, find correct password to extract file by trying permutation of that string.
Have you watch the video yet ? Just do what he did. Some things are hidden in the picture.

Writeup
-------

We were the only team to solve this one! I had to use the full extent of my brain power to solve this one, but once we figured out the trick, it was relatively straightforward.

We are given a zip file. Inside there is:

```
Ecorp's Encrypted data
	EED2.iso
	junk.DAT
Little help
	audio.wav
	Endding_mr_robot_e10_s3.mp4.mp4
	init.sh
track0.iso
```

Initially, we had no clue on what to do for this challenge. So we tried a huge variety of things! The track0.iso was a password-protected zip file, so we figured the first step was finding the password for it. This was corroborated by the first hint, that mentioned finding a password and permuting it. Here is a list of (a few) things we tried:

1. Finding steganography in audio.wav
	Since the audio and video were separated when given to us, we figured that must be by design, and that there was some sort of steganography in the audio. We downloaded and tried many wav steg tools (DeepSound, steghide, stego_lsb, etc). and none worked. We also viewed spectrograms; that didn't work either. I combined the stereo audio to mono after inverting one track, and found that it canceled out the voice lines, but there was nothing there either. Eventually I gave up and concluded there was no steg in the audio here.
2. Finding steganography in the mp4
	Same concept. Teammate thought that certain frames of the video would have steg in them, but I thought that would be too much work (for both us and the problem writers) and didn't even try.
3. Brute forcing the password to the zip
	A teammate used a 3 gigabyte wordlist to try to crack the zip. It didn't work.
4. Trying permutations of random strings.
	We tried cracking the zip with leetspeak and scrambled versions of "fsociety" "password" "superman" and song lyrics (we searched up the song that was playing in the audio and tried lyrics from it).
5. Trying to operate directly on the EED2.iso and junk.DAT.
	This did not work.

By this time, we had sort of figured out how the challenge would go. We imagined we would have to retrace Elliot's steps to decrypt the "Encrypted E-corp data," which would first involve extracting the track0 from the zip, looking through that in deepsound for image files, extracting steg from the images using stepic, and generating an RSA private key to decrypt with. Then, the second hint came out, and we all got triggered because we had already figured that part out - but we were still stuck on the first part!

Later on, I was looking at the audio file in a hex editor:

![image](hxd_screenshot.png)

And I noticed something quite interesting:

![image](highlight.png)

There's a lot of 1s, 2s, and 3s here! I asked my teammate braindead (who is extremely knowledgeable about everything):

![eureka](eureka.png)

And I knew I had found something! 0, 1, 2, and 3 indicated that the 2 lsb from each of these bytes were being used. I quickly extracted these bytes and got:

```
00010110110001101100001000000111100101101111011101010010000001101110011001010110010101100100001000000111010001101111001000000110101101101110011011110111011100111010011101110111001001101111011011100110011100100000011100000110000101110011011100110111011101101111011100100110010000100000001111010010000001001001010011010011100101000111010111110011100100110101001101110011100100110001001011100111000001101110011001110010000001100001011011100110010000100000011001100010111001101110011000010110110101100101001000000011110100100000011100000110000101110011011100110111011101101111011100100110010000001010
```

Which, after fixing some offsets, gave:

`All you need to know:wrong password = IM9G_95791.png and f.name = password`

With this, everything clicked. We brute forced the password to the zip using the template `IMG_######.png`, using the numbers in the "wrong password," and discovered that the correct password was `IMG_599197.png`. This gave track0 - a rar archive - with 6 images in it. One of the images was named `IMG_599197.png`, and each of them had some lines of python steganography that we obtained using zsteg. 

(For example, this was `IMG_599192.png`)

```
~/ctf/whitehat/Elliot/1.forUser/track0/track0~/track0/My Memories$ zsteg -a IMG_599192.png
/usr/lib/ruby/2.3.0/open3.rb:199: warning: Insecure world writable dir /home/neptunia/.cargo/bin in PATH, mode 040777
imagedata           .. text: "\n\n\n\t\t\t\n\n\n"
b1,bgr,lsb,xy       .. <wbStego size=524292, ext="\x04\x02\x00", data="\x92\b \b\x00A\x00\x10 \x10"..., even=true>
b1,bgr,msb,xy       .. file: raw G3 data, byte-padded
b2,r,msb,xy         .. text: "bUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
b2,g,msb,xy         .. text: "TUUUUUUUUUUUUUUUUUUUUUQUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
b2,rgb,msb,xy       .. text: "uYVeQVUQTuQUEY"
b2,bgr,msb,xy       .. text: "EUVU]TeUTeQ"
b4,r,msb,xy         .. text: "ywwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
b4,g,msb,xy         .. text: "pwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
b4,rgb,msb,xy       .. text: " wzgwpww"
b4,bgr,msb,xy       .. text: "w'wzgwpww"
b8,r,lsb,xy         .. text: "def notrand(n):notrand.i +=1return PBKDF2(master, str(notrand.i), dkLen=n, count =1)notrand.i=0key = RSA.generate(2048, randfunc=notrand)print key.exportKey()"```

This was the same script as Elliot used in the clip from Mr. Robot to generate a RSA key, with only the key size changed from 4096 to 2048. We combined the code to make this script:

```python
from Crypto.Protocol.KDF import PBKDF2
from Crypto.PublicKey import RSA
import getpass
infile = raw_input("File: ")
f = open(infile, 'r')
password = getpass.getpass()
f.seek(1024)
salt = f.read(32)
master = PBKDF2(password, salt, count=10000)
def notrand(n):
    notrand.i += 1
    return PBKDF2(master, str(notrand.i), dkLen=n, count=1)
notrand.i = 0
RSA_key = RSA.generate(2048, randfunc=notrand)
dice = RSA_key.exportKey()

a = open("key", "w")
a.write(dice)
a.close()
```

And ran it, using `IMG_599197.png` as both the key file and password. This resulted in the following RSA key:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAuyFXY7OF2msTPoz58mvwIjlO6bP+GnxgK1W94+1tTiQHg8t9
JMK/j4cDrU7LN5+FDOhchQMHPZ48sTmXZQnjFMwQOmMfDECypcTOklGDWeMHhF3A
RBwqq13XvU09rj/BIv/skI3oU6fiP6RYVtpXqwoL/2lhAy2s/ruZKJwLdyXHoDk+
4+6GG4N28Z0aIMW62cMuXa9sgbEiYyZ46ORLh3IyrxaD9V4jW56EIgZNg/qjmBkH
Wy3esgkybwe+yRq/rezbDnPyFPspI0oUU7n8Co+EUU1uzaJ0+r1eLAu6W1oEfn3J
ZqywvA/k/7M+JSoiH4pTQLwEBV4y/O/ikpVzLQIDAQABAoIBABVnUt+MgRridGkL
JuubfPPtKiGA/Od6omVSgU24sm/lnxZsB/xUaiS4hKsmAAh0rnszeKGeHw3lM3vx
4mckIl0WmiSTgdGc9NIRGK+TszpsxUdWkc84iYjgSvTUCOINWMHwE9bU5GXtJeux
mIkWoEBn/cdQ/k+mwcrBGluSvZz6+xJ8RZ/Kf4ntatOtdcakQ4VnTd1ZvVHsbH44
rNDaT91SEqw+rsNdekmwzlHAvGxglQyvYuDzBF/y5dZuRFdNdEB4b7XqzPQt7oWw
96pfSMnMpb8OFnAqjXcFm5+XJLN6spI/dJiTLLyuPgCNYAXB1C3FV52ucPxG7Vbt
L5UBDAECgYEAzGG3MplkVCoJ5U2mBs3WIwDCRN6SBd5RGw3cykS0Qf4D1n3WNHNn
qZNbrIWl5CjBgBIqbvqYxId0EaOq9rrSu4DSBPrPi9EJSmFUMQwjwbuoUJpoDh8L
ACrzi/Yn4m8OtfwHfLswFT7U+tb58oYWRyMGQ5Rmyrjr8AAhr5cQZyECgYEA6mQ7
1CTVFAMQfjR8FIzJivMircb7tGDsyX8vn4//7WiUVj057Ijr5oyYW3wreHtKk1xA
kubNM788Iu9JSeon7df5xXeNWgF0pYhUgnLKTatWJEnA2lI2Rgngrj397N7tY2DJ
qzNH+Bz1J2ZavoluOPww0hjdVED5clOZyxZF5o0CgYEAuV7zWvhXUCLk4M5hhJBS
5WJ90RsR1DLE20XieK6B080BTBzMGLyHS/20SzDYuqzgfDl9tTSjNLUqaAlLOgdO
tPPtCMk3TzfkNks6olXBZKjAy4KQWCZ9wsQyK0KzACP8csDJRa89uDdJ0s0C3J4T
PKgeuVKzPLEmhYKJCwp3vSECgYEA36FCc+WwZqeF1OO+ftzUbf4L2EFBZZgUUytG
BLcfNyPQY3eHDGaWrCD4PFD8KLd5L5+U/JO4tOaAOdST2DHQZtzpMb4e3wEEierI
tq1O10vhpD26ApLttWU3OQdsfdM0KtztjKogwFjgjfbaHXCB+VykN9ABW6GiXbHl
yh42EwECgYA/2xzmsf89XhZmFc9xQeBLr4WohKj5wObYF7Royc0MiOIi+vFe+9rq
DFiuAcSRof/TAPGRCKw9kr1MMf8N6/coAqRQAKLvYH7LCydd+/4+lAV65oKKeyYi
qhP61hcKEWCZsC6aajokghZvXjskrvWBo1bsfDSqVE9G1SRn2GNHig==
-----END RSA PRIVATE KEY-----
```

And we can use this to decrypt the encrypted E-corp data for the flag!

```
openssl rsautl -decrypt -in ../../../../Ecorp's\ encrypted\ data/EED2.iso -out siceme -inkey ./key
```

Which results in the flag:

`WhiteHat{Th4nk_G0d_Y0u_Ar3_H3r3_Elliot}`


Thoughts
--------

Overall, although it seemed like a pretty toxic challenge at first, it was relatively straightforward after we figured out the first step. We were definitely overthinking it.

![yay](cheer.gif)

