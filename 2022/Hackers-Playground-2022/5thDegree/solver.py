import requests

s = requests.Session()

s.get('http://5thdegree.sstf.site/')

res = s.get('http://5thdegree.sstf.site/chal')
txt = res.text

for stage in range(60):

    print(txt)

    idx1 = txt.find('y = ') + 4
    idx2 = txt.find('\\]', idx1) - 1
    idx3 = txt.find('\\(', idx2) + 3
    idx4 = txt.find('\\)', idx3) - 1

    eq = txt[idx1:idx2].replace('^', '**').replace('x', '*x')
    rng = txt[idx3:idx4]
    st, _, ed = rng.split(' \\le ')
    st, ed = int(st), int(ed)

    print(eq)
    print(st, ed)

    eq = compile(eq, '<int>', 'eval')

    mn, mx = None, None 
    for x in range(st, ed + 1):
        res = eval(eq)
        if mn is None:
            mn = res
        if mx is None:
            mx = res
        mn = min(mn, res)
        mx = max(mx, res)

    res = s.post('http://5thdegree.sstf.site/chal', {'min': str(mn), 'max': str(mx)})
    txt = res.text

print(txt)
