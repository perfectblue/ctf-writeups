# Power-Level

## Background

This was a signal analysis challenge in which we are given IQ samples. The task was to compute the signal and noise power from this data.

## Solution

Load the 32bit little-endian IQ samples (format was learned by eye-balling the data file in a hex editor):

```
sig = np.fromfile(sys.argv[1], dtype=np.complex64)
FS = 100000 # samplerate
```

Find the frequency by taking an FFT of the entire signal, and picking the bin with largest amplitude:

```
fa = np.abs(np.fft.fft(sig))
freq_bin = np.argmax(fa)
freq = freq_bin / sig.shape[0] * FS
print('Freq:', freq)
```

Get signal and noise power from the same FFT:

```
spow = fa[freq_bin] * fa[freq_bin]
npow = np.sum(fa * fa) - spow

snr = spow / npow
snr_db = dB(snr)
print('SNR', snr_db)
```
