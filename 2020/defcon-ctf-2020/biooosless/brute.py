import time
import subprocess

def attempt(content):
	with open('poc_brute.c', 'w') as f:
		f.write(content)
	t1 = time.time()
	try:
		subprocess.check_output('./attempt.sh', shell=True)
		print 'ii desu ne'
		good = True
	except subprocess.CalledProcessError:
		print 'dame da'
		good = False
	t2 = time.time()
	elapsed = t2-t1
	return good, elapsed

while True:
	print 'checking for mistakes'
	good, elapsed = attempt("")
	if not good:
		print 'we made a mistake somewhere. the flag so far is wrong.'
		break
	else:
		print 'flag so far is OK'

	l = 95
	r = 126
	while l < r:
		m = (l + r) / 2
		print l, r, 'attempt', m
		good, elapsed = attempt("GUESS(flag <= %d);\n" % (m,))
		print 'elapsed', elapsed
		if elapsed < 5:
			print 'this is a bigly fake news. retry'
			continue
		if good:
			r = m
		else:
			l = m + 1
	print 'FOUND', chr(l)
	with open('poc_found.c', 'a') as f:
		f.write("GUESS(flag == '%s');\n" % (chr(l),))
	if chr(l) == '}':
		break