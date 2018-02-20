
with open('../input.txt') as f:
    directions = f.read().strip()

houses = {(0,0): 1}
x, y = 0, 0

for direction in directions:
    if direction == '^':
        y -= 1
    if direction == '<':
        x -= 1
    if direction == 'v':
        y += 1
    if direction == '>':
        x += 1

    if not (x,y) in houses:
        houses[(x,y)] = 1
    else:
        houses[(x,y)] += 1

print(len(houses.keys()))

