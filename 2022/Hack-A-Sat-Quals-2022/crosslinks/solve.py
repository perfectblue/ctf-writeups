from pwn import *
from skyfield.api import load, wgs84
from skyfield.framelib import ecliptic_J2000_frame
from math import floor
import numpy as np
from math import sin, cos, acos, sqrt
from numpy.linalg import norm
from numpy import sqrt, dot, cross
from skyfield.framelib import \
		true_equator_and_equinox_of_date as of_date

def proj(u, v):
	v_norm = np.linalg.norm(v)
	return (np.dot(u, v) / v_norm**2) * v

r = remote("crosslinks2.satellitesabove.me", 5400)
r.recvline()
r.sendline(b"ticket{oscar561388quebec3:GAaopaxYK9ldU3wbbDC6XAqeccNoornlfDo_jptrIyXfq-B-yjLnteC7KLBkgFZzzg}")
data = r.recvuntil(b"What's my position").replace(b"What's my position", b"").strip()

tles = data.split(b"TLE")[1].split(b"Measurements")[0].strip()
with open("comms.tle", "wb") as f:
	f.write(tles)

t = load.timescale()

observations = {}
for i in data.split(b"Measurements")[1].strip().split(b"\n"):
	if b"Observations" in i:
		cur_sat = int(i.split(b"-")[-1])
		observations[cur_sat] = []
	if b"Time, " in i:
		continue
	if i.startswith(b"2022"):
		date, range_, range_rate = i.split(b", ")
		range_ = float(range_)
		range_rate = float(range_rate)
		year = int(date.split(b"-")[0])
		month = int(date.split(b"-")[1])
		day = int(date.split(b"-")[2].split(b"T")[0])

		hour = int(date.split(b"T")[1].split(b":")[0])
		minute = int(date.split(b"T")[1].split(b":")[1])
		second = float(date.split(b"T")[1].split(b":")[2].split(b"+")[0])
		ts = t.utc(year, month, day, hour, minute, second)
		observations[cur_sat].append((ts, range_, range_rate))	

print(observations)

comms = load.tle_file("comms.tle")

sat_dic = {}

for sat in comms:
	print(sat)
	key = int(str(sat).split("-")[1].split()[0])
	sat_dic[key] = sat

def trilaterate(P1,P2,P3,r1,r2,r3):											
		temp1 = P2-P1																				
		e_x = temp1/norm(temp1)															
		temp2 = P3-P1																				
		i = dot(e_x,temp2)																	 
		temp3 = temp2 - i*e_x																
		e_y = temp3/norm(temp3)															
		e_z = cross(e_x,e_y)																 
		d = norm(P2-P1)																			
		j = dot(e_y,temp2)																	 
		x = (r1*r1 - r2*r2 + d*d) / (2*d)										
		y = (r1*r1 - r3*r3 -2*i*x + i*i + j*j) / (2*j)			 
		temp4 = r1*r1 - x*x - y*y														
		if temp4<0:																					
			return None
		z = sqrt(temp4)																			
		p_12_a = P1 + x*e_x + y*e_y + z*e_z									
		p_12_b = P1 + x*e_x + y*e_y - z*e_z									
		return p_12_a,p_12_b			 

def compute_radius(sat, t, d):
	pos = sat.at(t).position.to("km")
	vel = sat.at(t).velocity
	pos = pos.value
	x, y, z = pos
	radius = d
	origin = np.array(pos)
	return radius, origin

def compute_rr_error(velocities, pos, pr=False):
	least_error = 9999999999999999999.0
	win_num = 0
	results = []
	for vel in velocities:
		error = 0.0
		for observe_num in observations:
			# sat_num observe observe_num
			for observation in observations[observe_num]:
				if observe_num not in sat_dic:
					continue
				ts, range_, range_rate = observation
				sat_loc = pos
				observe_loc = sat_dic[observe_num].at(ts).position.to("km").value

				# 'au_per_d', 'km_per_s', 'm_per_s'
				sat_vel = vel
				observe_vel = sat_dic[observe_num].at(ts).velocity.km_per_s

				p = proj(observe_vel - sat_vel, observe_loc - sat_loc)
				calc_range_rate = np.linalg.norm(p)
				unit_vec = np.dot(observe_vel - sat_vel, observe_loc - sat_loc)
				unit_vec = unit_vec / abs(unit_vec)
				calc_range_rate = np.linalg.norm(p) * unit_vec

				if pr: print("RR", calc_range_rate, range_rate)

				error += abs((calc_range_rate) - (range_rate))
		# print("{},{},{}".format(vel[0], vel[1], vel[2]), error)
		results.append((error, "{},{},{}".format(vel[0], vel[1], vel[2]).encode()))
		if error < least_error:
			least_error = error
			win_num = vel
	results.sort()

	print(results[:200])
	return win_num, least_error, results

def compute_error(positions):
	least_error = 9999999999999999999.0
	win_num = 0
	results = []
	for pos in positions:
		error = 0.0
		for observe_num in observations:
			# sat_num observe observe_num
			for observation in observations[observe_num]:
				ts, range_, range_rate = observation
				observe_loc = sat_dic[observe_num].at(ts)

				sat_vec = pos
				observe_vec = np.array(observe_loc.position.to("km").value)
				distance = np.linalg.norm(sat_vec - observe_vec)
				error += (distance - range_)**2
		print(pos, error)
		results.append((error, pos))
		if error < least_error:
			least_error = error
			win_num = pos
	results.sort()
	for i in results[:1000]:
		print(i)
	return win_num, least_error, results

poss_pos = []

keys = list(observations.keys())
for i in range(len(keys)):
	for j in range(len(keys)):
		for k in range(len(keys)):
			if i != j and j != k and i != k:
				r1, o1 = compute_radius(sat_dic[keys[i]], observations[keys[i]][0][0], observations[keys[i]][0][1])
				r2, o2 = compute_radius(sat_dic[keys[j]], observations[keys[j]][0][0], observations[keys[j]][0][1])
				r3, o3 = compute_radius(sat_dic[keys[k]], observations[keys[k]][0][0], observations[keys[k]][0][1])

				res = trilaterate(o1, o2, o3, r1, r2, r3)
				if res is not None and not np.any(np.isnan(res[0])):
					bad1 = False
					bad2 = False
					for l in poss_pos:
						if np.linalg.norm(res[0] - l) < 5:
							bad1 = True
						if np.linalg.norm(res[1] - l) < 5:
							bad2 = True
						if bad1 and bad2:
							break
					if not bad1:
						poss_pos.append(res[0])
					if not bad2:
						poss_pos.append(res[1])
			if len(poss_pos) > 1000:
				break
		if len(poss_pos) > 1000:
			break
	if len(poss_pos) > 1000:
		break
print(poss_pos)
pos, error, pos_results = compute_error(poss_pos)
pos_error = error
print(pos, error)
for i in pos_results[:200]:
	print(i)

r.close()

for pos_error, pos in pos_results[::4]:

	poss_vel = []
	keys = list(observations.keys())

	for i in range(len(keys)):
		for j in range(len(keys)):
			for k in range(len(keys)):
				if i != j and j != k and i != k:
					vo1 = sat_dic[keys[i]].at(ts).velocity.km_per_s
					vo2 = sat_dic[keys[j]].at(ts).velocity.km_per_s
					vo3 = sat_dic[keys[k]].at(ts).velocity.km_per_s
					# vo1 = np.reshape(vo1, (3, 1))
					# vo2 = np.reshape(vo1, (3, 1))
					# vo3 = np.reshape(vo1, (3, 1))

					r1 = observations[keys[i]][0][2]
					r2 = observations[keys[j]][0][2]
					r3 = observations[keys[k]][0][2]

					rso_k1 = sat_dic[keys[i]].at(ts).position.to("km").value - pos
					rso_k2 = sat_dic[keys[j]].at(ts).position.to("km").value - pos
					rso_k3 = sat_dic[keys[k]].at(ts).position.to("km").value - pos
					# rso_k1 = np.reshape(rso_k1, (3, 1))
					# rso_k2 = np.reshape(rso_k2, (3, 1))
					# rso_k3 = np.reshape(rso_k3, (3, 1))

					p1 = rso_k1 / np.linalg.norm(rso_k1) * r1
					p2 = rso_k2 / np.linalg.norm(rso_k2) * r2
					p3 = rso_k3 / np.linalg.norm(rso_k3) * r3

					# p_matrix1 = (rso_k1 * (np.transpose(rso_k1) * rso_k1)[0][0]) @ np.transpose(rso_k1)
					# p_rhs1 = p_matrix1 @ vo1 - p1
					# p_matrix2 = (rso_k2 * (np.transpose(rso_k2) * rso_k2)[0][0]) @ np.transpose(rso_k2)
					# p_rhs2 = p_matrix2 @ vo2 - p2
					# p_matrix3 = (rso_k3 * (np.transpose(rso_k3) * rso_k3)[0][0]) @ np.transpose(rso_k3)
					# p_rhs3 = p_matrix3 @ vo3 - p3

					# A = np.vstack((p_matrix1, p_matrix2, p_matrix3))
					# B = np.vstack((p_rhs1, p_rhs2, p_rhs3))

					v1 = rso_k1 * np.dot(vo1, rso_k1) / np.dot(rso_k1, rso_k1) - p1
					v2 = rso_k2 * np.dot(vo2, rso_k2) / np.dot(rso_k2, rso_k2) - p2
					v3 = rso_k3 * np.dot(vo3, rso_k3) / np.dot(rso_k3, rso_k3) - p3

					w1 = np.linalg.norm(v1) * np.linalg.norm(rso_k1)
					w2 = np.linalg.norm(v2) * np.linalg.norm(rso_k2)
					w3 = np.linalg.norm(v3) * np.linalg.norm(rso_k3)

					mat = np.array([[*rso_k1], [*rso_k2], [*rso_k3]])
					vec = np.array([w1, w2, w3])
					sol = np.linalg.solve(mat, vec).reshape(3)

					# print(A.shape)
					# print(B.shape)
					# sol = np.linalg.solve(A, B)

					poss_vel.append(sol)

				if len(poss_vel) > 1000:
					break
			if len(poss_vel) > 1000:
				break
		if len(poss_vel) > 1000:
			break
	vel, error, results = compute_rr_error(poss_vel, pos)
	print(vel, error)

	print("POS: {},{},{} ERROR:{}".format(pos[0], pos[1], pos[2], pos_error))
	print("VEL: {},{},{} ERROR:{}".format(vel[0], vel[1], vel[2], error))

	compute_rr_error([vel], pos, True)

	for i in results[:3]:
		r = remote("crosslinks2.satellitesabove.me", 5400)
		r.recvline()
		r.sendline(b"ticket{oscar561388quebec3:GAaopaxYK9ldU3wbbDC6XAqeccNoornlfDo_jptrIyXfq-B-yjLnteC7KLBkgFZzzg}")
		data = r.recvuntil(b"What's my position").replace(b"What's my position", b"").strip()

		# pos = b"6676.958887049956,-2070.6729547915697,-11.891150202096647"
		print("SEND", pos, i[1])
		r.recvuntil(b": ")
		r.sendline("{},{},{}".format(pos[0], pos[1], pos[2]).encode())
		r.recvuntil(b": ")
		r.sendline(i[1])

		res = r.recvline() + r.recvline() + r.recvline() + r.recvline()
		print(res)
		if b"Wrong!" not in res:
			print(b"WIN")
			r.interactive()
		r.close()
