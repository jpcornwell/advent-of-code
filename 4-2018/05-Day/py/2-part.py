#!/usr/bin/env python3

from math import inf
from string import ascii_lowercase

with open('../input.txt') as f:
    content = f.read().strip()

def react(polymer):
    i = 0
    while i < len(polymer) - 1:
        char, next_char = polymer[i], polymer[i + 1]
        if ord(char) - ord(next_char) in (32, -32):
            polymer = polymer[:i] + polymer[i+2:]
        i += 1
    return polymer

orig_polymer = content
min_len = inf

for char in ascii_lowercase:
    print(char)
    polymer = orig_polymer.replace(char, '').replace(chr(ord(char)-32), '')
    old_len, new_len = 0, 1
    while(old_len != new_len):
        old_len = len(polymer)
        polymer = react(polymer)
        new_len = len(polymer)
    if new_len < min_len:
        min_len = new_len

print(min_len)
