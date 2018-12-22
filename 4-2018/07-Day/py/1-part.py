#!/usr/bin/env python3

from collections import defaultdict
from string import ascii_uppercase

import re

with open('../input.txt') as f:
    content = f.readlines()

def parse_line(line):
    match = re.match(r'Step (\w) must be finished before step (\w) can begin.', line)
    return match.group(1), match.group(2)

def find_step(steps):
    for step in sorted(steps.keys()):
        if len(steps[step]) == 0:
            steps.pop(step)
            for reqs in steps.values():
                reqs.discard(step)
            return step

steps = defaultdict(set)

for line in content:
    requirement, step = parse_line(line)
    steps[step].add(requirement)

# Add steps that have no requirements
for step in ascii_uppercase:
    if step not in steps.keys():
        steps[step] = set()

answer = ''
while(len(steps.keys())):
    answer += find_step(steps)

print(answer)
