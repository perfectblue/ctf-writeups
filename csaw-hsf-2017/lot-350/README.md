this one seems very daunting but it is pretty simple.

inspecting the server source we can see 3 main places the random module is used:
 - seeding upon conection with time.time() (!!!)
 - randomclick update every second
 - generating a new lottery number
we also know that *each user has his own random instance* so no other users can interfere with our operation.

so our strategy will be do have randomclick leak us enough data to guess the internal state of the RNG, along with
the server time to guess the next lottery number.

it seems infeasible to do an attack based on deducing the entire state of the mersenne twister based solely on
past output (randomclick). this is because too many bits of output are skipped due to randint,
so it is unreasonable to try to guess all of them, and the mathematics are fairly complicated.
so instead we opt for a hybrid attack on the seed value by using the server time as
a starting point and the randomclick outputs to verify whether a seed guess is correct.

we know it is python3, default mersenne twister, and probably a linux vm.
this means we can make a lot assumptions about floating point and time scale.
it is important to use python3 because there are subtle differences in the random implementation between 2 and 3.

we spin up a box that we believe would be similar to the productio box.
then we use a small script to determine the precision of time.time(),
which is used to seed the rng.  

<clockres.py>
```python
#!/usr/bin/env python3

import time

# measure the smallest time delta by spinning until the time changes
def measure():
    t0 = time.time()
    t1 = t0
    while t1 == t0:
        t1 = time.time()
    return (t1-t0)

samples = [measure() for i in range(100)]

print(min(samples))
```

at the scale of 1e-7 it is definitely feasible to use the connection time to bruteforce the rng seed.
furthermore because of floating point inaccuracy there are probably not that many values to check.

so nxt we would like to be able to enumerate all the possible time values in a row.
floating point is far from 'smooth'; in python they are 64-bits. so we can use some dirty
pointer-hacking and coerce it to long and back, a-la John Carmack. then we should be able to step
floating point epsilons.

<fphack.py>
```python
import math
import struct

def f2i(x):
    return struct.unpack('<q', struct.pack('<d', x))[0]

def i2f(n):
    return struct.unpack('<d', struct.pack('<q', n))[0]

def fstep(x,step=1):
    # NaNs and positive infinity map to themselves.
    if math.isnan(x) or (math.isinf(x) and x > 0):
        return x

    # 0.0 and -0.0 both map to the smallest +ve float.
    if x == 0.0:
        x = 0.0

    n = f2i(x)
    if n >= 0:
        n += step
    else:
        n -= step
    return i2f(n)
```

next we would like to apply our floating-point stepping to try to do some local rng seed bruteforcing.

<timeseed.py>
```python
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

```

we assume that there is an uncertainty of +/- 1 second from when we sent the websocket connection request, plus average latency.
we assume that this error is distributed normally. so, we measuer the average latency to the websocket server.
paping is a great tool to do this:

```
$ paping misc.hsf.csaw.io -p 8001
paping v1.5.5 - Copyright (c) 2011 Mike Lovell

Connecting to misc.hsf.csaw.io on TCP 8001:

Connected to 216.165.2.42: time=26.27ms protocol=TCP port=8001
Connected to 216.165.2.42: time=25.65ms protocol=TCP port=8001
Connected to 216.165.2.42: time=24.68ms protocol=TCP port=8001
...
Connected to 216.165.2.42: time=25.10ms protocol=TCP port=8001
Connected to 216.165.2.42: time=25.64ms protocol=TCP port=8001
Connected to 216.165.2.42: time=26.01ms protocol=TCP port=8001
Connected to 216.165.2.42: time=27.04ms protocol=TCP port=8001
^C
Connection statistics:
        Attempted = 164, Connected = 164, Failed = 0 (0.00%)
Approximate connection times:
        Minimum = 24.62ms, Maximum = 33.35ms, Average = 25.84ms
```

so we know the time the server seeds (t_lag) the rng will be distributed statistically around the
time we initially sent the connection (t_sent) plus lag (25.84/1000.0).

we try values going from the mean (lag) outwards so that we have a higher chance of finding the server seed time quickly.

after some local testing, we are ready to move onto the Real Deal.
first we make a new account, with no upgrades other than the basic click and the passive random click.

we recycle out bot from click-150 and supreme-400 to achieve this.
discarding all of the active functionality to simply have it record scores over time.
we keep track of all differences in our score due to the randomclick tick.

<bot.py>
```python
#!/usr/bin/env python3

# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}

from socketIO_client import SocketIO
import sys,json,time,_thread,random
from timeseed import guess_t

def debug_on():
    import logging
    logging.getLogger('requests').setLevel(logging.WARNING)
    logging.basicConfig(level=logging.DEBUG)

#sessionid='431495fc-a126-4126-a79a-376c5159cb47' # clean2
sessionid='431495fc-a126-4126-a79a-376c5159cb47' # clean3

COLLECT_DATA_LEN=10
socketIO = None
connected = True
prevScore = -1
t_send = -1
num_updates = 0
t_last_upd = 0
server_rng = None
rng_need_fixup=True

diffs = []

def guess_thread(diffs_to_crack):
    global server_rng,rng_need_fixup

    guessed = guess_t(t_send, 25.84/1000,diffs_to_crack)
    if not guessed:
        print('GUESS FAILED')
        sys.exit(1)
    print('guessed:%f'%(guessed,))
    print(diffs_to_crack)
    server_rng = random.Random(guessed)
    rng_need_fixup=True

def on_update_response(*args):
    global prevScore,t_last_upd,num_updates,diffs,rng_need_fixup
    if not args:
        print('Empty response')
        global connected
        connected = False
        return
    data = args[0]
    score = data['score']
    print('%d    | %f s'%(score,time.time()-t_last_upd), end=' ')

    if prevScore != -1:
        dScore = score - prevScore
        if (t_last_upd != 0 and time.time() - t_last_upd >= 1.0) or dScore:
            t_last_upd = time.time()
            diffs.append(dScore)
            num_updates += 1
            print('+%d %d/%d'%(dScore,num_updates,COLLECT_DATA_LEN), end=' ')

            if num_updates == COLLECT_DATA_LEN:
                print("STARTING CRACK THREAD")
                _thread.start_new_thread(guess_thread, (list(diffs),))

            if server_rng and dScore < 100: # we cracked seed :)! , check dSCore<100 avoid lottery upd
                if rng_need_fixup: # need to match the rng back to server due to missed times
                    print("\nRNG FIXUP:")
                    for i in range(0,num_updates-1):
                        print(server_rng.randint(0,100),end=' ')
                    print()
                    rng_need_fixup = False

                predicted = server_rng.randint(0,100) # keep predicted rng LOCKSTEP with server
                print('predict:%d'%(predicted,))

                # do lottery guess here because more time between random updates
                lottery_guess=server_rng.randint(0,1000)
                print('LOTTERY GUESS:%d'%(lottery_guess,),end='')
                socketIO.emit('lottery', str(lottery_guess),callback=lottery_cb)

    print()

    prevScore = score

#   print data

def lottery_cb(*args):
    print('\nLOTTERY RESP:',end=' ')
    print(args)

def bot_update_loop():
    while connected:
        socketIO.emit('update', callback=on_update_response)
        socketIO.wait_for_callbacks(seconds=1)
        time.sleep(0.1)

def connect(sessionid):
    global connected
    global socketIO, t_send
    t_send = time.time()
    with SocketIO('misc.hsf.csaw.io', 8001, cookies={'session': sessionid}) as s:
        socketIO = s
        connected = True
        _thread.start_new_thread(bot_update_loop, ())
        try:
            while connected:
                time.sleep(1)
        except KeyboardInterrupt:
            connected = False
            return False
    return True

connect(sessionid)
```

shout out to GNU nano 2.2.6 because this garbage was coded with it

it is important to note that we must be wary of randomclick adding 0. if we record 100 outputs,
the birthday paradox suggests that we would have a (99/100)^100=61% chance of having at least 1 zero, which is significant.
so to deal with that we also do timekeeping to make sure that if a second passes with no recorded increase in score,
we assume that randomclick returned 0.

finally after sufficient data has been collected we brute force the seed in parallel to keeping track of the
server RNG state. once the seed is cracked we then cycle through a bunch of values to sync our predicted RNG state
back up with the server's. then we are able to make guesses at the lottery which is now trivial.

one key gotcha is that we must exclude updates in our score due to winning the lottery.
this will desync the RNG prediction.

with that we are done.

<win.txt>
```
cts@csaw:~/lot-350$ ./bot.py
2018091    | 1506397123.812545 s
2018091    | 1506397123.950002 s
2018152    | 1506397124.080688 s +61 1/10
2018152    | 0.131962 s
2018152    | 0.265932 s
2018152    | 0.399447 s
2018152    | 0.532377 s
2018152    | 0.664048 s
2018152    | 0.796388 s
2018152    | 0.928211 s
2018237    | 1.060140 s +85 2/10
2018237    | 0.132079 s
2018237    | 0.262267 s
2018237    | 0.394317 s
2018237    | 0.526726 s
2018237    | 0.659849 s
2018237    | 0.795125 s
2018276    | 0.928620 s +39 3/10
2018276    | 0.134095 s
2018276    | 0.264818 s
2018276    | 0.395085 s
2018276    | 0.525337 s
2018276    | 0.658013 s
2018276    | 0.789496 s
2018276    | 0.921058 s
2018321    | 1.053147 s +45 4/10
2018321    | 0.132680 s
2018321    | 0.269099 s
2018321    | 0.401179 s
2018321    | 0.539994 s
2018321    | 0.673516 s
2018321    | 0.804363 s
2018329    | 0.942195 s +8 5/10
2018329    | 0.133022 s
2018329    | 0.265926 s
2018329    | 0.396528 s
2018329    | 0.536720 s
2018329    | 0.673462 s
2018329    | 0.810954 s
2018329    | 0.961228 s
2018367    | 1.097484 s +38 6/10
2018367    | 0.141122 s
2018367    | 0.277440 s
2018367    | 0.418367 s
2018367    | 0.557850 s
2018367    | 0.693652 s
2018367    | 0.823977 s
2018369    | 0.957981 s +2 7/10
2018369    | 0.131669 s
2018369    | 0.267003 s
2018369    | 0.401902 s
2018369    | 0.543690 s
2018369    | 0.678120 s
2018369    | 0.808144 s
2018406    | 0.938695 s +37 8/10
2018406    | 0.130334 s
2018406    | 0.260536 s
2018406    | 0.390548 s
2018406    | 0.544056 s
2018406    | 0.678841 s
2018406    | 0.808774 s
2018406    | 0.939926 s
2018475    | 1.072680 s +69 9/10
2018475    | 0.133623 s
2018475    | 0.264305 s
2018475    | 0.397119 s
2018475    | 0.529723 s
2018475    | 0.661587 s
2018475    | 0.794483 s
2018503    | 0.931664 s +28 10/10 STARTING CRACK THREAD

4194304 steps
2018503    | 0.144771 s
2018503    | 0.292471 s
2018503    | 0.455748 s
2018503    | 0.627221 s
2018503    | 0.780927 s
2018503    | 0.933241 s
2018593    | 1.079821 s +90 11/10
2018593    | 0.150212 s
2018593    | 0.297859 s
2018593    | 0.445204 s
2018593    | 0.593006 s
2018593    | 0.741783 s
2018626    | 0.890482 s +33 12/10
2018626    | 0.153022 s
2018626    | 0.305685 s
2018626    | 0.460019 s
2018626    | 0.612860 s
2018626    | 0.768926 s
2018626    | 0.918895 s
2018640    | 1.064187 s +14 13/10
2018640    | 0.146546 s
2018640    | 0.292054 s
2018640    | 0.440072 s
2018640    | 0.586601 s
2018640    | 0.738033 s
2018640    | 0.883289 s
2018644    | 1.030466 s +4 14/10
2018644    | 0.147428 s
2018644    | 0.293631 s
2018644    | 0.441352 s
2018644    | 0.587735 s
FOUND 1506397123.620586
dt=0.032738
274624
guessed:1506397123.620586
[61, 85, 39, 45, 8, 38, 2, 37, 69, 28]
2018644    | 0.726901 s
2018644    | 0.859671 s
2018684    | 0.992655 s +40 15/10
RNG FIXUP:
61 85 39 45 8 38 2 37 69 28 90 33 14 4
predict:40
LOTTERY GUESS:631

LOTTERY RESP: (2000000,)
4018684    | 0.218966 s +2000000 16/10
4018684    | 0.133438 s
4018684    | 0.266569 s
4018684    | 0.398474 s
4018684    | 0.533038 s
4018684    | 0.670486 s
4018773    | 0.808304 s +89 17/10 predict:89
LOTTERY GUESS:859

LOTTERY RESP: (4000000,)
8018773    | 0.226516 s +4000000 18/10
8018773    | 0.146068 s
8018773    | 0.298071 s
8018773    | 0.434991 s
8018773    | 0.575330 s
8018798    | 0.706807 s +25 19/10 predict:25
LOTTERY GUESS:898

LOTTERY RESP: (8000000,)
16018798    | 0.217310 s +8000000 20/10
16018798    | 0.133225 s
16018798    | 0.264792 s
16018798    | 0.398084 s
16018798    | 0.530566 s
16018798    | 0.664458 s
16018828    | 0.797376 s +30 21/10 predict:30
LOTTERY GUESS:390

LOTTERY RESP: (16000000,)
32018828    | 0.219446 s +16000000 22/10
32018828    | 0.131873 s
32018828    | 0.269710 s
32018828    | 0.407322 s
32018828    | 0.548504 s
32018828    | 0.680366 s
32018897    | 0.813418 s +69 23/10 predict:69
LOTTERY GUESS:557

LOTTERY RESP: (32000000,)
64018897    | 0.218445 s +32000000 24/10
64018897    | 0.132418 s
64018897    | 0.265878 s
64018897    | 0.400243 s
64018897    | 0.535796 s
64018897    | 0.668939 s
64018914    | 0.800637 s +17 25/10 predict:17
LOTTERY GUESS:45

LOTTERY RESP: (64000000,)
128018914    | 0.223274 s +64000000 26/10
128018914    | 0.133319 s
128018914    | 0.270081 s
128018914    | 0.405265 s
128018914    | 0.540816 s
128018999    | 0.673036 s +85 27/10 predict:85
LOTTERY GUESS:734

LOTTERY RESP: (128000000,)
256018999    | 0.216897 s +128000000 28/10
256018999    | 0.138196 s
256018999    | 0.271027 s
256018999    | 0.407149 s
256018999    | 0.537793 s
256018999    | 0.668327 s
256019031    | 0.809431 s +32 29/10 predict:32
LOTTERY GUESS:243

LOTTERY RESP: (256000000,)
512019031    | 0.228919 s +256000000 30/10
512019031    | 0.139193 s
512019031    | 0.275153 s
512019031    | 0.411324 s
512019031    | 0.549708 s
512019031    | 0.681902 s
512019043    | 0.815726 s +12 31/10 predict:12
LOTTERY GUESS:368

LOTTERY RESP: (512000000,)
1024019043    | 0.217586 s +512000000 32/10
1024019043    | 0.131368 s
1024019043    | 0.263835 s
1024019043    | 0.394288 s
1024019043    | 0.526529 s
1024019043    | 0.657232 s
1024019050    | 0.788131 s +7 33/10 predict:7
LOTTERY GUESS:802

LOTTERY RESP: (1024000000,)
2048019050    | 0.216983 s +1024000000 34/10
2048019050    | 0.129626 s
2048019050    | 0.264884 s
2048019050    | 0.398072 s
2048019050    | 0.529953 s
2048019050    | 0.662397 s
2048019086    | 0.794407 s +36 35/10 predict:36
LOTTERY GUESS:613

LOTTERY RESP: (2048000000,)
4096019086    | 0.227056 s +2048000000 36/10
4096019086    | 0.143444 s
4096019086    | 0.277684 s
4096019086    | 0.409681 s
4096019086    | 0.542527 s
4096019111    | 0.676068 s +25 37/10 predict:25
LOTTERY GUESS:941

LOTTERY RESP: (4096000000,)
8192019111    | 0.220409 s +4096000000 38/10
8192019111    | 0.130719 s
8192019111    | 0.265403 s
8192019111    | 0.417377 s
8192019111    | 0.562070 s
8192019111    | 0.702889 s
8192019145    | 0.833645 s +34 39/10 predict:34
LOTTERY GUESS:362

LOTTERY RESP: (8192000000,)
16384019145    | 0.217301 s +8192000000 40/10
16384019145    | 0.132991 s
16384019145    | 0.265528 s
16384019145    | 0.396051 s
16384019145    | 0.527636 s
16384019145    | 0.658279 s
16384019240    | 0.789321 s +95 41/10 predict:95
LOTTERY GUESS:347

LOTTERY RESP: (16384000000,)
32768019240    | 0.217328 s +16384000000 42/10
32768019240    | 0.132191 s
32768019240    | 0.268343 s
32768019240    | 0.411111 s
32768019240    | 0.547267 s
32768019240    | 0.678966 s
32768019321    | 0.808834 s +81 43/10 predict:81
LOTTERY GUESS:153

LOTTERY RESP: ()
Empty response
Disconnected
```
