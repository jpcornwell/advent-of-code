#!/usr/bin/python3

from itertools import tee
import re
from string import ascii_lowercase

def nextPassword(password):
    p = list(password)
    for i in reversed(range(len(p))):
        if p[i] == 'z':
            p[i] = 'a'
        else:
            p[i] = chr(ord(p[i]) + 1)
            break
    return ''.join(p)

def validatePassword(password):
    if not any(''.join(triple) in password for triple in 
            groupwise(ascii_lowercase, 3)):
        return False

    if any(char in password for char in ['i', 'o', 'l']):
        return False

    if len(re.findall(r'(.)\1', password)) < 2:
        return False

    return True

def groupwise(iterable, n=2):
    t = tee(iterable, n)
    for i in range(1, n):
        for j in range(0, i):
            next(t[i], None)
    return zip(*t)

with open('../input.txt') as f:
    password = f.read().strip()

while (not validatePassword(password)):
    password = nextPassword(password)

print(password)
