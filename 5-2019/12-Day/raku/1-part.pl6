#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

class Planet {
    has ($.x-pos, $.y-pos, $.z-pos,
         $.x-vel, $.y-vel, $.z-vel) is rw;
}

sub run-step(@planets) {
    # Adjust velocities
    for @planets X @planets -> ($a, $b) {
        $a.x-vel += 1 if $a.x-pos < $b.x-pos;
        $a.x-vel -= 1 if $a.x-pos > $b.x-pos;
        $a.y-vel += 1 if $a.y-pos < $b.y-pos;
        $a.y-vel -= 1 if $a.y-pos > $b.y-pos;
        $a.z-vel += 1 if $a.z-pos < $b.z-pos;
        $a.z-vel -= 1 if $a.z-pos > $b.z-pos;
    }

    # Adjust positions
    for @planets {
        .x-pos += .x-vel;
        .y-pos += .y-vel;
        .z-pos += .z-vel;
    }
}

sub calc-total-energy(@planets) {
    my $sum = 0;

    $sum += ($_.x-pos.abs + $_.y-pos.abs + $_.z-pos.abs) *
            ($_.x-vel.abs + $_.y-vel.abs + $_.z-vel.abs) for @planets;

    return $sum;
}

my @lines = @AOC-INPUT-LINES;

my @planets;
for @lines -> $line {
    my $planet = Planet.new;

    $line.match(/ \-? <digit>+ /, :g);
    $planet.x-pos = $0.Int;
    $planet.y-pos = $1.Int;
    $planet.z-pos = $2.Int;
    $planet.x-vel = 0;
    $planet.y-vel = 0;
    $planet.z-vel = 0;

    @planets.push($planet);
}

run-step(@planets) for ^1000;

say "Total energy: {calc-total-energy(@planets)}";
