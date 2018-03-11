#!/usr/bin/python3

from itertools import permutations

graph = {}

def add_edge(start, end, weight):
    if start not in graph:
        graph[start] = {}
    if end not in graph:
        graph[end] = {}

    graph[start][end] = weight
    graph[end][start] = weight

def find_edge_length(start, end):
    return graph[start][end]

def find_path_length(path):
    return sum([find_edge_length(start, end) for start, end in zip(path, path[1:])])

with open('../input.txt') as f:
    content = f.readlines()

for line in content:
    (start, _, dest, _, weight) = line.split()
    add_edge(start, dest, int(weight))

vertices = graph.keys()

max_path_length = max([find_path_length(path) for path in permutations(vertices)])

print(max_path_length)
