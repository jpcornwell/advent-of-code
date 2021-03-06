import re

def parse_line(line):
    match = re.match(r'(\D*)(\d*),(\d*)\D*(\d*),(\d*)', line)
    action = match.group(1).strip()
    x1 = int(match.group(2))
    y1 = int(match.group(3))
    x2 = int(match.group(4))
    y2 = int(match.group(5))
    return action, x1, y1, x2, y2

with open('../input.txt') as f:
    content = f.readlines()

grid = [[False for y in range(1000)] for x in range(1000)]

for line in content:
    action, x1, y1, x2, y2 = parse_line(line)
    assert(x1 <= x2)
    assert(y1 <= y2)
    for x in range(x1, x2+1):
        for y in range(y1, y2+1):
            if action == 'turn on':
                grid[x][y] = True
            if action == 'turn off':
                grid[x][y] = False
            if action == 'toggle':
                grid[x][y] = not grid[x][y]

on_count = [grid[x][y] for x in range(1000) for y in range(1000)].count(True)

print(on_count)
