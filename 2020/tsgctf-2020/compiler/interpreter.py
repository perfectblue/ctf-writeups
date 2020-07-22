import argparse
import sys
import re
import traceback


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def eexit(*args, **kwargs):
    eprint("Error:", *args, **kwargs)
    traceback.print_stack()
    exit(-1)


DEBUG = False


def pp_value(v):
    if isinstance(v, int):
        return str(v)
    elif all(map(lambda x: isinstance(x, int) and 32 <= x and x <= 126, v)):
        return '`' + ''.join(map(chr, v)) + '`'
    else:
        assert(isinstance(v, list))
        return "[" + ','.join(map(pp_value, v)) + "]"


def tokenize(s):
    res = []
    while s != b'':
        m = re.match(
            b'([A-Za-z_0-9]+|/\*|\+|-|\*|"|/|%|\(|,|\)|\{|\}|;|\[|\]|==|!=|!|=|<=|>=|>|<|\|\||&&|\s+)', s)
        if m is None:
            eexit("tokenize error:", s[:10])
        t = m.group(1)
        if t == b'/*':
            s = s[2:]
            s = s[s.find(b'*/')+2:]
        elif t == b'"':
            s = s[1:]
            v = s[:s.find(b'"')]
            s = s[s.find(b'"')+1:]
            res.append(b'"' + v + b'"')
        else:
            res.append(t)
            s = s[m.end():]

    res = list(filter(lambda x: re.match(b'^\s+$', x) is None, res))
    return res


def expect(s, i, t):
    if s[i] == t:
        return
    eexit('expect:', t, 'got:', s[i], 'at:', i, 'with s:', s[:10])

# parser

def get_args(s, fr=b'(', to=b')'):
    expect(s, 0, fr)
    s = s[1:]
    if s[0] == to:
        return s[1:], []
    s, v = parse_expr(s)
    res = [v]
    while True:
        if s[0] == to:
            return s[1:], res
        else:
            expect(s, 0, b',')
            s, v = parse_expr(s[1:])
            res += [v]


def get_priority(op, s):
    prs = [
        [b"||", b"&&", b"!"],
        [b"==", b"!=", b">", b"<", b"<=", b">="],
        [b"+", b"-"],
        [b"*", b"/", b"%"],
    ]
    for i, v in enumerate(prs):
        if op in v:
            return i
    eexit("unknown priority operator:", op, "at:", s[:10])


def parse_expr(s, p=-1):
    if s[0] == b'(':
        s, v = parse_expr(s[1:])
        expect(s, 0, b')')
        s = s[1:]
    elif s[0] == b'[':
        s, vs = get_args(s, b'[', b']')
        v = ('[]', vs)
    elif s[0] == b'-':
        s, v = parse_expr(s[1:], get_priority(b'-', s))
        v = (b'-', [('Int', b'0'), v])
    elif s[0] == b'!':
        s, v = parse_expr(s[1:], get_priority(b'!', s))
        v = (b'==', [('Int', b'0'), v])
    else:
        if s[0].isdigit():
            v = ('Int', s[0])
        elif s[0][:1] == b'"':
            v = ('[]', list(map(lambda x: ('Int', b'%d' % int(x)), s[0][1:-1])))
        else:
            v = ('Var', s[0])
        s = s[1:]

    while True:
        op = s[0]
        if op == b')' or op == b';' or op == b',' or op == b']':
            return s, v
        elif op == b'(':
            assert (v[0] == 'Var')
            s, vs = get_args(s)
            v = ('Call', [v[1]] + vs)
        elif op == b'[':
            s, e = parse_expr(s[1:])
            expect(s, 0, b']')
            s = s[1:]
            v = ('Get', [v, e])
        else:
            q = get_priority(op, s)
            if p >= q:
                return s, v
            else:
                s, w = parse_expr(s[1:], q)
                v = (op, [v, w])


def parse_stmt(s):
    if s[0] == b'while':
        expect(s, 1, b'(')
        s, cond = parse_expr(s[2:])
        expect(s, 0, b')')
        s, body = parse_stmts_or_stmt(s[1:])
        return s, ('While', {'cond': cond, 'body': body})
    elif s[0] == b'if':
        expect(s, 1, b'(')
        s, cond = parse_expr(s[2:])
        expect(s, 0, b')')
        s, true = parse_stmts_or_stmt(s[1:])
        if s[0] == b'else':
            s, false = parse_stmts_or_stmt(s[1:])
        else:
            false = []
        return s, ('If', {'cond': cond, 'true': true, 'false': false})
    elif s[0] == b'return':
        s, e = parse_expr(s[1:])
        expect(s, 0, b';')
        return s[1:], ('Return', {'retv': e})
    elif s[1] == b'=':
        v = s[0]
        s, e = parse_expr(s[2:])
        expect(s, 0, b';')
        return s[1:], ('Assign', {'dest': v, 'expr': e})
    else:
        s, e = parse_expr(s)
        expect(s, 0, b';')
        return s[1:], ('Eval', {'expr': e})


def parse_stmts(s):
    expect(s, 0, b'{')
    s = s[1:]
    res = []
    while True:
        if s[0] == b'}':
            return s[1:], res
        s, st = parse_stmt(s)
        res += [st]


def parse_stmts_or_stmt(s):
    if s[0] == b'{':
        s, res = parse_stmts(s)
    else:
        s, r = parse_stmt(s)
        res = [r]
    return s, res


def parse_func(s):
    fn = s[0]
    expect(s, 1, b'(')
    s, vs = get_args(s[1:])
    if not all(map(lambda x: x[0] == 'Var', vs)):
        eexit("invalid parameter for function %s with arguments %s" %
              (fn, str(vs)))
    vs = list(map(lambda x: x[1], vs))
    s, body = parse_stmts(s)
    return s, (fn, vs, body)


def parse(s):
    res = []
    while s != []:
        if s[1] == b'(':
            s, (fn, vs, bo) = parse_func(s)
            res.append(('Fundecl', {'fn': fn, 'body': bo, 'args': vs}))
        else:
            vn = s[0]
            expect(s, 1, b';')
            res.append(('Valdecl', {'vn': vn}))
            s = s[2:]
    return res

# evaluator


def eval_expr(s, env, gvars):
    global prog, global_env
    op, vs = s
    if op in [b'+', b'-', b'<', b'>', b'!=', b'==', b'<=', b'>=', b'%', b'/', b'*', b'||', b'&&', 'Get']:
        v = eval_expr(vs[0], env, gvars)
        w = eval_expr(vs[1], env, gvars)
        if op == b'+':
            return v + w
        elif op == b'-':
            return v - w
        elif op == b'*':
            return v * w
        elif op == b'/':
            return v // w
        elif op == b'%':
            return v % w
        elif op == b'<':
            return 1 if v < w else 0
        elif op == b'>':
            return 1 if v > w else 0
        elif op == b'==':
            return 1 if v == w else 0
        elif op == b'!=':
            return 1 if v != w else 0
        elif op == b'<=':
            return 1 if v <= w else 0
        elif op == b'>=':
            return 1 if v >= w else 0
        elif op == b'||':
            return 1 if v != 0 or w != 0 else 0
        elif op == b'&&':
            return 1 if v != 0 and w != 0 else 0
        elif op == 'Get':
            return v[w]
    elif op == '[]':
        return list(map(lambda x: eval_expr(x, env, gvars), vs))
    elif op == 'Int':
        return int(vs, 10)
    elif op == 'Var':
        if vs in env.keys():
            return env[vs]
        elif vs in gvars:
            return global_env[vs]
        else:
            eexit("undefined variable:", vs, list(env.keys()))
    elif op == 'Call':
        tvs = list(map(lambda x: eval_expr(x, env, gvars), vs[1:]))
        return eval_func(vs[0], tvs)

    eexit("unknown evaluation operator:", op)


class ExRet(Exception):
    def __init__(self, v):
        self.v = v


def eval_stmts(ss, env, gvars):
    global prog, global_env
    for st, vs in ss:
        if st == 'Assign':
            v = eval_expr(vs['expr'], env, gvars)
            if vs['dest'] in env.keys() or (not vs['dest'] in gvars):
                env[vs['dest']] = v
            else:
                global_env[vs['dest']] = v
        elif st == 'Eval':
            eval_expr(vs['expr'], env, gvars)
        elif st == 'If':
            if eval_expr(vs['cond'], env, gvars):
                eval_stmts(vs['true'], env, gvars)
            else:
                eval_stmts(vs['false'], env, gvars)
        elif st == 'While':
            while eval_expr(vs['cond'], env, gvars):
                eval_stmts(vs['body'], env, gvars)
        elif st == 'Return':
            retv = vs['retv']
            retv = 0 if retv is None else eval_expr(retv, env, gvars)
            if DEBUG:
                eprint('return', pp_value(retv))
            raise ExRet(retv)
        else:
            eexit("unknown evaluation statement:", st)


def eval_func(fn, args):
    global prog, read, write
    if fn == b'write':
        write(args[0])
        return 0
    elif fn == b'read':
        return read()
    elif fn == b'len':
        return len(args[0])
    elif fn == b'debug':
        if DEBUG:
            eprint('debug', pp_value(args))
        return 0
    else:
        bo = prog[fn]['body']
        if len(prog[fn]['args']) != len(args):
            eexit('%s: expect %d arguments, got %d' %
                  (fn, len(prog[fn]['args']), len(args)))
        env = {n: v for n, v in zip(prog[fn]['args'], args)}
        gvars = prog[fn]['gvars']
        if DEBUG:
            eprint('Call', fn, {n: pp_value(v) for n, v in env.items()})
        try:
            eval_stmts(bo, env, gvars)
            return 0
        except ExRet as e:
            return e.v


def interpret(code, readf, writef):
    global prog, global_env, read, write
    decls = parse(tokenize(code))
    if DEBUG:
        eprint(decls)

    prog = {}
    global_env = {}
    for k, v in decls:
        if k == 'Fundecl':
            prog[v['fn']] = {'body': v['body'],
                             'args': v['args'], 'gvars': list(global_env.keys())}
        else:
            assert(k == 'Valdecl')
            global_env[v['vn']] = 0

    read = readf
    write = writef
    eval_func(b'main', [])


if __name__ == '__main__':
    code = open(sys.argv[1], 'rb').read()

    def read():
        c = sys.stdin.buffer.read(1)
        return c[0] if len(c) >= 1 else 255

    def write(s):
        sys.stdout.buffer.write(bytes(s))
        sys.stdout.buffer.flush()

    interpret(code, read, write)
