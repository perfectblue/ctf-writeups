import itertools
import math
import json
from math import gcd
from functools import reduce
import numpy as np

MOD = 69366296890289401502186466714324091327187023250181223675242511147337714372850256205482719088016822121023725770514726086328879208694006471882354415627744263559950687914692211431491359503896279403796581365981225023065749656346527652480289235008956593933928571457700779656030733229310882472880060831832351425517
#prime_dp = {}

def primeFactors(n):
	ret = set()
	for i in range(1, n):
		if n % i == 0:
			ret.add(i)
	return ret


def primeFactors2(n): 
	#if n in prime_dp:
		#return prime_dp[n]
	  
	ret = set()
	ret.add(1)
	# Print the number of two's that divide n 
	roll = 1
	while n % 2 == 0: 
		roll *= 2
		ret.add(roll)
		n = n // 2
		ret.add(n)
		  
	# n must be odd at this point 
	# so a skip of 2 ( i = i + 2) can be used 
	for i in range(3,int(math.sqrt(n))+3,2): 
		  
		# while i divides n , print i ad divide n 
		roll = 1
		while n % i== 0: 
			roll *= i
			ret.add(roll)
			n = n // i 
			ret.add(n)
			  
	# Condition if n is a prime 
	# number greater than 2 
	if n > 2: 
		ret.add(n)
	#prime_dp[n] = ret
	return ret

def test():
	n = 7
	enc = [0]*n
	idx = 6
	enc[idx] = 1
	tot = 0
	for gcd_res in range(n):
		s = [0]*n
		c = 0
		for P in itertools.product(range(n), repeat=n):
			g = reduce(gcd, P)
			if g == gcd_res:
				temp = [enc[P[i]] for i in range(n)]
				for j in range(n):
					s[j] += temp[j]
				c += 1
		print(gcd_res, c)
		print("TOT", s)
		tot += sum(s)
	print("TOTAL", tot)
# test()
# exit()

def dice(N):
	totals = [0]*(N+1)
	res = {}

	rolling_usage = []
	for i in range(N):
		rolling_usage.append([0]*N)
	zero_uses = {}
	for g in range(0, N)[::-1]:
		if g == 0:
			s = [0, N-1]
		else:
			s = [i for i in range(0, N, g)]
		print("G", g)

		for j in s:
			if j != 0:
				usage_count = len(s)**(N-1)
				usage_count -= rolling_usage[j][g]
				if g != 0:
					uniq = set()
					for k in primeFactors(g):
						rolling_usage[j][k] = (usage_count + rolling_usage[j][k]) % MOD
				totals[j] += ((N * (N-1) // 2) * g * usage_count) % MOD
			else:
				if g == 0:
					usage_count = 1
				else:
					usage_count = len(s)**(N-1) - 1
					for i in range(g * 2, N, g):
						usage_count -= zero_uses[i]
				zero_uses[g] = usage_count % MOD
				totals[0] += ((N * (N-1) // 2) * g * usage_count) % MOD
	return totals

with open('encrypted.json') as f:
	encrypted = json.load(f)

# encrypted = [442, 88, 212, -441, 312, 163, 287, -119, -215]
# encrypted = [442, 88, 212, -441, 312, 163, 287, -119, -215, 12, 64, 36]
# encrypted = [442, 88, 212, -441, 312, 163, 287, -119, -215, 12, 64, 36, 1, 1, 1, 1, 1, 1]
encrypted = [442, 88, 212, -441, 312, 163, 287, -119, -215, 12, 64, 36, 1, 1, 1, 1, 1, 1, 1, 5, 34, 756, 34, 6]


win = dice(len(encrypted))
print(win)

flag = 0
for i in range(len(encrypted)):
	flag += (encrypted[i] * win[i])
	flag %= MOD
print(flag)
print(hex(flag))
print(flag.to_bytes((flag.bit_length() + 7) // 8, byteorder='big'))
exit()
a = open("out", "w")
a.write(str(win))
a.close()


