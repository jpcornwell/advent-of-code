#!/usr/bin/env python3

from collections import defaultdict
from itertools import cycle

with open('../input.txt') as f:
    content = f.readlines()

changes = [int(line) for line in content]

freq = 0
visited = defaultdict(bool)

for change in cycle(changes):
    if not visited[freq]:
        visited[freq] = True
        freq += change
    else:
        print(freq)
        exit()

