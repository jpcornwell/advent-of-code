#!/usr/bin/env python3

with open('../input.txt') as f:
    content = f.readlines()

def location_within_region(x, y, points):
    LIMIT = 10_000
    return sum([dist(x, y, p_x, p_y) for p_x, p_y in points.values()]) < LIMIT

def dist(x_1, y_1, x_2, y_2):
    return abs(x_1 - x_2) + abs(y_1 - y_2)

GRID_WIDTH = 500
GRID_HEIGHT = 500

points = {(i + 1): tuple(int(x) for x in line.split(',')) for i, line in enumerate(content)}

area_tally = 0

for x in range(GRID_WIDTH):
    for y in range(GRID_HEIGHT):
        if (location_within_region(x, y, points)):
            area_tally += 1

print(area_tally)
