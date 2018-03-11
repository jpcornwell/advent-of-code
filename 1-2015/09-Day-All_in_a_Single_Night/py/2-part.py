#!/usr/bin/python3

from itertools import permutations
import re

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
    match = re.match(r'([^\s]*) to ([^\s]*) = (\d*)', line)
    start_vertex = match.group(1)
    end_vertex = match.group(2)
    weight = int(match.group(3))
    add_edge(start_vertex, end_vertex, weight)

vertices = graph.keys()

max_path_length = max([find_path_length(path) for path in permutations(vertices)])

print(max_path_length)
