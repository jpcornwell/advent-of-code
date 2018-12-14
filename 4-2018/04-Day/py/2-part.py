#!/usr/bin/env python3

import re

from collections import defaultdict

with open('../input.txt') as f:
    content = f.readlines()

content.sort()

guards = defaultdict(lambda: defaultdict(int))

current_guard = 0
last_minute = 0
for line in content:
    if 'begins shift' in line:
        current_guard = int(re.findall(r'#(\d*)', line)[0])
    if 'falls asleep' in line:
        last_minute = int(re.findall(r':(\d*)', line)[0])
    if 'wakes up' in line:
        current_minute = int(re.findall(r':(\d*)', line)[0])
        for i in range(last_minute, current_minute):
            guards[current_guard][i] += 1

flat_guards = [(guard, minute, guards[guard][minute]) for guard in guards.keys() for minute in guards[guard].keys()]

max_guard, max_minute, *_ = max(flat_guards, key=(lambda x: x[2]))

answer = max_guard * max_minute

print(answer)
