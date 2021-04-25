import math
import json
from pwn import *
import subprocess

CNOT = 9
HADAMARD = 4
MEASURE = 13
UNITARY = 12
NOT = 1
RY = 7
SWAP = 10
ZGATE = 3

correct = 0

global curbit
curbit = 0

def measure(qubit_no):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = MEASURE
	data["params"] = [qubit_no]
	r.sendline(json.dumps(data))
	return int(json.loads(r.recvuntil('}').strip())['msg'][-1])

def swap(q1, q2):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = SWAP
	data["params"] = [q1, q2]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def cnot(q1, q2):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = CNOT
	data["params"] = [q1, q2]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def zgate(q1):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = ZGATE
	data["params"] = [q1]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def invert(q1):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = NOT
	data["params"] = [q1]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def h(q1):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = HADAMARD
	data["params"] = [q1]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def ry(angle, q1):
	data = {}
	data["option"]	= "op_on_med"
	data["qubit"] = curbit
	data["operation"] = RY
	data["params"] = [angle, q1]
	r.sendline(json.dumps(data))
	(r.recvuntil('}'))

def dopredict():
	import predict
	start_time = time.time()
	rand_vals = []
	r.sendline(json.dumps({'option': 'money_for_med'}))
	t = json.loads(r.recvuntil('}').strip())
	med_id = int(t['msg'].split('medallion ')[1].split(' now')[0])
	print(med_id)
	for t in range(800):
		r.sendline(json.dumps({"option": "med_for_med", "med_id": med_id}))
		r.recvuntil("New medallion ")
		med_id = int(r.recvuntil(" ")[:-1])
		r.recvuntil("was ")
		bit_str = r.recvuntil(".")[:-1].decode('ascii')
		curr = 0
		for i in range(30):
				if bit_str[i] == '-':
						curr |= (1 << i)
						curr |= (1 << (i + 30))
				elif bit_str[i] == '+':
						curr |= (1 << i)
				elif bit_str[i] == '1':
						curr |= (1 << (i + 30))
				else:
						pass
		bases = curr % 2**30
		bits = curr >> 30
		#print(bases, bits)
		print(t)
		rand_vals.append(bases)
		rand_vals.append(bits)
		r.recvline()
	end_time = time.time()
	print(end_time - start_time)

	predicted = predict.get_remote_random(rand_vals)

	bases = predicted.getrandbits(30)
	bits = predicted.getrandbits(30)
	print(bases, bits)

	r.sendline(json.dumps({'option': 'med_for_money', 'med_id': med_id}))
	r.recvline()

	for t in range(15):
		bases_ = bases
		bits_ = bits
		for i in range(30):
				if bases_ % 2:
						if bits_ % 2:
								r.sendline(json.dumps({'option': 'op_on_med', 'qubit': i, 'operation': 1, 'params': [0]}))
								r.recvuntil('}')
								r.sendline(json.dumps({'option': 'op_on_med', 'qubit': i, 'operation': 4, 'params': [0]}))
								r.recvuntil('}')
						else:
								r.sendline(json.dumps({'option': 'op_on_med', 'qubit': i, 'operation': 4, 'params': [0]}))
								r.recvuntil('}')
				else:
						if bits_ % 2:
								r.sendline(json.dumps({'option': 'op_on_med', 'qubit': i, 'operation': 1, 'params': [0]}))
								r.recvuntil('}')
						else:
								pass
				bases_ //= 2
				bits_ //= 2
		r.recv()
		r.sendline(json.dumps({'option': 'med_for_money', 'med_id': med_id}))
		print(r.recvline())

	r.interactive()


while True:
	# r = remote("localhost", 15213)

	r = remote("fake.medallion.pwni.ng", 15213)
	target = r.recvuntil('\n').strip().decode()
	t = subprocess.check_output(['hashcash', '-mb21', target])
	r.send(t)

	r.recvuntil('result>}')
	r.sendline(json.dumps({'option': 'money_for_med'}))
	t = json.loads(r.recvuntil('}').strip())
	med = t['msg'].split('medallion ')[1].split(' now')[0]
	print("MEDID", med)

	for j in range(30):
		curbit = j
		# print(bank.state_vecs[curbit])
		v1 = math.sqrt( math.asin(0.5 - math.sqrt(0.125)) ) * 2
		v2 = 0
		v3 = v1
		#print(bank.state_vecs[curbit])

		ry(v1, 1)
		cnot(1, 2)
		ry(v2 * 2, 2)
		cnot(2, 1)
		ry(v3, 1)

		cnot(0, 1)
		cnot(0, 2)
		cnot(1, 0)
		cnot(2, 0)

		# h(1)
		# h(2)

		# res = measure(0)
		swap(0, 1)

		"""
		print(bank.state_vecs[curbit])
		# res = measure(0)
		# print(bank.state_vecs[curbit])
		h(1)
		print(bank.state_vecs[curbit])
		c = 0
		for i in bank.state_vecs[curbit]:
			print(bin(c)[2:].zfill(3), i)
			c += 1
		res += measure(1)
		print(res)
		print(bank.state_vecs[curbit])
		exit()"""

		# res = measure(1) + measure(2)
		# if res[0] == "1":
		# 	invert(1)
		# if res[1] == "1":
		# 	invert(2)
		# print(bank.state_vecs[curbit])
		#swap(0, 1)
		"""
		res1 = measure(1)
		res2 = measure(2)
		if res1 == "1":
			invert(1)
		if res2 == "1":
			invert(2)
		print(bank.state_vecs[curbit])
		h(0)
		print(bank.state_vecs[curbit])
		exit()"""
	r.sendline(json.dumps({'option': 'med_for_money', 'med_id': med}))
	res = r.recvuntil("}")
	if "is trying to rob" not in res:
		print("WIN?")
		for j in range(30):
			curbit = j
			swap(0, 2)
		r.sendline(json.dumps({'option': 'med_for_money', 'med_id': med}))
		res = r.recvuntil("}")
		if "is trying to rob" not in res:
			print("ACTUALLY WON")
			print(res)
			dopredict()
			r.interactive()
		print(res)
		r.close()
	r.close()
