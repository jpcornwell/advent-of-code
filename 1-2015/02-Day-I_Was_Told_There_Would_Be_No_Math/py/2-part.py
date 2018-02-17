
def fetch_boxes():
    with open('../input.txt') as f:
        content = f.readlines()

    content = [line.strip().split('x') for line in content]
    boxes = [tuple(map(int, line)) for line in content]
    
    return boxes

def get_required_ribbon(dimensions):
    l, w, h = dimensions
    max_dimension = max(dimensions)

    min_two_dimensions = list(dimensions)
    min_two_dimensions.remove(max_dimension)

    wrap = sum(min_two_dimensions) * 2
    bow = l * w * h

    return wrap + bow

boxes = fetch_boxes()

total = sum([get_required_ribbon(box) for box in boxes])

print(total)
