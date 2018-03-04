import re

with open('../input.txt') as f:
    content = f.read().splitlines()

literal_char_count = 0
for line in content:
    literal_char_count += len(line)

memory_char_count = 0
for line in content:
    line = line.replace(r'\\', 'Z')
    line = line.replace(r'\"', 'Z')
    line = re.sub(r'\\x[0-9a-fA-F]{2}', 'Z', line)
    memory_char_count += len(line) - 2 # minus 2 to account for the double quotes

print(literal_char_count - memory_char_count)
