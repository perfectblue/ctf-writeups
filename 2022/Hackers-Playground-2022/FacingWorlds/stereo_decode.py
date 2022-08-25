from scipy.io import wavfile
import scipy.signal as ss
import numpy as np
import matplotlib.pyplot as plt

def decimate(x, n):
    return x[:x.shape[0]//n*n].reshape(-1, n)[:,0]

fs, signal = wavfile.read('./unreal.wav')

print(fs, signal.shape)
lsig = signal[:,0].astype(np.float64) * (1.0/0x800)
rsig = signal[:,1].astype(np.float64) * (1.0/0x800)

win = ss.firwin(1024,
    [ 350, 900 ],
    pass_zero=False,
    fs=fs,
)

lsig = ss.convolve(lsig, win)
rsig = ss.convolve(rsig, win)

lsig.astype(np.float32).tofile('bin.f32')

swin = ss.windows.hann(1024*5)
ls = decimate(ss.convolve(np.abs(lsig), swin), 800)
rs = decimate(ss.convolve(np.abs(rsig), swin), 800)

ts = 10.8
ns = 240
spos = np.linspace(108, (ns-1)*ts, ns).astype(np.int32)

if 1:
    plt.plot(ls[:100000])
    plt.plot(rs[:100000])
    plt.plot(spos, [3500]*ns, 'o')
    plt.show()

if 1:
    sampled = ls[spos] - rs[spos]
    plt.plot(spos, sampled, 'o')
    #plt.plot(spos, (ls[spos] - ls[spos+1])/ls[spos], 'o')
    plt.plot([spos[0], spos[-1]], [1.2e3, 1.2e3])
    plt.plot([spos[0], spos[-1]], [-1.2e3, -1.2e3])
    plt.show()

    symbols = []
    for x in sampled:
        if x > 1.2e3:
            s = 0
        elif x > -1.2e3:
            s = 1
        else:
            s = 2
        symbols.append(s)
    print(symbols)

#t = np.vstack((ldiff, rdiff)).transpose()
#wavfile.write('out.wav', fs, t)
