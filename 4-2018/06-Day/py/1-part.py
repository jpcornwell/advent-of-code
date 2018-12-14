#!/usr/bin/env python3

from collections import defaultdict

with open('../input.txt') as f:
    content = f.readlines()

def closest_point_id(x, y, points):
    dists = {point_id: dist(x, y, *point_coords) for point_id, point_coords in points.items()}
    min_dist = min(dists.values())
    closest_point_ids = [_id for _id, dist in dists.items() if dist == min_dist]
    if len(closest_point_ids) > 1:
        return 0
    else:
        return closest_point_ids[0]

def dist(x_1, y_1, x_2, y_2):
    return abs(x_1 - x_2) + abs(y_1 - y_2)

GRID_WIDTH = 500
GRID_HEIGHT = 500

points = {(i + 1): tuple(int(x) for x in line.split(',')) for i, line in enumerate(content)}

grid = [[0 for y in range(GRID_HEIGHT)] for x in range(GRID_WIDTH)]

area_tally = defaultdict(int)

for x in range(GRID_WIDTH):
    for y in range(GRID_HEIGHT):
        point_id = closest_point_id(x, y, points)
        grid[x][y] = point_id
        area_tally[point_id] += 1

# set infinite areas to 0 (by seeing what touches the edges of the grid)
for x in range(GRID_WIDTH):
    area_tally[grid[x][0]] = 0
    area_tally[grid[x][GRID_HEIGHT - 1]] = 0
for y in range(GRID_HEIGHT):
    area_tally[grid[0][y]] = 0
    area_tally[grid[GRID_WIDTH - 1][y]] = 0

answer = max(area_tally.values())
print(answer)
