WhiteHat 2020 Quals: Misc 04
==============================

We are given a windows memory dump and a comment "Let me show you, how to getting source code.",
which we will ignore.

Using volatility
================

We detect a suitable volatility profile:
```
$ volatility imageinfo -f kevin_mitnick.1.raw
```
The profile is Win10x64.

We list the processes:
```
$ volatility pslist --profile=Win10x64 -f kevin_mitnick.1.raw | tee pslist
```
Nothing suspicious, mostly chrome.exe.

We look at open/cached files:
```
volatility filescan --profile=Win10x64 -f kevin_mitnick.1.raw | tee filescan
```
Again, nothing much.

GREP to the rescue
==================

Having found no interesting files, we will now look for URLs:

```
egrep -a --only-matching 'https?://[[:print:]]*' kevin_mitnick.1.raw | sort | uniq > urls
```

Drawing from past CTF experience, we look specifically for `dropbox.com`, `docs.google.com` and `drive.google.com` urls.
After going through a few we find `https://drive.google.com/file/d/1trYCpFE5n1X5O0noENhCGjQF3mWuk_xW/view`,
it's a xlsx spreadsheet with one of tabs called "FLAG". 
We download it, unpack it as PKZip archive and grep all files for `WhiteHat`:

```
$ unzip Hotel_Financial_Model_2013_Complete_V6-xls.xlsx
$ grep -rain WhiteHat
xl/sharedStrings.xml:10: ... WhiteHat{SHA1(G00D_J0B_Y0u4r3Dump5oExcellen7)} ...
```
