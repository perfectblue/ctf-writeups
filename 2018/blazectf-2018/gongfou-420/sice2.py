#!/usr/bin/env python
#coding: utf-8

import math
import numpy as np
from matplotlib import pyplot as plt
import scipy.io.wavfile as wav
from numpy.lib import stride_tricks
from scipy.optimize import curve_fit

""" short time fourier transform of audio signal """
def stft(sig, frameSize, overlapFac=0, window=np.hanning):
    win = window(frameSize)
    hopSize = int(frameSize - np.floor(overlapFac * frameSize))
    
    # zeros at beginning (thus center of 1st window should be for sample nr. 0)
    samples = sig
    # cols for windowing
    cols = np.ceil( (len(samples) - frameSize) / float(hopSize)) + 1
    # zeros at end (thus samples can be fully covered by frames)
    samples = np.append(samples, np.zeros(frameSize))
    
    frames = stride_tricks.as_strided(samples, shape=(int(cols), int(frameSize)), strides=(samples.strides[0]*hopSize, samples.strides[0])).copy()
    frames *= win
    
    return np.fft.rfft(frames)    
    
""" scale frequency axis logarithmically """    
def logscale_spec(spec, sr=44100, factor=20.):
    timebins, freqbins = np.shape(spec)

    scale = np.linspace(0, 1, freqbins) ** factor
    scale *= (freqbins-1)/max(scale)
    scale = np.unique(np.round(scale))
    
    # create spectrogram with new freq bins
    newspec = np.complex128(np.zeros([timebins, len(scale)]))
    for i in range(0, len(scale)):
        if i == len(scale)-1:
            newspec[:,i] = np.sum(spec[:,int(scale[i]):], axis=1)
        else:        
            newspec[:,i] = np.sum(spec[:,int(scale[i]):int(scale[i+1])], axis=1)
    
    # list center freq of bins
    allfreqs = np.abs(np.fft.fftfreq(freqbins*2, 1./sr)[:freqbins+1])
    freqs = []
    for i in range(0, len(scale)):
        if i == len(scale)-1:
            freqs += [np.mean(allfreqs[int(scale[i]):])]
        else:
            freqs += [np.mean(allfreqs[int(scale[i]):int(scale[i+1])])]
    
    return newspec, freqs

""" plot spectrogram"""

audiopath = "R2-Dbag_to_C3POed.wav"
binsize=2**10
plotpath=None
colormap="jet"
samplerate, samples = wav.read(audiopath)
print '%d samples' % (len(samples),)
s = stft(samples, binsize)

sshow, freq = logscale_spec(s, factor=1.0, sr=samplerate)
ims = 20.*np.log10(np.abs(sshow)/10e-6) # amplitude to decibel

timebins, freqbins = np.shape(ims)

# def getFuckIndex(f):
#     closestFucker = min(freq, key=lambda fucik: abs(f-fucik))
#     fuckerIndex=freq.index(closestFucker)
#     return fuckerIndex

print len(freq),len(sshow) # same as freqbins,timebins
# fuckerIndex=getFuckIndex(4350)
# print fuckerIndex

Poly = lambda coeff: np.vectorize(lambda x: sum(map(lambda (i,a): a*x**i,enumerate(reversed(coeff)))))
imsT = ims.transpose()
def lowpassfactory():#enterprise
    wowe=np.histogram(ims)
    xs=(wowe[1][1:] + wowe[1][:-1]) / 2
    ys=wowe[0]
    poly=np.polyfit(xs,ys,4)
    print poly
    cutoff=sorted(np.roots(np.polyder(poly)))[1] # shitty bimodal fucc
    print 'cutoff: %s' % (cutoff,)
    lowpass=np.vectorize(lambda fuck:int(fuck>cutoff))
    return lowpass
    
    # plt.hist(imsCrop[0])
    # x=np.linspace(xs[0],xs[-1],100)
    # plt.plot(x,Poly(poly)(x))
    # plt.show()

lowpass=lowpassfactory()
def calcFuckers():
    diffs=np.diff(lowpass(ims[0]))
    # plt.plot(diffs)
    # plt.show()
    indices=np.empty((9*2))
    indexIndex =0#yes
    for idx,succ in enumerate(diffs):
        if succ:
            assert(2*((indexIndex+1)%2)-1==succ)
            indices[indexIndex]=idx
            indexIndex+=1
        else:
            assert(succ==0)
    indices=indices.reshape(-1,2)
    return np.floor(indices.mean(axis=1)).astype(int)

fuckers=calcFuckers()
fuckerFreqs = np.array(freq).take(fuckers)
print 'carrier frequencies: %s' % (list(fuckerFreqs))

signal=lowpass(imsT[fuckers])#WOWWWW
data=signal.transpose()
data=np.delete(data,0,1)#delete sync signal
inverse_radix=lambda b:b.dot(2**np.arange(b.size))
result= map(inverse_radix,data)
print data
print ''.join(map(chr,result))

plt.figure(figsize=(15, 7.5))
imsCrop = imsT[100:200].transpose()
plt.imshow(imsCrop, origin="lower", aspect="auto", cmap=colormap, interpolation="none")
plt.colorbar()

plt.ylabel("time (s)")
plt.xlabel("frequency (hz)")
plt.ylim([0, timebins-1])
plt.xlim([0, freqbins])

ylocs = np.float32(np.linspace(0, timebins-1, 5))
plt.yticks(ylocs, ["%.02f" % l for l in ((ylocs*len(samples)/timebins)+(0.5*binsize))/samplerate])
xlocs = np.int16(np.round(np.linspace(0, freqbins-1, 10)))
plt.xticks(xlocs, ["%.02f" % freq[i] for i in xlocs])

# if plotpath:
#     plt.savefig(plotpath, bbox_inches="tight")
# else:
#     plt.show()
    
plt.clf()
#blaze{I_[4N_H4Z_FUN_W1TH_F0UR13R!:>}