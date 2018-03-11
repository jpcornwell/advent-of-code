#!/usr/bin/python3

from collections import defaultdict
from itertools import permutations

graph = defaultdict(dict)

def add_edge(v1, v2, weight):
    graph[v1][v2] = weight
    graph[v2][v1] = weight

def edge_weight(v1, v2):
    return graph[v1][v2]

def path_weight(path):
    return sum([edge_weight(*edge) for edge in zip(path, path[1:])])

with open('../input.txt') as f:
    content = f.readlines()

for line in content:
    (start, _, dest, _, weight) = line.split()
    add_edge(start, dest, int(weight))

vertices = graph.keys()

max_path_weight = max([path_weight(path) for path in permutations(vertices)])

print(max_path_weight)
