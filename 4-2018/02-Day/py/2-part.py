#!/usr/bin/env python3

from itertools import combinations

def diff_count(a_str, b_str):
    return sum([1 for a_char, b_char in zip(a_str, b_str) if a_char != b_char])

def diffs_removed(a_str, b_str):
    return ''.join([a_char for a_char, b_char in zip(a_str, b_str) if a_char == b_char])

with open('../input.txt') as f:
    content = f.readlines()

for x, y in combinations(content, 2):
    if diff_count(x, y) == 1:
        print(x, y)
        print(diffs_removed(x, y))
