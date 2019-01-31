from pwn import *

from collections import defaultdict
from heapq import *

def dijkstra(edges, f, t):
    g = defaultdict(list)
    for l,r,c in edges:
        g[l].append((c,r))

    q, seen, mins = [(0,f,())], set(), {f: 0}
    while q:
        (cost,v1,path) = heappop(q)
        if v1 not in seen:
            seen.add(v1)
            path = (v1, path)
            if v1 == t: return (cost, path)

            for c, v2 in g.get(v1, ()):
                if v2 in seen: continue
                prev = mins.get(v2, None)
                next = cost + c
                if prev is None or next < prev:
                    mins[v2] = next
                    heappush(q, (next, v2, path))
    assert False

def node_id(src):
    return '%d,%d' % (src[0], src[1])

r = remote('110.10.147.104', 15712)
r.sendline('g')
answers = []
while True:
    stagehdr= r.recvuntil('***\n')
    print stagehdr
    mtx = r.recvuntil('\n\n')
    # mtx = """99 99 99 99 99 99 99
    # 99 99 99 99 99 99 99
    # 99 99 99 99 99 99 99
    # 99 99 99 99 99 99 99
    # 99  1  1  1 99  1  1
    #  1  1 99  1 99  1 99
    # 99 99 99  1  1  1 99
    # """
    print mtx
    mtx = map(lambda a: map(int, a), map(lambda a: filter(bool, a), map(lambda s: s.split(' '), filter(bool, mtx.split('\n')))))
    edges = []
    for y in range(len(mtx)):
        row = mtx[y]
        for x in range(len(row)):
            if row[x] < 0:
                print 'negative weight!'
                assert False
            src = (x,y)
            if x < len(row) - 1: # right
                dst = (x+1,y)
                edges.append((node_id(src), node_id(dst), mtx[dst[1]][dst[0]]))
            if y > 0: # up
                dst = (x, y-1)
                edges.append((node_id(src), node_id(dst), mtx[dst[1]][dst[0]]))
            if y < len(mtx) - 1: # down
                dst = (x, y+1)
                edges.append((node_id(src), node_id(dst), mtx[dst[1]][dst[0]]))
    for y in range(len(mtx)): # start nodes
        edges.append(('s,%d' % (y,), node_id((0, y)), mtx[y][0]))
    for y in range(len(mtx)): # end nodes
        x = len(mtx[y])-1
        edges.append((node_id((x, y)), 'e,%d' % (y,), 0))
    # print len(edges)
    # print edges
    bestweight = -1
    for y1 in range(len(mtx)):
        for y2 in range(len(mtx)):
            weight = dijkstra(edges, 's,%d' % (y1,), 'e,%d' % (y2,))[0]
            if bestweight < 0 or weight < bestweight:
                bestweight = weight
    print bestweight
    r.recvuntil('Answer within 10 seconds >>> ')
    answers.append(bestweight)
    r.sendline(str(bestweight))
    print answers
    print ' '.join(map(str,answers))
    if 'STAGE 100' in stagehdr:
        r.interactive()
        print 'WOWee!'
        break

