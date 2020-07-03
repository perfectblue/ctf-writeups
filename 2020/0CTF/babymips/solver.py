def initiate(trans):
    for i in range(0, 81, 9):
        box.append([trans[j] for j in range(i, i+9)])
    for i in range(0, 81, 9):
        row.append(list(range(i, i+9)))
    for i in range(9):
        column.append(list(range(i, 80+i, 9)))
 
def valid(n, pos):
    current_row = pos//9
    current_col = pos%9
    current_box = -1
    for current_box in range(9):
        if pos in box[current_box]:
            break
    for i in row[current_row]:
        if (grid[i] == n):
            return False
    for i in column[current_col]:
        if (grid[i] == n):
            return False
    for i in box[current_box]:
        if (grid[i] == n):
            return False
    return True
 
def solve():
    i = 0
    proceed = 1
    while(i < 81):
        if given[i]:
            if proceed:
                    i += 1
            else:
                i -= 1
        else:
            n = grid[i]
            prev = grid[i]
            while(n < 9):
              if (n < 9):
                  n += 1
              if valid(n, i):
                  grid[i] = n
                  proceed = 1
                  break
            if (grid[i] == prev):
               grid[i] = 0
               proceed = 0
            if proceed:
               i += 1
            else:
               i -=1
 
 
grid = [0]*81
given = [False]*81
trans = None
box = []
row = []
column = []

#if __name__ == '__main__':
#    initiate()
#    solve()
#    for i in range(9):
#        print grid[i*9:i*9+9]
#    raw_input()
