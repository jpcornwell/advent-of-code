#!/usr/bin/env python

from collections import defaultdict
from itertools import permutations

graph = defaultdict(dict)

with open('../input.txt') as f:
    content = f.readlines()

for line in content:
    (source, _, direction, change, _, _, _, _, _, _, dest) = line.split(' ')
    dest = dest[:-2] # trim the punctuation and newline
    change = int(change)
    if direction == 'lose':
        change = change * -1
    graph[source][dest] = change

people = graph.keys()

# add myself to the feast
for person in people:
    graph['Jacob'][person] = 0
    graph[person]['Jacob'] = 0
people.append('Jacob')

perms = list(permutations(people))

max_happy = 0
for perm in perms:
    happy = 0

    # handle the first person
    happy += graph[perm[0]][perm[1]]
    happy += graph[perm[0]][perm[-1]]

    # handle the last person
    happy += graph[perm[-1]][perm[-2]]
    happy += graph[perm[-1]][perm[0]]

    # handle the rest of the people (hard coded to 9 people)
    for i in range(1, 8):
        happy += graph[perm[i]][perm[i+1]]
        happy += graph[perm[i]][perm[i-1]]

    if happy > max_happy:
        max_happy = happy

print(max_happy)
