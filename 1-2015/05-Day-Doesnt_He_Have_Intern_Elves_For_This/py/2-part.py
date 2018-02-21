import re

with open('../input.txt') as f:
    content = f.readlines()

nice_count = 0
for line in content:
    is_nice = True

    if not re.search(r'(..).*\1', line):
        is_nice = False

    if not re.search(r'(.).\1', line):
        is_nice = False

    if is_nice:
        nice_count += 1

print(nice_count)
