#!/usr/bin/env python3

with open('../input.txt') as f:
    content = f.read()

def parse_node(index, nums):
    global total
    recurse_count = nums[index]
    meta_count = nums[index + 1]
    index += 2
    for _ in range(recurse_count):
        index = parse_node(index, nums)
    for _ in range(meta_count):
        total += nums[index]
        index += 1
    return index

nums = [int(x) for x in content.split(' ')]
total = 0

parse_node(0, nums)

print(total)
