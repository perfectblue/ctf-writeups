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


def parse(s):
    return list(map(lambda x: x.split(b' '), s.split(b'\n')))[:-1]


def simulate(code, read, write):
    prog = parse(code)
    ip = 0
    bp = 0
    sp = 0
    mem = [None for _ in range(10000000)]

    def get(p):
        nonlocal sp, bp
        if p == b"bp":
            return bp
        elif p == b"sp":
            return sp
        elif p[:2] == b"bp":
            return mem[bp + int(p[3:-1])]
        elif p[:1] == b"#":
            return mem[int(p[1:])]
        else:
            return int(p)

    def set_(p, v):
        nonlocal sp, bp
        if p == b"bp":
            bp = v
        elif p == b"sp":
            sp = v
        elif p[:2] == b"bp":
            tp = bp + int(p[3:-1])
            mem[tp] = v
        elif p[:1] == b"#":
            tp = int(p[1:])
            mem[tp] = v
        else:
            eexit("assign for integer is prohibit", p)

    def push(v):
        nonlocal sp
        sp = sp + 1
        mem[sp] = v

    def pop():
        nonlocal sp
        sp = sp - 1
        return mem[sp + 1]

    just_read = False
    bpstk = []
    stepcnt = 0
    while True:
        stepcnt += 1
        if stepcnt > 100000000:
            print('Too many steps. Maybe stucks in an infinite loop?')
            exit(-1)
        inst = prog[ip]
        if DEBUG:
            eprint(inst)
            eprint(ip, sp, bp)
        ip = ip + 1
        op = inst[0]
        if op == b"mov":
            set_(inst[1], get(inst[2]))
        elif op == b"makelist":
            vs = inst[2]
            if not (vs[:1] == b'[' and vs[-1:] == b']'):
                eexit("invalid list representation", vs)
            set_(inst[1], [] if vs == b'[]' else list(
                map(get, vs[1:-1].split(b','))))
        elif op == b"add":
            t = get(inst[2]) + get(inst[3])
            if isinstance(t, list) and len(t) > 20:
                #eprint('list of', len(t))
                pass
            set_(inst[1], t)
        elif op == b"sub":
            set_(inst[1], get(inst[2]) - get(inst[3]))
        elif op == b"mul":
            set_(inst[1], get(inst[2]) * get(inst[3]))
        elif op == b"div":
            set_(inst[1], get(inst[2]) // get(inst[3]))
        elif op == b"lt":
            set_(inst[1], 1 if get(inst[2]) < get(inst[3]) else 0)
        elif op == b"eq":
            set_(inst[1], 1 if get(inst[2]) == get(inst[3]) else 0)
        elif op == b"call":
            if DEBUG:
                bpstk.append(bp)
            push(ip)
            ip = int(inst[1])
        elif op == b"ret":
            if DEBUG:
                assert(bpstk[-1] == bp)
                bpstk.pop()
            ip = pop()
            if just_read:
                just_read = False
        elif op == b"jz":
            if get(inst[1]) == 0:
                ip = int(inst[2])
        elif op == b"push":
            push(get(inst[1]))
        elif op == b"pop":
            set_(inst[1], pop())
        elif op == b"read":
            just_read = True
            pop()
            push(read())
        elif op == b"write":
            write(mem[sp - 1])
        elif op == b"len":
            pop()
            push(len(mem[sp]))
        elif op == b"get":
            set_(inst[1], get(inst[2])[get(inst[3])])
        elif op == b"hlt":
            break
        else:
            eexit("undefined instruction ", inst)


if __name__ == '__main__':
    code = open(sys.argv[1], 'rb').read()

    def read():
        c = sys.stdin.buffer.read(1)
        print('.', end='', flush=True, file=sys.stderr)
        return c[0] if len(c) >= 1 else 255

    def write(s):
        sys.stdout.buffer.write(bytes(s))
        sys.stdout.buffer.flush()

    simulate(code, read, write)
