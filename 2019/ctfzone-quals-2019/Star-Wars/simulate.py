turns = """00000000000002030205020504070705000108020807000e0104
01020201010304030004070f040b0600000208060a0705080101
020101010003050202010305000303040f0d0004080a0d010402
02000002000305010504020408000f0904080301070900060a00
0101000001030501010205020808060407050902030208040401
0201020001050402010001010805070207050804000f08030b01
02010200010305050503070501050804050f01090a000a000b01
0102000201050202030403020801030507080102020004010f01
000101010100000502000006020303050204070f020201060801
000200000104000300020108030602070f0406020f0605000401
020001020205000400030002010402030f000005090901040801
02020001000003040f09000d040304000502070a090a010b0501
01000200010105050302030006000702040801050f0403090301
0201010101040504030207080604040003060702060209030701
0200000101050103030208050103070107020908000204010301
0002020002000502030300070005040006060003060308090001
00000102000401000f040b040c080304060a0c0d010b04090c01""".split("\n")
turns = [i.decode("hex") for i in turns]
print turns

passive_shield = """20
60
30
80
100
200
600
400
800
1000
1600
2000
3000
6000
20000
10000"""

passive_attack = """10
10
20
20
20
25
25
50
20
100
125
100
150
100
255
1"""

ship_shield = """50
30
10
100
20
50
70
120
800
350
10
40
35
70
60
88
99"""

ship_attack = """10
20
60
6
30
15
10
5
1
2
100
15
20
15
20
8
9"""

passive_shield = [int(i) for i in passive_shield.split("\n")]
passive_attack = [int(i) for i in passive_attack.split("\n")]
ship_shield = [int(i) for i in ship_shield.split("\n")]
ship_attack = [int(i) for i in ship_attack.split("\n")]

print passive_shield[0xe]

def simulate(ship1, ship2):
    shield1 = ship1[0]
    attack1 = ship1[1]
    shield2 = ship2[0]
    attack2 = ship2[1]

    while True:
        shield2 -= attack1
        if shield2 < 0:
            return (max(ship1[0], ship2[0]), (ship1[1] + ship2[1]) & 0xff)
        shield1 -= attack2
        if shield1 < 0:
            return ship1

total_stats = []

passive_stats = []
current_stats = []
for i in range(len(ship_shield)):
    current_stats.append((ship_shield[i], ship_attack[i]))
for i in range(len(passive_shield)):
    passive_stats.append((passive_shield[i], passive_attack[i]))

total_stats.append(current_stats)

for i in range(26):
    temp_stats = current_stats[:]
    for j in range(len(temp_stats)):
        idx = ord(turns[j][i])
        temp_stats[j] = simulate(temp_stats[j], passive_stats[idx])
    total_stats.append(temp_stats)
    current_stats = temp_stats

print total_stats

dic = {}

state = (50, 10, 0, 0, 0, 0)
# shield, attack, turn, kills, move, bitmask

stack = []
stack.append(state)

dp = {}

while len(stack) > 0:
    cur_state = stack.pop(len(stack) - 1)

    if cur_state[3] == 16 or cur_state[2] == 24:
        print cur_state
        if cur_state[3] == 16:
            print "WIN"
            while cur_state in dp:
                print dp[cur_state]
                cur_state = dp[cur_state]
            exit()
        continue

    idx = ord(turns[0][cur_state[2]])

    # we attack
    for i in range(1, 17):
        if cur_state[5] & (1 << i) != 0:
            continue
        new_stats = simulate((cur_state[0], cur_state[1]), total_stats[cur_state[2]][i])
        if new_stats == (cur_state[0], cur_state[1]):
            # print "WE DIED"
            pass
        else:
            new_stats = simulate(new_stats, passive_stats[idx])
            sice = (new_stats[0], new_stats[1] & 0xff, cur_state[2] + 1, cur_state[3] + 1, i, cur_state[5] | (1 << i))
            if sice not in dp:
                dp[sice] = cur_state
                stack.append(sice)

    res = simulate(cur_state, passive_stats[idx])
    sice = (res[0], res[1] & 0xff, cur_state[2] + 1, cur_state[3], 0, cur_state[5])
    if sice not in dp:
        dp[sice] = cur_state
        stack.append(sice)

