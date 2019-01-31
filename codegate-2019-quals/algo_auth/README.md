# algo_auth

7.0 Points

**Problem description**:
```
I like an algorithm

nc 110.10.147.104 15712
nc 110.10.147.109 15712
```

This problem is very simple, the daemon explain everything:

```
==> Hi, I like an algorithm. So, i make a new authentication system.
==> It has a total of 100 stages.
==> Each stage gives a 7 by 7 matrix below sample.
==> Find the smallest path sum in matrix,
    by starting in any cell in the left column and finishing in any cell in the right column,

    and only moving up, down, and right.
==> The answer for the sample matrix is 12.
==> If you clear the entire stage, you will be able to authenticate.

[sample]
99 99 99 99 99 99 99
99 99 99 99 99 99 99
99 99 99 99 99 99 99
99 99 99 99 99 99 99
99  1  1  1 99  1  1
 1  1 99  1 99  1 99
99 99 99  1  1  1 99

If you want to start, type the G key within 10 seconds....>>
```

Since the grid is very small (7x7), we can just use Dijkstra's algorithm to solve it. The approach will be to consider all paths from any tile on the left edge to any tile on the right edge. We could even solve this by hand because every time, the question is the same.

```python
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


```

```
[82, 107, 120, 66, 82, 121, 65, 54, 73, 71, 99, 119, 77, 71, 57, 118, 84, 48, 57, 107, 88, 50, 111, 119, 81, 105, 69, 104, 73, 86, 57, 102, 88, 51, 86, 117, 89, 50, 57, 116, 90, 109, 57, 121, 100, 68, 82, 105, 98, 71, 86, 102, 88, 51, 77, 122, 89, 51, 86, 121, 97, 88, 82, 53, 88, 49, 57, 112, 99, 49, 57, 102, 98, 106, 66, 48, 88, 49, 56, 48, 88, 49, 57, 122, 90, 87, 78, 49, 99, 109, 108, 48, 101, 83, 69, 104, 73, 83, 69, 104]
82 107 120 66 82 121 65 54 73 71 99 119 77 71 57 118 84 48 57 107 88 50 111 119 81 105 69 104 73 86 57 102 88 51 86 117 89 50 57 116 90 109 57 121 100 68 82 105 98 71 86 102 88 51 77 122 89 51 86 121 97 88 82 53 88 49 57 112 99 49 57 102 98 106 66 48 88 49 56 48 88 49 57 122 90 87 78 49 99 109 108 48 101 83 69 104 73 83 69 104
[*] Switching to interactive mode
@@@@@ Congratz! Your answers are an answer
[*] Got EOF while reading in interactive
```
This looks like ascii.
```
Python 2.7.15
Type "help", "copyright", "credits" or "license" for more information.
>>> a=[82, 107, 120, 66, 82, 121, 65, 54, 73, 71, 99, 119, 77, 71, 57, 118, 84, 48, 57, 107, 88, 50, 111, 119, 81, 105, 69, 104, 73, 86, 57, 102, 88, 51, 86, 117, 89, 50, 57, 116, 90, 109, 57, 121, 100, 68, 82, 105, 98, 71, 86, 102, 88, 51, 77, 122, 89, 51, 86, 121, 97, 88, 82, 53, 88, 49, 57, 112, 99, 49, 57, 102, 98, 106, 66, 48, 88, 49, 56, 48, 88, 49, 57, 122, 90, 87, 78, 49, 99, 109, 108, 48, 101, 83, 69, 104, 73, 83, 69, 104]
>>> x=''.join(map(chr,a))
>>> print x
'RkxBRyA6IGcwMG9vT09kX2owQiEhIV9fX3VuY29tZm9ydDRibGVfX3MzY3VyaXR5X19pc19fbjB0X180X19zZWN1cml0eSEhISEh'
>>> import base64
>>> base64.b64decode(x)
'FLAG : g00ooOOd_j0B!!!___uncomfort4ble__s3curity__is__n0t__4__security!!!!!'
```
