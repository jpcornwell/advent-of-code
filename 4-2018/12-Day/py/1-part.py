#!/usr/bin/env python3

from collections import defaultdict

GENERATION_COUNT = 20

with open('../input.txt') as f:
    content = f.readlines()

# List that allows for negative indices
# Only supports indexing, slicing, append, and prepend
class UnboundList(list):
    def __init__(self, *args):
        list.__init__(self, *args)
        self.offset = 0
    def __str__(self):
        result = '['
        for item in self[:0]:
            result += repr(item) + ', '
        result = result[:-2]
        result += '> | <'
        for item in self[0:]:
            result += repr(item) + ', '
        result = result[:-2]
        result += ']'
        return result
    def __repr__(self):
        return str(self)
    def __getitem__(self, key):
        if isinstance(key, slice):
            return list.__getitem__(self, slice(key.start + self.offset if key.start is not None else None,
                                                key.stop + self.offset if key.stop is not None else None, 
                                                key.step))
        return list.__getitem__(self, key + self.offset)
    def __setitem__(self, key, item):
        if isinstance(key, slice):
            return list.__setitem__(self, 
                                    slice(key.start + self.offset if key.start is not None else None,
                                          key.stop + self.offset if key.stop is not None else None, 
                                          key.step), 
                                    item)
        list.__setitem__(self, key + self.offset, item)
    def insert(self, key, item):
        list.insert(self, key + self.offset, item)
    def prepend(self, item):
        self.offset += 1
        self.insert(-self.offset, item)
    def start(self):
        return -self.offset
    def end(self):
        return -self.offset + len(self) - 1

# pad list until there are 5 empty pots on each end
def pad_generation(generation):
    while True in generation[:generation.start()+5]:
        generation.prepend(False)
    while True in generation[generation.end()-4:]:
        generation.append(False)

rules = defaultdict(bool)
temp = dict()

# parse input
for line in content:
    if 'initial state' in line:
        origin = [char == '#' for char in line.split()[2]]
    if '=>' in line:
        lh, _, rh = line.split()
        key = tuple(char == '#' for char in lh)
        rules[key] = (rh == '#')

# run through generations
generation = UnboundList(origin)
for _ in range(GENERATION_COUNT):
    pad_generation(generation)
    for i in range(generation.start() + 2, generation.end() - 1):
        if rules[tuple(generation[i-2:i+3])]:
            temp[i] = True
        else:
            temp[i] = False
    for i in range(generation.start() + 2, generation.end() - 1):
        generation[i] = temp[i]

# calculate the answer
total = 0
for i in range(generation.start(), generation.end()+1):
    if generation[i]:
        total += i

print(total)
