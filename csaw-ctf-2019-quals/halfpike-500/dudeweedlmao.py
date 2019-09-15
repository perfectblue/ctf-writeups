# run me with pypy3

class VM:
    def __init__(self):
        # NIBBLES
        self.vm_data = [0]*0x40 # 00-20
        self.guest_mem = [0]*0x10 # a0-b0
        self.ck1 = 0 # 9d
        self.ck2 = 0 # 9e
        self.ip = 0 # 9f

    def load(self, vm_data, guest_mem):
        for i,byte in enumerate(vm_data):
            self.vm_data[2*i] = byte >> 4
            self.vm_data[2*i+1] = byte & 0xf
        for i,byte in enumerate(guest_mem):
            self.guest_mem[2*i] = byte >> 4
            self.guest_mem[2*i+1] = byte & 0xf

    def disasm(self, i):
        opcode = self.vm_data[4*i]
        arg1, arg2, arg3 = self.vm_data[4*i+1:4*i+4]
        
        if opcode == 0: # cmp
            result = 'cmp [%x], [%x], %x' % (arg1, arg2, arg3)
        elif opcode == 1: # rol
            result = 'rol [%x], %x' % (arg1, arg2)
        elif opcode == 2: # recv
            result = 'recv guest:[%x], vm:[%x]' % (arg1, arg2)
        elif opcode == 3: # xor
            result = 'xor [%x], %x' % (arg1, arg2)
        elif opcode == 4: # send
            result = 'send vm:[%x], guest:[%x]' % (arg1, arg2)
        elif opcode == 5: # loop
            result = 'loop'
        elif opcode == 6: # skip
            result = 'skipne [%x], [%x]' % (arg1, arg2)
        elif opcode == 7:
            result = 'add [%x], %x' % (arg1, arg2)
        return result

    def step(self):
        insn_names = ['cmp', 'rol', 'recv', 'xor', 'send', 'loop', 'skip', 'add']

        opcode = self.vm_data[4*self.ip]
        arg1, arg2, arg3 = self.vm_data[4*self.ip+1:4*self.ip+4]
        self.ip += 1

        # print(self.disasm(self.ip))

        if opcode == 0: # cmp
            if self.guest_mem[arg1] != self.guest_mem[arg2]:
                if arg3 and self.ck2 == 0:
                    self.ck1 = arg3
                self.ck2 = 1
        elif opcode == 1: # rol
            x = self.guest_mem[arg1]
            for _ in range(arg2):
                x = ((x>>3) | (x<<1)) & 0xf
            self.guest_mem[arg1] = x
        elif opcode == 2: # recv
            self.guest_mem[arg1] = self.vm_data[arg2]
        elif opcode == 3: # xor
            self.guest_mem[arg1] ^= arg2
        elif opcode == 4: # send
            self.vm_data[arg1] = self.guest_mem[arg2]
        elif opcode == 5: # loop
            self.ip = 0
        elif opcode == 6: # skip
            if self.guest_mem[arg1] != self.guest_mem[arg2]:
                self.ip += 1
        elif opcode == 7:
            self.guest_mem[arg1] += arg2
            self.guest_mem[arg1] &= 0xF

    def dump(self):
        data = ''
        for i in range(len(self.vm_data)):
            data += '0123456789abcdef'[self.vm_data[i]]
        guest = ''
        for i in range(len(self.guest_mem)):
            guest += '0123456789abcdef'[self.guest_mem[i]]

        control = ''.join(map(lambda x: '0123456789abcdef'[x], [self.ck1, self.ck2, self.ip]))
        return (data, guest, control)

vm_code_bin = open('vm_code.bin', 'rb').read()
guest_mem_bin = open('guest_mem.bin', 'rb').read()

def get_vm(n, user_data):
    assert len(user_data) == 3

    vm_data = vm_code_bin[32*n:32*n+32]
    guest_mem = list(user_data) + list(guest_mem_bin[3*n:3*n+3]) + [0, 0]
    vm = VM()
    vm.load(vm_data, guest_mem)

    return vm

import itertools

flag = b''
for n in range(0,8):
    vm = get_vm(n, b'xxx')
    print('VM %d:' % (n,))
    for i in range(0x10):
        print(vm.disasm(i))

    for user_data in map(bytes, itertools.product(range(0x20,0x7f), repeat=3)):
        vm = get_vm(n, user_data)
        steps = 0
        while not vm.ck2:
            vm.step()
            steps += 1
            if steps > 10000:
                print('%s -> Hung' % (user_data.decode('ascii')))
                vm.ck1 = 1
                break
        if vm.ck1:
            # print('%s -> reject' % (user_data.decode('ascii')))
            continue
        else:
            flag += user_data
            print('%s -> ACCEPT' % (user_data.decode('ascii')))
            break
    else:
        print('FAILED')
        break
    print()
else:
    print('SUCCESS')
    print(flag)
