import sys

directions = sys.argv[1]

up_count = directions.count('(')
down_count = directions.count(')');

end_floor = up_count - down_count

print(end_floor)
