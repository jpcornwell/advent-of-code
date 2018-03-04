import re

with open('../input.txt') as f:
    content = f.read().splitlines()

literal_char_count = 0
for line in content:
    literal_char_count += len(line)

new_char_count = 0
for line in content:
    line = line.replace('\\', 'ZZ')
    line = line.replace(r'"', 'ZZ')
    new_char_count += len(line) + 2 # plus 2 to account for the double quotes

print(new_char_count - literal_char_count)
