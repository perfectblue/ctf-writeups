# GongFou
**Category**: misc

420 Points

90 Solves

**Problem description**:
```
The flag is hiding in plain hearing, in this message from R2-DBag to C-3POed.

Note: this is not a crypto chal.

Author : DuSu
```
---

Forensics? In my CTF? Just kidding, this is a digital signal processing problem.
Now, since I'm stupid, I don't know how to operate GNU Radio so I will hack it with Numpy.

We open it in audacity and we see: ![waterfall](waterfall.png)

Seems pretty simple. This is a frequency-domain serial protocol with 9 carriers: 8 data + 1 sync.

Here are some pretty pictures:

Detecting carrier frequencies

![detecting carriers](Figure_1.png)

Determining binary cutoff amplitude

![polysucc](Figure_1-2.png)

Crappy waterfall plot
![waterfall2](Figure_1-1.png)

```
52224 samples
513 51
[ -4.56962359e-04   3.10117416e-01  -7.58376674e+01   7.81038792e+03
  -2.78418749e+05]
cutoff: 181.413893311
carrier frequencies: [4056.0779727095514, 4311.5789473684208, 4567.0799220272902, 4822.5808966861596, 5078.081871345029, 5333.5828460038983, 5589.0838206627677, 5844.5847953216371, 6100.0857699805065]
[[1 1 1 1 1 1 1 1]
 [0 0 1 0 1 0 1 0]
 [0 0 0 1 0 0 1 0]
 [1 1 0 0 1 1 0 0]
 [0 0 0 0 0 1 0 0]
 [0 1 1 0 0 0 1 0]
 [0 0 1 1 0 0 1 0]
 [0 0 1 0 1 1 0 0]
 [1 1 1 0 0 0 1 0]
 [0 0 0 0 0 1 0 0]
 [1 0 0 1 0 0 1 0]
 [1 1 0 0 1 0 1 0]
 [0 1 0 1 1 1 0 0]
 [0 0 0 0 0 1 0 0]
 [0 1 0 0 0 1 1 0]
 [0 0 1 1 0 1 1 0]
 [1 0 0 0 0 1 1 0]
 [0 1 0 1 1 1 1 0]
 [1 0 1 0 0 1 1 0]
 [1 1 0 1 1 1 1 0]
 [1 0 0 1 0 0 1 0]
 [1 1 1 1 1 0 1 0]
 [1 1 0 1 1 0 1 0]
 [0 0 1 0 1 1 0 0]
 [0 1 1 1 0 0 1 0]
 [1 1 1 1 1 0 1 0]
 [0 0 0 1 0 0 1 0]
 [0 0 1 0 1 1 0 0]
 [0 1 0 1 1 0 1 0]
 [1 1 1 1 1 0 1 0]
 [0 1 1 0 0 0 1 0]
 [1 0 1 0 1 0 1 0]
 [0 1 1 1 0 0 1 0]
 [1 1 1 1 1 0 1 0]
 [1 1 1 0 1 0 1 0]
 [1 0 0 0 1 1 0 0]
 [0 0 1 0 1 0 1 0]
 [0 0 0 1 0 0 1 0]
 [1 1 1 1 1 0 1 0]
 [0 1 1 0 0 0 1 0]
 [0 0 0 0 1 1 0 0]
 [1 0 1 0 1 0 1 0]
 [0 1 0 0 1 0 1 0]
 [1 0 0 0 1 1 0 0]
 [1 1 0 0 1 1 0 0]
 [0 1 0 0 1 0 1 0]
 [1 0 0 0 0 1 0 0]
 [0 1 0 1 1 1 0 0]
 [0 1 1 1 1 1 0 0]
 [1 0 1 1 1 1 1 0]
 [1 1 1 1 1 1 1 1]]
�TH3 FL4G IS: blaze{I_[4N_H4Z_FUN_W1TH_F0UR13R!:>}�
```
