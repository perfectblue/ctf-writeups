from tqdm import tqdm
import base64
import gmpy2

def parse(data):
    lines = data.split('\n')

    fname = None
    nexts = []
    codes = dict()
    behav = []
    anc = 'Abstract'
    flag = False
    for line in lines:
        if line.startswith('    public void m'):
            fname = line[16:21]
            continue
        elif line.startswith('    public void'):
            fname = 'getCode'
            continue
        elif line.startswith('    public Abstract'):
            fname = 'getNext'
            continue
        elif line.startswith('    }'):
            fname = None
            continue

        elif line.startswith('public class') or line.startswith('class'):
            anc = line.split('extends ')[1].split(' ')[0]
        
        elif line.startswith('        code.append'):
            codes[fname] = line.split('"')[1]
        elif line.startswith('        throw'):
            codes[fname] = False
        elif line.startswith('            next = new '):
            if not impos:
                nexts.append(line[23:].split('(')[0])
        elif line.startswith('        mo'):
            behav.append(line[8:13])
        elif line.startswith('        next.mo'):
            behav.append(line[8:18])
        elif line.startswith('        next.getCode(code)'):
            pass
        
        elif line.startswith('        if'):
            line = line[12:-3]
            cond, eq = line.split('&&')
            
            a = -int(eq.split(' * ')[-1].split(')')[0].replace('L', '').replace(')', '').replace('(', ''))
            b = -int(eq.split(' == ')[1].replace('L', ''))
            
            if a**2 - 4 * b < 0:
                impos = True
                continue
            d = gmpy2.isqrt(a**2 - 4 * b)
            if d * d != a**2 - 4 * b:
                impos = True
                continue
            root1 = (-a + gmpy2.isqrt(a**2 - 4 * b)) // 2
            root2 = (-a - gmpy2.isqrt(a**2 - 4 * b)) // 2

            if '>' in cond:
                v = int(cond.split(' > ')[0].replace('L', ''))
                if v > root1 or v > root2:
                    impos = False
                else:
                    impos = True
            else:
                v = int(cond.split(' < ')[0].replace('L', ''))
                if v < root1 or v < root2:
                    impos = False
                else:
                    impos = True

        elif line.startswith('package'):
            pass
        elif line.startswith('    @Override'):
            pass
        elif line.startswith('/*'):
            pass
        elif line.startswith('    /* renamed'):
            pass
        elif line.startswith('        Abstract next = null;'):
            pass
        elif line.startswith('        System.out.println'):
            pass
        elif line.startswith('        long key = scanner'):
            pass
        elif line.startswith('        }'):
            pass
        elif line.startswith('}'):
            pass
        elif line.startswith('        return next;'):
            pass
        elif line.startswith('        return null;'):
            pass
        elif line.startswith('        getNext();'):
            pass
        elif line.startswith('    C1969') or line.startswith('    C1986') or line.startswith('    C1994'): # ???
            pass
        elif line.startswith('        Abstract next = getNext();'):
            pass
        elif line == '':
            pass

        # else:
        #     print(data)
        #     print('wrong: ' + line)
        #     exit(0)
    
    return anc, nexts, codes, behav

parsed = dict()

for i in tqdm(range(10)):
    with open(f'../sources/SCTF/C000{i}C{i}.java', 'r') as f:
        data = f.read()
        res = parse(data)
        parsed[f'C000{i}C{i}'] = res

for i in tqdm(range(10, 2001)):
    if i == 981:
        continue
    with open(f'../sources/SCTF/C{i}.java', 'r') as f:
        data = f.read()
        res = parse(data)
        parsed[f'C{i}'] = res

with open(f'../sources/SCTF/Last.java', 'r') as f:
    data = f.read()
    res = parse(data)
    parsed['Last'] = res

parsed['Abstract'] = ('Abstract', [], {'mo4f0': '', 'mo3f1': '', 'mo2f2': '', 'mo1f3': '', 'mo0f4': ''}, [])

def search_behav(cur, b):
    anc, _, codes, _ = parsed[cur]
    if b in codes:
        return codes[b]
    # optimize
    res = search_behav(anc, b)
    codes[b] = res
    return res

check_arr = dict()
for key in parsed.keys():
    check_arr[key] = False

def find_ans(cur):
    if cur == 'C908':
        print("WOW")
    global check_arr
    check_arr[cur] = True

    print(f"find_ans {cur}")
    anc, nexts, codes, behav = parsed[cur]

    for nxt in nexts:
        if check_arr[nxt]:
            continue
        failed = False
        anc_, _, codes_, _ = parsed[nxt]
        ret = ''
        for b in behav:
            if b.startswith('next'):
                res = search_behav(nxt, b[5:])
            else:
                res = search_behav(cur, b)
            if res is False:
                failed = True
                break
            ret += res
        
        if not failed:
            if cur == 'Last':
                return ret
            res = find_ans(nxt)
            if res:
                return ret + res
    
res = find_ans('C1843')

with open('flag.jpg', 'wb') as f:
    wow = base64.b64decode(res.encode())
    print(wow)
    f.write(base64.b64decode(res.encode()))