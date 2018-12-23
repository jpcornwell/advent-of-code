#!/usr/bin/env python3

with open('../input.txt') as f:
    content = f.read()

def add_marble(marble_num, player_num, marbles):
    global current_index
    global player_scores
    if (marble_num % 23 == 0):
        player_scores[player_num] += marble_num
        new_index = (current_index - 7) % len(marbles)
        player_scores[player_num] += marbles.pop(new_index)
    else:
        new_index = (current_index + 2) % len(marbles)
        marbles.insert(new_index, marble_num)
    current_index = new_index

player_count, max_marble_num = [int(x) for x in content.split(' ') if x.isdigit()]

marbles = [0]
current_index = 0
player_scores = [0] * player_count

marble_num = 1
player_num = 1

while (marble_num <= max_marble_num):
    add_marble(marble_num, player_num, marbles)
    marble_num += 1
    player_num = (player_num + 1) % player_count

print(max(player_scores))
