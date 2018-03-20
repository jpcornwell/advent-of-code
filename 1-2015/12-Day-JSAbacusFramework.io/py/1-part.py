#!/usr/bin/python3

import re

with open('../input.txt') as f:
    content = f.read()

numbers = re.findall(r'-?\d+', content)

total = 0
for number in numbers:
    total += int(number)

print(total)
