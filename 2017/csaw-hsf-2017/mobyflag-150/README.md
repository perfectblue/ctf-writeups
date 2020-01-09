opening the pcap in wireshark, we see a bunch of UDP streams.
stream #4 seems to be the most interesting so we follow it and dump it raw.

the first thing we notice is that there is a lot of control sequences like <ENTER>, <BACKSPACE>, and <Shift_L>.
so we first replace all of the <ENTER> with newlines, since that is the easiest.
then we apply some clever regexing to take care of the <BACKSPACE>s.
We need to be careful, however, so that we do not backspace 'into' a control sequence for consecutive <BACKSPACE>s.

for the <SHIFT_L>s, we guess that it probably means to apply the Shift key on a keyboard to the next character.
so to confirm our hypothesis we search for flag<Shift_L>[.
Bingo, that's our flag.

flag<Shift_L>[Hax0r<Shift_L>-Typ3Rz<Shift_L>-PassW3rdz!<Shift_L>]

AFter fixing up the SHIFTs:

flag{Hax0r_Typ3Rz_PassW3rdz!}
