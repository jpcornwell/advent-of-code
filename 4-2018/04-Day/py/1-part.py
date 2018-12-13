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
            guards[current_guard]['total'] += 1
            guards[current_guard][i] += 1

max_guard = max(guards.keys(), key=(lambda key: guards[key]['total']))
max_minute = max(guards[max_guard].keys(), key=(lambda key: guards[max_guard][key] if isinstance(key, int) else 0))

answer = max_guard * max_minute

print(answer)
