import numpy as np
import sys

FS = 100000

def dB(x): return np.log10(x) * 10.0

sig = np.fromfile(sys.argv[1], dtype=np.complex64)
assert sig.shape == (FS,)

fa = np.abs(np.fft.fft(sig))
freq_bin = np.argmax(fa)
freq = freq_bin / sig.shape[0] * FS
print('Freq:', freq)

spow = fa[freq_bin] * fa[freq_bin]
npow = np.sum(fa * fa) - spow

snr = spow / npow
snr_db = dB(snr)
print('SNR', snr_db)
