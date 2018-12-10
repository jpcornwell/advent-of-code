#!/usr/bin/env python

def total_score(combo):
    # hard coded ingredient properties (ignoring calories)
    ingredients = [(5, -1, 0, 0),
                   (-1, 3, 0, 0),
                   (0, -1, 4, 0),
                   (-1, 0, 0, 2)]

    score = 1

    for prop_idx in range(4): # loop through each property
        subtotal = 0
        for ingred_idx, teaspoons in enumerate(combo): # loop through each ingredient
            subtotal += ingredients[ingred_idx][prop_idx] * teaspoons
        if (subtotal < 0):
            subtotal = 0
        score *= subtotal

    return score


def combinations(teaspoons, ingredient_count):
    ans = []

    if ingredient_count == 1:
        return [(teaspoons,)]

    for i in range(teaspoons + 1):
        for rest in combinations(teaspoons - i, ingredient_count - 1):
            ans.append((i,) + rest)

    return ans

ans = max([total_score(combo) for combo in combinations(teaspoons=100, ingredient_count=4)])
print(ans)

