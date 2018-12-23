#!/usr/bin/env python3

from collections import deque

with open('../input.txt') as f:
    content = f.read()

def add_marble(marble_num, player_num, marbles):
    global player_scores
    if (marble_num % 23 == 0):
        player_scores[player_num] += marble_num
        marbles.rotate(7)
        player_scores[player_num] += marbles.popleft()
    else:
        marbles.rotate(-2)
        marbles.appendleft(marble_num)

player_count, max_marble_num = [int(x) for x in content.split(' ') if x.isdigit()]
max_marble_num *= 100

marbles = deque([0])
player_scores = [0] * player_count

marble_num = 1
player_num = 1

while (marble_num <= max_marble_num):
    add_marble(marble_num, player_num, marbles)
    marble_num += 1
    player_num = (player_num + 1) % player_count

print(max(player_scores))
