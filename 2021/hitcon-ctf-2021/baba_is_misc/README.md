# Baba is misc

Decrypted and extracted the Switch image with [nstool](https://github.com/jakcron/nstool), using developer keys, and dumped all the file contents to disk.

Copied the Data/Worlds/levels folder into the official level editor software, downloadable from https://hempuli.itch.io/baba-is-you-level-editor-beta. Then we could open up every level from the editor.

The modified games were easily recognizable, because they had corrupted/blanked out overview images. In every modified level, there was a part of the flag written as custom blocks that looked like letters. Writing down each of those, and sorting them by the id of the level when they appeared, gave

```
0 HITCON{
17 BABA IS YOU
21 IS A
80 GOOD
82 GAME
101 BUT
111 TOO 
130 DIFFICULT
176 !!!!!!}
```

and the flag is 

`hitcon{BABA IS YOU IS A GOOD GAME BUT TOO DIFFICULT !!!!!!}`

