#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

class Ingredient {
    has $.name is rw;
    has $.count is rw;
}

class Recipe {
    has @.ingredients is rw;
    has $.result is rw;
}

my @lines = @AOC-INPUT-LINES;

# Parse recipes
my %recipes-by-result;
for @lines -> $line {
    grammar Input-Grammar {
        rule TOP { [<ingredient> + % ',' ] '=>' <result=.ingredient> }
        rule ingredient { <count> <name> }
        token name { <.alpha>+ }
        token count { <.digit>+ }
    }

    my $match = Input-Grammar.parse($line);

    # I feel like there must be a better way to extract the match data into
    # a Recipe object
    my $recipe = Recipe.new;
    
    # Extract result portion
    my $ingredient = Ingredient.new;
    $ingredient.name = $match<result><name>.Str;
    $ingredient.count = $match<result><count>.Str;
    $recipe.result = $ingredient;

    # Extract the ingredients portion
    for $match<ingredient> -> $x {
        $ingredient = Ingredient.new;
        $ingredient.name = $x<name>.Str;
        $ingredient.count = $x<count>.Str;
        $recipe.ingredients.push($ingredient);
    }

    %recipes-by-result{$recipe.result.name} = $recipe;
}

my $start = 1_000_000_000_000 div get-ore-count('FUEL', 1);
my $fuel = $start;
my $incr = 1_000_000;
# Avoid unnecessary work by starting with big increments, and then hone in on
# solution with smaller increments.
loop {
    $fuel += $incr;
    if get-ore-count('FUEL', $fuel) > 1e12 {
        $fuel -= $incr;
        $incr div= 10;
        last if $incr == 0;
    }
}

say "Max fuel: $fuel";

my %ingredient-store is default(0);
sub get-ore-count($prod-name, $amount) {
    my $ore-count = 0;
    my $recipe = %recipes-by-result{$prod-name};
    my $recipe-count = (($amount - %ingredient-store{$prod-name} - 1) div $recipe.result.count.Int) + 1;

    for $recipe.ingredients -> $ingredient {
        my $name = $ingredient.name;
        if $name eq 'ORE' {
            $ore-count += $ingredient.count * $recipe-count;
        } else {
            $ore-count += get-ore-count($name, $ingredient.count * $recipe-count);
        }
    }

    %ingredient-store{$prod-name} += $recipe-count * $recipe.result.count.Int - $amount;

    return $ore-count;
}
