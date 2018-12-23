#!/usr/bin/env python3

with open('../input.txt') as f:
    content = f.read()

def parse_node():
    global nums
    global index
    node_value = 0
    child_values = []
    recurse_count = nums[index]
    meta_count = nums[index + 1]
    index += 2
    for _ in range(recurse_count):
        child_values.append(parse_node())
    for _ in range(meta_count):
        meta_value = nums[index]
        if (recurse_count == 0):
            node_value += meta_value
        else:
            if meta_value in range(1, len(child_values) + 1):
                node_value += child_values[meta_value - 1]
        index += 1
    return node_value

nums = [int(x) for x in content.split(' ')]
index = 0

root_node_value = parse_node()

print(root_node_value)
