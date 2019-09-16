import requests
import os
from music21 import *
from Crypto.Util.number import *
import threading


def _eval_at(poly, x, prime):
    '''evaluates polynomial (coefficient tuple) at x, used to generate a
    shamir pool in make_random_shares below.
    '''
    accum = 0
    for coeff in reversed(poly):
        accum *= x
        accum += coeff
        accum %= prime
    return accum

def _extended_gcd(a, b):
    '''
    division in integers modulus p means finding the inverse of the
    denominator modulo p and then multiplying the numerator by this
    inverse (Note: inverse of A is B such that A*B % p == 1) this can
    be computed via extended Euclidean algorithm
    http://en.wikipedia.org/wiki/Modular_multiplicative_inverse#Computation
    '''
    x = 0
    last_x = 1
    y = 1
    last_y = 0
    while b != 0:
        quot = a // b
        a, b = b, a%b
        x, last_x = last_x - quot * x, x
        y, last_y = last_y - quot * y, y
    return last_x, last_y

def _divmod(num, den, p):
    '''compute num / den modulo prime p

    To explain what this means, the return value will be such that
    the following is true: den * _divmod(num, den, p) % p == num
    '''
    inv, _ = _extended_gcd(den, p)
    return num * inv

def _lagrange_interpolate(x, x_s, y_s, p):
    '''
    Find the y-value for the given x, given n (x, y) points;
    k points will define a polynomial of up to kth order
    '''
    k = len(x_s)
    assert k == len(set(x_s)), "points must be distinct"
    def PI(vals):  # upper-case PI -- product of inputs
        accum = 1
        for v in vals:
            accum *= v
        return accum
    nums = []  # avoid inexact division
    dens = []
    for i in range(k):
        others = list(x_s)
        cur = others.pop(i)
        nums.append(PI(x - o for o in others))
        dens.append(PI(cur - o for o in others))
    den = PI(dens)
    num = sum([_divmod(nums[i] * den * y_s[i] % p, dens[i], p)
               for i in range(k)])
    return (_divmod(num, den, p) + p) % p

def recover_secret(shares, prime):
    '''
    Recover the secret from share points
    (x,y points on the polynomial)
    '''
    if len(shares) < 2:
        raise ValueError("need at least two shares")
    x_s, y_s = zip(*shares)
    return _lagrange_interpolate(0, x_s, y_s, prime)


P = 101109149181191199401409419449461491499601619641661691809811881911




#s = converter.parse("sice.xml")
#print s

def sendfile(filename, seen, shares):

  up = open(filename, "rb")
  files = {'file': up}

  url = "http://crypto.chal.csaw.io:1005/musicin"
  r = requests.post(url, files=files, allow_redirects=True)
  res = r.content
  uuid = res.split("/musicals/")[1].split('"')[0]
  url2 = "http://crypto.chal.csaw.io:1005/musicals/" + uuid
  ret = requests.get(url2)

  sice = ret.content
  piece2 = sice.split("<work-title>")[1].split("</work-title>")[0]
  temp = open(str(piece2) + ".xml", "wb")
  temp.write(sice)
  temp.close()

  new = get_pitches(str(piece2) + ".xml")

  sices = []
  stream = ""
  for i in range(len(new)):
    curnum = 0
    for p in range(12):
      if (p in orig[i] and p not in new[i]) or (p not in orig[i] and p in new[i]) : #one
        curnum = curnum | (1 << p)
    sices.append(curnum)
    stream += hex(curnum).replace("0x", "").zfill(3)
  print stream
  for i in range(40, 60):
    if stream[:i] == stream[i:2*i]:
      stream = stream[:i]
      break
  print piece2
  print stream
  if piece2 in seen:
    return
  seen[piece2] = True
  shares.append([int(piece2), int(stream, 16)])
  if len(shares) > 1:
    print repr(long_to_bytes(recover_secret(shares, P)))
  up.close()
  return


#sice = sendfile("sice.xml")
#a = open("ret.xml", "wb")
#a.write(sice)
#a.close()

def get_pitches(filename):

  s = converter.parse(filename)
  chords = s.chordify().flat.getElementsByClass('Chord')

  original_pitches = []

  for i in range(len(chords)):
    cur_chord = chords[i]
    cur_chord.removeRedundantPitchClasses()
    original_pitches.append([])
    for p in range(12):
      if p in cur_chord.pitchClasses:
        original_pitches[-1].append(p)

  #print original_pitches
  return original_pitches

orig = get_pitches("sice.xml")
#print orig

shares = []

NUM_THREADS = 6
threads = []
piece = []
shares = []
seen = {}

#preprocessing existing downloaded shit
for i in range(4000):
  if os.path.exists(str(i) + ".xml"):
    temp = open(str(i) + ".xml", "rb")
    sice = temp.read()
    temp.close()

    piece2 = sice.split("<work-title>")[1].split("</work-title>")[0]
    temp = open(str(piece2) + ".xml", "wb")
    temp.write(sice)
    temp.close()

    new = get_pitches(str(piece2) + ".xml")

    sices = []
    stream = ""
    for i in range(len(new)):
      curnum = 0
      for p in range(12):
        if (p in orig[i] and p not in new[i]) or (p not in orig[i] and p in new[i]) : #one
          curnum = curnum | (1 << p)
      sices.append(curnum)
      stream += hex(curnum).replace("0x", "").zfill(3)
    print stream
    for i in range(40, 60):
      if stream[:i] == stream[i:2*i]:
        stream = stream[:i]
        break
    print piece2
    print stream
    seen[piece2] = True
    shares.append([int(piece2), int(stream, 16)])
    if len(shares) > 1:
      print repr(long_to_bytes(recover_secret(shares, P)))
 
# sice more shit from network
while True:
  threads = [t for t in threads if t.isAlive()]
  while len(threads) < NUM_THREADS:
    t = threading.Thread(target=sendfile, args=("sice.xml", seen, shares))
    t.start()
    threads.append(t)

print("DONE")
