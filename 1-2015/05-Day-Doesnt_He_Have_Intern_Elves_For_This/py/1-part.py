import re

with open('../input.txt') as f:
    content = f.readlines()

nice_count = 0
for line in content:
    is_nice = True

    if sum([line.count(x) for x in 'aeiou']) < 3:
        is_nice = False

    if not re.search(r'(.)\1', line):
        is_nice = False

    if 'ab' in line or 'cd' in line or 'pq' in line or 'xy' in line:
        is_nice = False

    if is_nice:
        nice_count += 1

print(nice_count)
