#!/usr/bin/env python3

from collections import defaultdict

with open('../input.txt') as f:
    content = f.read()

def power_level(x, y, serial_num):
    rack_id = x + 10
    power = (rack_id * y + serial_num) * rack_id
    power = (power % 1000) // 100 # take the hundreds digit
    power -= 5
    return power

# assumes x, y won't lead to out of bounds condition
def square_power(x, y, grid):
    power = sum([grid[a][b] for a in range(x, x+3) 
                            for b in range(y, y+3)])
    return power


serial_num = int(content)

grid = defaultdict(dict)

# populate the grid
for x in range(1, 301):
    for y in range(1, 301):
        grid[x][y] = power_level(x, y, serial_num)

max_power = 0
answer = (-1, -1)
for x in range(1, 299):
    for y in range(1, 299):
        power = square_power(x, y, grid)
        if power > max_power:
            max_power = power
            answer = (x, y)

print(answer)
