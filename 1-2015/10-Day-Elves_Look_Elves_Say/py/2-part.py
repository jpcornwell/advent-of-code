#!/usr/bin/python3

from itertools import groupby

def look_and_say(seq):
    next_seq = ''.join([str(len(list(g))) + k for k, g in groupby(seq)])
    return next_seq

with open('../input.txt') as f:
    seq = f.read().strip()

for _ in range(50):
    seq = look_and_say(seq)

print(len(seq))
