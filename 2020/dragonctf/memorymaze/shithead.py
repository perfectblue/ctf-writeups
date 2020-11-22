def addr2xy(addr):
	page_number = (addr>>12) - 0x13370
	y,x = page_number // 303, page_number % 303
	return x,y

def xy2addr(x,y):
	return (0x13370 + 303*y + x)<<12

assert addr2xy(xy2addr(12,34)) == (12,34)


def solve(oracle):

	# for row in maze:
	# 	print(''.join(map(str,row)))

	# dijkstra shit
	import heapq
	q = [(-1,0,'',1,1)]
	visited = set()
	iters=0
	while q:
		weight,plen,path,x,y = heapq.heappop(q)
		if (x,y) in visited:
			continue
		visited.add((x,y))
		iters+=1
		# print(x,y)
		if x < 0 or y < 0 or y >= 303 or x >= 303 or not oracle(x,y):
			# print('no')
			continue
		if x == 301 and y == 301:
			print('solved after %d iters' % iters)
			print('pathlen = %d' % len(path))
			break
		heapq.heappush(q,(-y,len(path)+1,path+'N',x,y-1))
		heapq.heappush(q,(-y,len(path)+1,path+'S',x,y+1))
		heapq.heappush(q,(-y,len(path)+1,path+'E',x+1,y))
		heapq.heappush(q,(-y,len(path)+1,path+'W',x-1,y))
	return path

# print(path)

if __name__ == "__main__":
	addrs = list(filter(lambda a: a >= 0x13370000, sorted([int(l.split('-')[0],16) for l in open('lol.txt',"r").readlines()])))
	coords = list(map(addr2xy, addrs))
	maze = [[0 for i in range(303)] for  j in range(303)]
	for x,y in coords:
		maze[y][x] = 1

	soln = solve(oracle=lambda x,y: maze[y][x])
	print(soln)

	exit()
	# xs,ys = zip(*coords)
	# print (xs,ys)
	import matplotlib.pyplot as plt

	plt.scatter(xs, ys)
	plt.show()
