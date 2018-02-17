import sys

instructions = sys.argv[1]

current_floor = 0
step_number = 0

for index, direction in enumerate(instructions):
    if direction == '(':
        current_floor += 1
    if direction == ')':
        current_floor -= 1
    if current_floor == -1:
        step_number = index + 1
        break

print(step_number)
