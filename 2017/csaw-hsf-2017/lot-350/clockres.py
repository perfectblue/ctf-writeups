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
