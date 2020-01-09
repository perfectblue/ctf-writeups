#!/usr/bin/env python
#coding: utf-8
import math
import numpy as np
from matplotlib import pyplot as plt
import scipy.io.wavfile as wav

def encode_wav(cmd,file):
    #we skip 3 because enterprise
    pulse_size=1024
    sample_freq=32768
    # freqs = np.array([4056.0779727095514, 4311.5789473684208, 4567.0799220272902, 4822.5808966861596, 5078.081871345029, 5333.5828460038983, 5589.0838206627677, 5844.5847953216371, 6100.0857699805065])
    freqs = np.array([4100,4350,4600,4860,5120,5370,5630,5880,6140])
    pulse = lambda f: np.vectorize(lambda t: np.sin(f*t*2*np.pi))
    signal = lambda b, t: np.sum(b*pulse(freqs.take(np.arange(len(b))))(t))

    input='\xFFEXEC' + cmd +'\xFF'
    samples=np.zeros(pulse_size*len(input))
    data=np.full((len(input),9),1) # sync
    data[:,1:] =np.fliplr(np.unpackbits(np.array(map(ord,input), dtype=np.uint8)).reshape(len(input),8))
    sample,t=0,0
    for i,b in enumerate(data):
        for _ in np.arange(0,pulse_size):
            carrier = np.sin(np.pi*sample/float(pulse_size))
            value = np.sum(b.dot(pulse(freqs.take(np.arange(0,len(b))))(t)))*carrier
            samples[sample] = value
            sample += 1
            t += 1/float(sample_freq)
        samples[sample-pulse_size:sample] /= np.max(np.abs(samples[sample-pulse_size:sample]),axis=0) # normalize to 0,1
        # print b
    assert(sample) == len(samples)
    samples*=32767
    samples=samples.astype(np.int16)#16bit pcm
    wav.write(file,32768,samples)

if __name__ == '__main__':
    import sys
    cmd='ls'
    if len(sys.argv)>1:
        cmd=sys.argv[1]
    encode_wav(cmd,'test.wav')
