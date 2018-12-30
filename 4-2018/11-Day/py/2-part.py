#!/usr/bin/env python3

from collections import defaultdict
from functools import lru_cache

with open('../input.txt') as f:
    content = f.read()

def power_level(x, y, serial_num):
    rack_id = x + 10
    power = (rack_id * y + serial_num) * rack_id
    power = (power % 1000) // 100 # take the hundreds digit
    power -= 5
    return power

# assumes x, y won't lead to out of bounds condition
# move grid to global so I can use lru_cache (decorator doesn't like
#   non-hashable arguments)
@lru_cache(maxsize=None)
def square_power(x, y, size):
    global grid
    if size == 1:
        power = grid[x][y]
    else:
        power = square_power(x, y, size - 1)
        # add right edge
        power += sum(grid[x+size-1][b] for b in range(y, y + size))
        # add bottom edge
        # be sure not to double count the bottom right corner
        power += sum(grid[a][y+size-1] for a in range(x, x + size - 1))
    return power


serial_num = int(content)

grid = defaultdict(dict)

# populate the grid
for x in range(1, 301):
    for y in range(1, 301):
        grid[x][y] = power_level(x, y, serial_num)

max_power = 0
answer = (-1, -1, -1)
for size in range(1, 300):
    for x in range(1, 301 - (size - 1)):
        for y in range(1, 301 - (size - 1)):
            power = square_power(x, y, size)
            if power > max_power:
                max_power = power
                answer = (x, y, size)

print(answer)
