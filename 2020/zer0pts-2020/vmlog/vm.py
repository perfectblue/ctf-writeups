import sys

program = open('prog').read()


reg = 0
mem = [0 for _ in range(10)]
p = 0
pc = 0
buf = ""

print(program)

while pc < len(program):
    op = program[pc]

    if op == "+": # increment
        reg += 1
    elif op == "-": # decrement
        reg -= 1
    elif op == "*": # multiply from mem
        reg *= mem[p]
    elif op == "%": # modulus from mem
        reg = mem[p] % reg
    elif op == "l": # load from mem
        reg = mem[p]
    elif op == "s": # store to mem
        mem[p] = reg
    elif op == ">": # mem pointer increment
        p = (p + 1) % 10
    elif op == "<": # mem pointer decrement
        p = (p - 1) % 10
    elif op == ",": # read chacter
        a = sys.stdin.buffer.read(1)
        if not a:
            reg = 0
        else:
            reg += ord(a)
    elif op == "p": # output register value
        buf += str(reg)
    elif op == "[": # loop while reg != 0
        if reg == 0:
            cnt = 1
            while cnt != 0:
                pc += 1
                if program[pc] == "[":
                    cnt += 1
                if program[pc] == "]":
                    cnt -= 1
    elif op == "]": # go back to matching [ if reg != 0
        if reg != 0:
            cnt = 1
            while cnt != 0:
                pc -= 1
                if program[pc] == "[":
                    cnt -= 1
                if program[pc] == "]":
                    cnt += 1
    elif op == "M": # print mem
        print(mem)
        print('p = ' + str(p))
        print('reg = ' + str(reg))
        print('')

    pc += 1

print(buf)
