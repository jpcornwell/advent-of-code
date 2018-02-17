
def fetch_boxes():
    with open('../input.txt') as f:
        content = f.readlines()

    content = [line.strip().split('x') for line in content]
    boxes = [tuple(map(int, line)) for line in content]
    
    return boxes

def get_required_paper(dimensions):
    l, w, h = dimensions
    sides = (l*w, l*h, w*h)

    surface_area = sum([2*side for side in sides])
    extra = min(sides)

    return surface_area + extra

boxes = fetch_boxes()

total = sum([get_required_paper(box) for box in boxes])

print(total)
