#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @asteroid-map = @AOC-INPUT-LINES;

# Get list of points
my @points;
for @asteroid-map.kv -> $y, $line {
    for $line.comb.kv -> $x, $char {
        @points.push(($x, $y)) if $char eq '#';
    }
}

my $max-visible-count;

for @points -> @point {
    my $visible-count = 0;

    $visible-count++ if is-visible(@point, $_) for @points;

    $max-visible-count max= $visible-count;
}

say "Max visible count: $max-visible-count";

sub is-visible(@origin, @asteroid) {
    # Asteroid can't see itself
    return False if @origin eqv @asteroid;

    my $x-delta = @asteroid[0] - @origin[0];
    my $y-delta = @asteroid[1] - @origin[1];

    # Figure out smallest "step"
    my $gcd = $x-delta gcd $y-delta;
    my $x-step = ($x-delta / $gcd).Int;
    my $y-step = ($y-delta / $gcd).Int;

    # Walk step by step and check if there are any other asteroids
    my $x = @origin[0] + $x-step;
    my $y = @origin[1] + $y-step;
    until ($x, $y) eqv @asteroid {
        return False if ($x, $y) eqv any(@points);
        $x += $x-step;
        $y += $y-step;
    }

    return True;
}
