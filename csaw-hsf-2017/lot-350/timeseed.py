#!/usr/bin/env python3
from fphack import *
import random,time

import struct

def check_t(possible_t, outputs):
    random.seed(possible_t)
    for i in range(0,len(outputs)):
        if outputs[i] != random.randint(0,100):
            return False
    return True


def guess_t(t_send, avg_latency, outputs):
    guessed_t = t_send + avg_latency
    epsilon = fstep(guessed_t) - guessed_t
    steps = int(1.0/epsilon) # max tries
    # print('%d steps' % (steps,))

    p_t_up = guessed_t
    p_t_down = guessed_t
    for i in range(0, steps * 2):
#        if i % 20000 == 0:
#                print('%d %f %f'%(i,p_t_up,p_t_down))

        p_t = 0
        if i % 2 == 0:
            if not check_t(p_t_up,outputs):
                p_t_up = fstep(p_t_up)
                continue
            possible_t = p_t_up
        else:
            if not check_t(p_t_down,outputs):
                p_t_down = fstep(p_t_down, -1)
                continue
            possible_t = p_t_down

        print('FOUND %f' % (possible_t))
        print('dt=%f'%(possible_t-guessed_t))
        print(i)
        return possible_t
    return None

def test_guesser():
    t_send = time.time()

    lagged_t = t_send + random.gauss(0.25,0.01) # simulate network delay
    random.seed(lagged_t)
    print('goal:%f'%(lagged_t))

    outputs=[random.randint(0,100) for i in range(0,50)]
    print(outputs)
    print(t_send)
    print(hash(t_send))

    guessed=guess_t(t_send, 0.25, outputs)
    print('guessed:%f'%(guessed,))
    print('real:   %f'%(lagged_t))
#test_guesser()

if __name__ =='__main__':
	test_guesser()
