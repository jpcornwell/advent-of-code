
def solve(wire, assignments):
    # wire is not actually a wire, it is a number
    if wire.isdigit():
        return int(wire)

    # the value of the wire has already been calculated from a previous call
    if isinstance(assignments[wire], int):
        return assignments[wire]

    parsed = assignments[wire].split(' ')

    # no operator is found, its just a simple assignment
    if len(parsed) == 1:
        return solve(parsed[0], assignments)

    if 'NOT' in parsed:
        ans = ~ solve(parsed[1], assignments)
        assignments[wire] = ans
        return ans
    if 'AND' in parsed:
        ans = solve(parsed[0], assignments) & solve(parsed[2], assignments)
        assignments[wire] = ans
        return ans
    if 'OR' in parsed:
        ans = solve(parsed[0], assignments) | solve(parsed[2], assignments)
        assignments[wire] = ans
        return ans
    if 'LSHIFT' in parsed:
        ans = solve(parsed[0], assignments) << solve(parsed[2], assignments)
        assignments[wire] = ans
        return ans
    if 'RSHIFT' in parsed:
        ans = solve(parsed[0], assignments) >> solve(parsed[2], assignments)
        assignments[wire] = ans
        return ans

with open('../input.txt') as f:
    content = f.readlines()

assignments = {}

for line in content:
    parsed = line.split('->')
    key = parsed[1].strip()
    value = parsed[0].strip()
    assignments[key] = value

assignments['b'] = 16076

print(solve('a', assignments))
