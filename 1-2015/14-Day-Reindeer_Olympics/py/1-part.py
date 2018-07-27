#!/usr/bin/env python

import re

def calc_distance(speed, run_time, rest_time, duration):
    dist = 0
    full_cycles = duration // (run_time + rest_time)
    dist += full_cycles * run_time * speed
    remainder = duration % (run_time + rest_time)
    if remainder < run_time:
        dist += remainder * speed
    else:
        dist += run_time * speed
    return dist

with open('../input.txt') as f:
    content = f.readlines()

distances = []

for line in content:
    m = re.search(r'(\d+)[^\d]+(\d+)[^\d]+(\d+)', line)
    speed = int(m.group(1))
    run_time = int(m.group(2))
    rest_time = int(m.group(3))
    distances.append(calc_distance(speed, run_time, rest_time, 2503))

print(max(distances))
