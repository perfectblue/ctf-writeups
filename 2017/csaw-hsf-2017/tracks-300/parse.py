import json

datas = open('loghdu.txt').readlines()
datas = map(json.loads, datas)
datas.sort(key=lambda snapshot:snapshot['now'])

prev_lon = 0
start_lon = 0
asdf = ''
for snapshot in datas:
    now = snapshot['now']
    snapshot = snapshot['aircraft']
    for ac in snapshot:
        if ac['hex'] == 'l0l3b3':
            lon = float(ac['lon'])
            lat = float(ac['lat'])
            print '{%f, %f},' % (lat, lon),

print asdf