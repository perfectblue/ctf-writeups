import os
import string

def xor(a, b):
	c = 0
	for i in range(0, max(len(a), len(b))):
		if a[i] == b[i]:
			c += 1
	return c

ciphertext = open("MeePwn.ascii.bak", "rb").read()
flag = "MeePwn{g0l4ng_AAAAAAAAAAAAAAAAAA}"

for asdf in [(15, 30)]:
	biggest = -1
	biggestchar = ""
	for i in string.letters + string.digits + "_}":
		test = flag[:(asdf[0] - 1)] + i + flag[asdf[0]:]
		os.system("echo '{}' | ./image_crackme.exe  > /dev/null".format(test))
		dicc = open("MeePwn.ascii", "rb").read()
		if dicc[asdf[0] - 1] == ciphertext[asdf[0] - 1]:
			for a in string.letters + string.digits + "_}":
				test = test[:(asdf[1] - 1)] + a + test[asdf[1]:]
				print test
				os.system("echo '{}' | ./image_crackme.exe  > /dev/null".format(test))
				dicc = open("MeePwn.ascii", "rb").read()
				if dicc[asdf[1] - 1] == ciphertext[asdf[1] - 1]:
					temp = xor(ciphertext, dicc)
					if temp > biggest:
						biggest = temp
						biggestchar = (i, a)
						print biggestchar
	print "="*20
	print biggestchar
	print flag
