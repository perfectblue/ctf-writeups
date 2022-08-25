from pwn import *
from tqdm import tqdm
r = remote('flippuzzle.sstf.site', 8098)

def backtrack(board, x, y, cnt=0):
    if (board[0] == ['A', 'B', 'C', 'D'] and
        board[1] == ['E', 'F', 'G', 'H'] and
        board[2] == ['I', 'J', 'K', 'L'] and
        board[3] == ['M', 'N', 'O', 'P']):
        return []
    if cnt == 11:
        return None
    for dx, dy in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
        tx = (x + dx) % 4
        ty = (y + dy) % 4
        board[x][y], board[tx][ty] = board[tx][ty], board[x][y]
        ret = backtrack(board, tx, ty, cnt + 1)
        if ret is not None:
            return [(dx, dy)] + ret
        board[x][y], board[tx][ty] = board[tx][ty], board[x][y]
    
    return None

for _ in tqdm(range(100)):
    board = []
    r.recvuntil(b'Status :\n')
    for i in range(4):
        board.append(list(r.recvline().strip().decode()))

    for i in range(4):
        for j in range(4):
            if board[i][j] == 'A':
                x, y = i, j
                break
    
    res = backtrack(board, x, y)
    for dx, dy in res:
        r.sendlineafter(b'>>>', f'{dx},{dy}'.encode())
    
    r.recvuntil(b'Solved!')

r.interactive()
