#!/usr/bin/python3

import json

def sumObj(obj):
    if isinstance(obj, int):
        return obj
    if isinstance(obj, str):
        return 0
    if isinstance(obj, list):
        return sum([sumObj(x) for x in obj])
    if isinstance(obj, dict):
        if 'red' in obj.values():
            return 0
        else:
            return sum([sumObj(x) for x in obj.values()])

with open('../input.txt') as f:
    content = f.read()

data = json.loads(content)

total = sumObj(data)

print(total)
