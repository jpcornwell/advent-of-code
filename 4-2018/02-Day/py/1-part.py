#!/usr/bin/env python3

from collections import Counter

with open('../input.txt') as f:
    content = f.readlines()

twice = 0
thrice = 0
for line in content:
    counts = Counter(line).values()
    if 2 in counts:
        twice += 1
    if 3 in counts:
        thrice += 1

answer = twice * thrice

print(answer)
