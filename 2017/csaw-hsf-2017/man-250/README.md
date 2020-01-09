Man: the entire thing is just red herrings. Extract the filesystems from the zip and the squashfs, notice romfs has a date modified in SEPTEMBER while the rest are date modified from JULY. So that is probably an artifact from Gus creating the problem. Examining it, we diff the two versions of the filesystems; etc/passwd is larger. Flag is there in plaintext.

there are a lot of red herrings in this challenge.
Manuals and man pages have nothing to do with this challenge.
first of all, the filename of the bin suggests it is related to avionics.
It is not. it is chinese IP camera firmware.

let's look now at the binary itself.
first, the binary begins with a zip file containing some filesystems. let's extract these in zip/ and set them aside for later.
next, the binary contains a flag in plain text but it is fake. flag{C329970N4_0WN}
finally the binary contains a squashfs of seemingly the same files as in the zip.

binwalk -eM makes short work of the zip and squashfs.

Let's apply some critical thinking skills for a moment.
looking closely at the extracted squashfs we can see that the date modified for all th files are from july 28,
except for romfs-x.cramfs.img, whcih is from september 10. since the HSF was being conducted from september 22
to october 2, one can deduce this is an artifact left behind by the problem creator Gus Naughton.
so we will look very closely at this image.

we extract both the zip and squashfs versions of the cramfs and do a filesystem diff.
barring timestamps, both filesystems are identical except for the size of the /etc/passwd file,
which has grown in the squashfs version.
https://www.diffchecker.com/QLPHhvFk

there we find the flag.
root:$1$RYIwEiRA$d5iRRVQ5ZeRTrJwGjRy.B0:0:0:root:/:/bin/sh
backdoor:IPCAMS_MORE_LIKE_ICUPCAMS.B0:0:0:root:/:/bin/sh

^ lol, not using flag{} to prevent grepping. classic "BS" problem.

so, flag{IPCAMS_MORE_LIKE_ICUPCAMS}

Note: we obviously took a huge shortcut and metagamed by taking this challenge in the context of a CTF.
if we were "properly" analysing the binary, we would diff all of the filesystems extracted and check what was
different. however, we were able to get away with only checking the odd one out this time. the result is the same either way.

