# Just find flag

After shooting some volatility console commands, there was a comment:
'Stucked? You can ask WallPaper god for help.'

So I got the wallpaper using filescan and dumpfiles. The path was `C:\Users\dora\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg`.

It said: 'Are you finding a password? password is: md5('(full path of the file you want to extract)'.encode()).hexdigest()'.

After that, I found `flag.zip` from `C:\Program Files (x86)\Windows NT\Accessories\flag.zip`.
The password was `hashlib.md5(b'C:\Program Files (x86)\Windows NT\Accessories\flag.zip').hexdigest()` = `0d3ba7db468bdbd4f93a88c97ba7bef1`.

The flag is `n1ctf{0ca175b9c0f7582931d89e2c89231599}`.