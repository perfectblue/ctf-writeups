from Crypto.Util.Padding import unpad, pad
from binascii import a2b_base64
from PIL import Image
import numpy as np
from io import BytesIO
import matplotlib.pyplot as plt
import scipy.signal as ss

pulse = [
-5.17084542e-06, -1.72209863e-03, -9.70760655e-03,
 -2.63788266e-02, -5.18742014e-02, -8.46848643e-02, -1.22215181e-01,
 -1.61272451e-01, -1.98485770e-01, -2.30654049e-01, -2.55023205e-01,
 -2.69492493e-01, -2.72750022e-01, -2.64337408e-01, -2.44643607e-01,
 -2.14827895e-01, -1.76672016e-01, -1.32361487e-01, -8.41960651e-02,
 -3.42293722e-02,  1.61609504e-02,  6.63884021e-02,  1.15410825e-01,
  1.61364284e-01,  2.01992174e-01,  2.35031007e-01,  2.58525355e-01,
  2.71071954e-01,  2.71992972e-01,  2.61438438e-01,  2.40417823e-01,
  2.10760789e-01,  1.75007102e-01,  1.36225691e-01,  9.77628838e-02,
  6.29197939e-02,  3.45588683e-02,  1.46395989e-02,  3.68339280e-03,
  1.67602312e-04,
]

basis = np.zeros((14, 280))
for i in range(13):
    basis[i,20*i:20*i+40] = pulse
basis[13,:] = 0.1
basis = basis[:,:256-20]
basis_pinv = np.linalg.pinv(basis.transpose())
print(basis_pinv.shape)

DEC = [
    0,
    15,
    15,
    14,
    13,
    12,
    11,
    11,
    10,
    9,
    8,
    7,
    7,
    6,
    5,
    4,
    3,
    3,
    2,
    1,
]

def get_leak(blob):
    img = Image.open(BytesIO(blob), 'r', formats=['webp'])
    pix = np.asarray(img)
    pix = pix[:,:,0].astype(np.float32) - 128

    votes = [0]*20
    for i in range(256):
        errs = []
        for shift in range(20):
            orig = pix[i,shift:shift+236]
            sol = basis_pinv @ orig
            recov = basis.transpose() @ sol
            e = np.average(np.square(recov - orig))
            errs.append(e)
        votes[np.argmin(errs)] += 1
    lbx = np.argmax(votes)

    votes = [0]*20
    for i in range(256):
        errs = []
        for shift in range(20):
            orig = pix[shift:shift+236,i]
            sol = basis_pinv @ orig
            recov = basis.transpose() @ sol
            e = np.average(np.square(recov - orig))
            errs.append(e)
        votes[np.argmin(errs)] += 1
    lby = np.argmax(votes)

    bx = DEC[lbx]
    by = DEC[lby]
    return bx + by*16

def query(ofs):
    r = remote('noiseccon.seccon.games', 1337)
    sx = 1<<(ofs+64+4)
    sy = 1<<(ofs+64+8)
    r.sendlineafter(b'Scale x: ', str(sx).encode())
    r.sendlineafter(b'Scale y: ', str(sy).encode())
    blob = a2b_base64(r.readline())
    return get_leak(blob)

flag = []
for i in range(21):
    u = query(i*8)
    flag.append(u)

print('flag %s' % flag)
print('flag %s' % bytes(flag))
