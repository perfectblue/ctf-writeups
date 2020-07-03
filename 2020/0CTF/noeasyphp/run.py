import os

for m in range(0x30000, 0x50000, 0x100):
    os.system("stdbuf -oL python2 sice.py {} {} >> logs/sice{}.log &".format(m, m+0x100, m))
