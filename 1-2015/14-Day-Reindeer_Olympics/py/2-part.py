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

reindeer_list = []
points = []

for line in content:
    speed, run_time, rest_time = map(int, re.findall(r'(\d+)', line))
    reindeer_list.append({'speed': speed, 'run_time': run_time, 
        'rest_time': rest_time})
    points.append(0)

for second in range(1, 2504):
    distances = []
    for reindeer in reindeer_list:
        dist = calc_distance(reindeer['speed'], reindeer['run_time'],
                reindeer['rest_time'], second)
        distances.append(dist)
    max_dist = max(distances)
    winners = [i for i, x in enumerate(distances) if x == max_dist]
    for winner in winners:
        points[winner] += 1

print(max(points))
