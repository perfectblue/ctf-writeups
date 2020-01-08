from braindead import *
log.enable()
Args().parse()

r = io.connect(('15.164.75.32', 1999))
while True:
	n = int(r.rla('n = ').decode())
	x = n*(n-2)*(2*n-5)//24
	r.sla(': ', str(x))
