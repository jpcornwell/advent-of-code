
with open('../input.txt') as f:
    directions = f.read().strip()

santa_directions = directions[::2]
robo_santa_directions = directions[1::2]

houses = {(0,0): 1}

# Santa visits houses
x, y = 0, 0
for direction in santa_directions:
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

# Robo-Santa visits houses
x, y = 0, 0
for direction in robo_santa_directions:
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

