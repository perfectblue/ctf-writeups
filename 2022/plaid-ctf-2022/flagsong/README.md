# flagsong

[OpenUtau](https://www.openutau.com) is an application for producing vocaloid music. This challenge provides you with a script for generating an OpenUtau USTX file from a string representing a sequence of diphones (a diphone is a consonant plus vowel) and a melody, and also a WAV file that was exported from OpenUtau. You have to figure out what diphone string produced that WAV file, and that string is the flag.

The first step was to figure out the melody (note pitches and durations). I just did this manually because I happen to transcribe music as a hobby anyway.

Once we have that, the challenge boils down to picking the sequence of diphones. There are 134 unique diphones in this scheme, and the melody is 19 notes long. Diphones can (at least in principle) be identified one by one, but even if the melody were only a couple notes long, doing this manually would take forever.

Automation is needed, and that requires the following non-trivial components:

1. A way to convert USTX files to WAV as part of a script
2. A way to select the "most similar" generated WAV to the target WAV

Then we can just run those two steps in a loop and win.

(1) was tricky because, as far as I could tell, OpenUtau has no CLI. Since I really didn't want to dig into its source code, I automated its GUI with [PyAutoGUI](https://pyautogui.readthedocs.io). I just wrote a script to click "File -> Open Recent -> [first entry]" in OpenUtau to reload the current file, and then "File -> Export Wav Files" to export it as WAV.

For (2), I used MFCC from [python_speech_features](https://python-speech-features.readthedocs.io) to compare each of the 100+ exported WAVs to the target WAV (with the longer one cropped to the length of the shorter), and select the one with the lowset sum of Euclidean distances between corresponding feature vectors. In hindsight, this probably should've used an average, not sum, since this statistic is slightly biased towards shorter syllables.

After about an hour of PyAutoGUI hogging my cursor to furiously export WAVs from OpenUtau, I got "`flag{N3wprA4TLoGOI5NoTaSgOOD}`", which is close but not quite correct. The correct flag was manually guessed from there.
