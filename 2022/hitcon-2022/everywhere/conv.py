keys, datas = [], []
with open('output.txt', 'r') as f:
    for _ in range(400):
        key = f.readline()[5:].strip()
        data = f.readline()[5:].strip()
        keys.append(key)
        datas.append(data)

with open('output.sage', 'w') as f:
    f.write('Zx.<x> = ZZ[]\n')
    f.write('keys = [\n')
    for key in keys:
        f.write('    ' + key + ',\n')
    f.write(']\ndata = [\n')
    for data in datas:
        f.write('    ' + data + ',\n')
    f.write(']\n')