#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @asteroid-map = @AOC-INPUT-LINES.map: {Array($_.comb)};

# Get list of asteroids
my @asteroids;
for @asteroid-map.kv -> $y, $line {
    for $line.kv -> $x, $char {
        @asteroids.push(($x, $y)) if $char eq '#';
    }
}

# Get the best asteroid
my $max-visible-count = 0;
my @best-asteroid;
for @asteroids -> @asteroid {
    my $visible-count = 0;

    $visible-count++ if is-visible(@asteroid, $_) for @asteroids;

    if $visible-count > $max-visible-count {
        $max-visible-count = $visible-count;
        @best-asteroid = @asteroid;
    }
}

# Start destroying the other asteroids
my @visible-asteroids;
my $destroyed-count = 0;
my @destroyed-asteroid;
LOOP:
loop {
    # Recompute asteroids;
    @asteroids = [];
    for @asteroid-map.kv -> $y, $line {
        for $line.kv -> $x, $char {
            @asteroids.push(($x, $y)) if $char eq '#';
        }
    }

    # Find visible asteroids
    @visible-asteroids = @asteroids
        .grep({is-visible(@best-asteroid, $_) == True});

    # Handle right half
    my @right-half-visibles = @visible-asteroids
        .grep({$_[0] >= @best-asteroid[0] })
        .sort({ ($_[1] - @best-asteroid[1]) / ($_[0] - @best-asteroid[0]) });
    for @right-half-visibles -> @asteroid {
        $destroyed-count++;
        @destroyed-asteroid = @asteroid;
        @asteroid-map[@asteroid[1]][@asteroid[0]] = '.';
        last LOOP if $destroyed-count == 200;
    }

    # Handle left half
    my @left-half-visibles = @visible-asteroids
        .grep({$_[0] < @best-asteroid[0] })
        .sort({ ($_[1] - @best-asteroid[1]) / ($_[0] - @best-asteroid[0]) });
    for @left-half-visibles -> @asteroid {
        $destroyed-count++;
        @destroyed-asteroid = @asteroid;
        @asteroid-map[@asteroid[1]][@asteroid[0]] = '.';
        last LOOP if $destroyed-count == 200;
    }
}

say "200th asteroid is @destroyed-asteroid[]";

sub is-visible(@origin, @asteroid) {
    # Asteroid can't see itself
    return False if @origin[0] == @asteroid[0] and @origin[1] == @asteroid[1];

    my $x-delta = @asteroid[0] - @origin[0];
    my $y-delta = @asteroid[1] - @origin[1];

    # Figure out smallest "step"
    my $gcd = $x-delta gcd $y-delta;
    if $gcd == 0 {
        say "WHOA WHOA WHOA";
        say "WHOA WHOA WHOA";
        say "WHOA WHOA WHOA";
        say $x-delta, $y-delta;
        say "origin: {@origin[].perl}";
        say "asteroid: {@asteroid[].perl}";
    }
    my $x-step = ($x-delta / $gcd).Int;
    my $y-step = ($y-delta / $gcd).Int;

    # Walk step by step and check if there are any other asteroids
    my $x = @origin[0] + $x-step;
    my $y = @origin[1] + $y-step;
    until ($x, $y) eqv @asteroid {
        return False if @asteroid-map[$y][$x] eq '#';
        $x += $x-step;
        $y += $y-step;
    }

    return True;
}
