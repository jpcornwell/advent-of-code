#!/usr/bin/env python3

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

polymer = content

old_len, new_len = 0, 1
while(old_len != new_len):
    old_len = len(polymer)
    polymer = react(polymer)
    new_len = len(polymer)

answer = new_len

print(answer)
