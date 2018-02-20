import hashlib

with open('../input.txt') as f:
    key = f.read().strip()

answer = 1
while True:
    md5 = hashlib.md5(key+str(answer)).hexdigest()
    if md5[:6] == '000000':
        break
    answer += 1

print answer
