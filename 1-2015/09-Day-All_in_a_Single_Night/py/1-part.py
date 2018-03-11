#!/usr/bin/python3

from collections import defaultdict
from itertools import permutations

graph = defaultdict(dict)

def add_edge(start, end, weight):
    graph[start][end] = weight
    graph[end][start] = weight

def edge_length(start, end):
    return graph[start][end]

def path_length(path):
    return sum([edge_length(*edge) for edge in zip(path, path[1:])])

with open('../input.txt') as f:
    content = f.readlines()

for line in content:
    (start, _, dest, _, weight) = line.split()
    add_edge(start, dest, int(weight))

vertices = graph.keys()

min_path_length = min([path_length(path) for path in permutations(vertices)])

print(min_path_length)
