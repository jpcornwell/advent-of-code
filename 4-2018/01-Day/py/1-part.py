#!/usr/bin/env python3

with open('../input.txt') as f:
    content = f.read().replace('\n','')

print(eval(content))
