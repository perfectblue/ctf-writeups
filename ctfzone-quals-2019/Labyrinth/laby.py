import socket
from telnetlib import Telnet
import time
from PIL import Image

def interact():
  print "INTERACTIVE"
  t = Telnet()
  t.sock = r
  t.interact()

def get_move(cur_x, cur_y, next_x, next_y):
  if next_x == cur_x + 1:
    return "right"
  if next_x == cur_x - 1:
    return "left"
  if next_y == cur_y + 1:
    return "down"
  if next_y == cur_y - 1:
    return "up"

def get_next_coord(x, y, move):
  if move == "up":
    return (x, y - 1)
  elif move == "down":
    return (x, y + 1)
  elif move == "left":
    return (x - 1, y)
  elif move == "right":
    return (x + 1, y)

def output_maze(arr, w, h):
  img = Image.new("RGB", (w, h))
  for i in range(w):
    for j in range(h):
      if (i, j) in mines:
        print "OUTPUT MINE", (i, j)
        img.putpixel((i, j), (255, 0, 0))
      elif arr[j][i] == "#":
        img.putpixel((i, j), (0, 0, 0))
      elif arr[j][i] == " ":
        img.putpixel((i, j), (255, 255, 255))
      elif arr[j][i] == "@":
        img.putpixel((i, j), (0, 0, 255))
      elif arr[j][i] == "E":
        img.putpixel((i, j), (255, 255, 0))
      else:
        print "UNKNOWN PIXEL", (i, j)
        img.putpixel((i, j), (0, 255, 0))
  img.save("maze.png")

def read_maze(maze, w, h):
  img = Image.open("maze.png")
  for i in range(w):
    for j in range(h):
      cur_pix = img.getpixel((i, j))
      if cur_pix == (0, 0, 0):
        maze[j][i] = "#"
      elif cur_pix == (255, 255, 255) or cur_pix == (0, 0, 255):
        maze[j][i] = " "
      elif cur_pix == (255, 0, 0):
        mines.append((i, j))
        maze[j][i] = "M"
      elif cur_pix == (255, 255, 0):
        maze[j][i] == "E"
  img.close()

def fill_maze(arr, global_x, global_y):
  out = open("log", "w+")
  maze = ""
  width = 0
  height = 0
  while "@" not in maze.strip().split("\n")[-1] or len(maze.strip().split("\n")[-1]) != 201:
    data = r.recv(2048)
    maze += data
    out.write(data)
    out.flush()
    height = len(maze.strip().split("\n"))
    width = len(maze.strip().split("\n")[-1])
    if "blown up on a mine" in maze:
      out.close()
      print maze
      return False
  print maze
  out.close()
  maze = maze.strip().split("\n")
  height = len(maze)
  print width, height

  local_x, local_y = 0, 0
  for i in range(width):
    for j in range(height):
      if j < len(maze) and i < len(maze[j]) and maze[j][i] == "@":
        local_x = i
        local_y = j

  for i in range(width):
    for j in range(height):
      if j >= len(maze) or i >= len(maze[j]):
        continue
      offset_x = i - local_x
      offset_y = j - local_y
      tile = maze[j][i]
      arr[global_y + offset_y][global_x + offset_x] = tile

"""
  targets = []
  for i in range(width):
    for j in range(5):
      offset_x = i - local_x
      offset_y = j - local_y
      if maze[j][i] == " ":
        targets.append((offset_x + global_x, offset_y + global_y))
  return targets"""

def bfs(maze, target_x, target_y, start_x, start_y):
  q = []
  q.append((start_x, start_y))
  visited = {}
  visited[(start_x, start_y)] = (True, True)
  while len(q) > 0:
    cur_x, cur_y = q.pop(0)
    if cur_x == target_x and cur_y == target_y:
      print "FOUND"
      temp_x = cur_x
      temp_y = cur_y
      positions = []
      positions.append((temp_x, temp_y))
      while temp_x != True and (temp_x, temp_y) in visited:
        temp_x, temp_y = visited[(temp_x, temp_y)]
        positions.append((temp_x, temp_y))
      return positions[:-1][::-1]
    coords = [(cur_x - 1, cur_y), (cur_x + 1, cur_y), (cur_x, cur_y - 1), (cur_x, cur_y + 1)]
    for next_x, next_y in coords:
      if (maze[next_y][next_x] == "E" or maze[next_y][next_x] == " ") and (next_x, next_y) not in visited:
        q.append((next_x, next_y))
        visited[(next_x, next_y)] = (cur_x, cur_y)

def find_target(maze, x, y, w, h):
  targets = []
  for j in range(h):
    for i in range(w):
      if maze[j][i] == "E":
        print "FOUND END"
        print (i, j)
        return [(i, j)]
      elif maze[j][i] == " ":
        targets.append((i, j))
        if len(targets) > 200:
          return targets

mines = []
total_width = 1200
total_height = 1200
maze = [["#" for i in range(total_width)] for j in range(total_height)] 

while True:
  r = socket.socket()
  r.connect(("ppc-labyrinth.ctfz.one", 4340))
  x, y = 600, 1100
  read_maze(maze, total_width, total_height)
  maze[y][x] = "@"
  for i in range(1):
    fill_maze(maze, x, y)
    output_maze(maze, total_width, total_height)
    targets = find_target(maze, x, y, total_width, total_height)

    target_x, target_y = -1, -1

    for temp_x, temp_y in targets:
      positions = bfs(maze, temp_x, temp_y, x, y)
      if positions != None:
        target_x = temp_x
        target_y = temp_y
        break
    print "TARGET", target_x, target_y
    moves = ""
    cur_x, cur_y = positions[0]
    for i in range(1, len(positions)):
      next_x, next_y = positions[i]
      moves += get_move(cur_x, cur_y, next_x, next_y) + ","
      cur_x, cur_y = next_x, next_y
    moves = moves[:-1].split(",")
    print moves


    PRESEND = 758

    r.send(",".join(moves[:PRESEND]))
    for i in range(min(PRESEND, len(moves))):
      x, y = get_next_coord(x, y, moves[i])
    moves = moves[PRESEND:]
    fill_maze(maze, x, y)

    c = 0

    for i in moves:
      c += 1
      r.send(i + "\n")
      maze[y][x] = " "
      next_x, next_y = get_next_coord(x, y, i)
      x, y = next_x, next_y
      res = fill_maze(maze, x, y)
      if res == False:
        print "FOUND MINE", next_x, next_y
        mines.append((next_x, next_y))
        maze[next_y][next_x] = "M"
        #output_maze(maze, total_width, total_height)
        break
      maze[y][x] = " "

    #r.send("".join(moves) + "\n")
    #maze[y][x] = " "
    #x, y = target_x, target_y

    output_maze(maze, total_width, total_height)

  interact()
