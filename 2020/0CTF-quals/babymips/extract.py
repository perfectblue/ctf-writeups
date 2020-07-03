import solver

bin = open('babymips', 'rb').read()

loc_grid = 0x10000
loc_trans = 0x10054

grid = bin[loc_grid:loc_grid+81]
trans = list(bin[loc_trans:loc_trans+81])
solver.initiate(trans)

lets = 'qweasdzxc'
numtrans = {}
for i, let in enumerate(lets):
    numtrans[ord(let)] = i + 1

flaginds = []
for i, cell in enumerate(grid):
    if grid[i] != 0:
        solver.given[i] = True
        solver.grid[i] = numtrans[grid[i]]
    else:
        flaginds.append(i)

solver.solve()
flag = 'flag{'
for ind in flaginds:
    flag += lets[solver.grid[ind] - 1]
flag += '}'
print(flag)

for i in range(9):
    print(solver.grid[i*9:i*9+9])

#prob = [['_'] * 9 for i in range(9)]
#for r in range(9):
#    for c in range(9):
#        rc = r * 9 + c
#        if grid[rc] != 0: prob[r][c] = str(numtrans[grid[rc]])
#

