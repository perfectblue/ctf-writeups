#!/usr/bin/env python
# encoding: utf-8
import os

# notation: we say (i,j) means p_i ⊕ p_j for i, j ∈ [0, |p|]
def op(a,b): # return a ⊕ b
    return a^b

def xor(x,k):
    return map(lambda xi: op(xi, k), x)

cs, l = [], 0
k_min, k_max = 128, 255

cache = {}
def get_pi_xor_pik(i, k): # return (i, i+k)
    if k < k_min or k > k_max:
        raise ValueError('bad k')
    freqs = [0]*0x100
    ik = i+k if i + k < l else i-k
    if (i,ik) in cache:
        return cache[(i,ik)]
    for c in cs:
        freqs[op(c[i], c[ik])] += 1

    dist = sorted(enumerate(freqs), key=lambda t: t[1], reverse=True)
    result, confidence = dist[0][0], dist[0][1]-dist[1][1]
    if confidence < len(cs)/(k_max-k_min+1)/3:
        raise RuntimeError('[%x]^[%x]: low confidence %d' % (i,ik, confidence,))
    cache[(i,ik)] = result
    return result

def oracle(i,j): # oracle for (i, j) for i,j s.t. |j-i| ∈ [k_{min}, k_{max}]
    assert j > i
    assert j-i <= k_max and j-i >= k_min
    print '(%d,%d)' % (i,j),
    return get_pi_xor_pik(i,j-i)

def find(i, j): # generalized oracle for (i, j) = [i] ⊕ [j]
    if j < i:
        return find(j,i)
    if j == i:
        return 0
    gap = j - i
    if gap > k_max: # too far apart
        bridge = i + k_max
        #             k_max        gap - k_max
        return op(find(i, bridge), find(bridge, j))
    elif gap < k_min: # too close together
        bridge = i + k_max
        #             k_max        k_max - gap
        return op(find(i, bridge), find(j, bridge))
    else: # OK
        return oracle(i, j)

print 'Loading',
for filename in os.listdir('ciphers'):
    c = map(ord, open(os.path.join('ciphers', filename), 'rb').read())
    if not l:
        l = len(c)
    elif len(c) != l:
        raise ValueError('bad ciphertext %s' % (filename),)
    cs.append(c)
print '...corpus size %dx%d' % (l, len(cs))

# calculate residue class of [0]
wumbo = [0]*l
for i in range(0,l):
    print "%d:" % (i,),
    wumbo[i] = find(0, i)
    print

for i in range(0,0x100):
    csi = xor(wumbo, i) # csi MIAMI hack the GIBSON
    s = ''.join(map(chr, csi))
    open(os.path.join('outs', str(i)),'wb').write(s)
