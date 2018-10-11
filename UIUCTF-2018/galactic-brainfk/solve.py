import socket
import time, threading

def test(inp):
	r = socket.socket()
	r.connect(("challenges2.uiuc.tf", 11338))
	recved = ""
	while "Gimme a flag >" not in recved:
		recved += r.recv(2)
	start = time.time()
	r.send(inp + "\n")
	recved = ""
	while "\n" not in recved:
		recved += r.recv(1)
	if "SMOL BRAIN" not in recved:
		r.close()
		return 0
	end = time.time()
	r.close()
	return end - start

def get_avg_time(inp, q=[]):
	result = []
	for a in range(5):
		result.append(test(inp))
	result.sort()
	print [result[2], sum(result) / 5, inp]
	q.append((result[2], inp))

flag = "flag{briang}"
#bria?
charset = "abcdefghijklmnopqrstuvwxyz_" + "9876543210"
while True:
	biggest = -1
	biggestchar = ""
	q = []
	
	for i in range(0, len(charset), 1):
		get_avg_time(flag + charset[i], q)
		#threads = []
		#for b in range(1):
		#	if i + b < len(charset):
		#		t = threading.Thread(target=get_avg_time, args=(flag + charset[i + b], q))
		#		t.start()
		#		threads.append(t)
		#for b in threads:
		#	b.join()
	print q
	biggest = -1
	biggestflag = ""
	for i in q:
		if i[0] > biggest:
			biggest = i[0]
			biggestflag = i[1]
	print biggest
	flag = biggestflag
	print flag
