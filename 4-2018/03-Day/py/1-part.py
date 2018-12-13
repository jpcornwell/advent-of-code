#!/usr/bin/env python3

import re

def parse_line(line):
    match = re.match(r'#(\d*) @ (\d*),(\d*): (\d*)x(\d*)', line)
    claim_number = match.group(1)
    x_pos = int(match.group(2))
    y_pos = int(match.group(3))
    width = int(match.group(4))
    height = int(match.group(5))
    return claim_number, x_pos, y_pos, width, height

with open('../input.txt') as f:
    content = f.readlines()

grid = [[0 for y in range(1001)] for x in range(1001)]

# make claims
for line in content:
    claim_number, x_pos, y_pos, width, height = parse_line(line)
    for x in range(x_pos, x_pos + width):
        for y in range(y_pos, y_pos + height):
            grid[x][y] += 1

overlapped = sum([1 if (grid[x][y] > 1) else 0 for x in range(1001) for y in range(1001)])

print(overlapped)
