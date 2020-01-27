#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

class Planet {
    has ($.x-pos, $.y-pos, $.z-pos,
         $.x-vel, $.y-vel, $.z-vel) is rw;
}

sub get-x-state(@planets) {
    my @state;
    @state.append($_.x-pos, $_.x-vel) for @planets;
    return @state;
}

sub get-y-state(@planets) {
    my @state;
    @state.append($_.y-pos, $_.y-vel) for @planets;
    return @state;
}

sub get-z-state(@planets) {
    my @state;
    @state.append($_.z-pos, $_.z-vel) for @planets;
    return @state;
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

# All the offsets in the following get-period functions happen to be zero
# for the input that was provided to us, so we can ignore them

sub get-x-period(@input) {
    my @planets = @input;
    my %visited;
    %visited{$(get-x-state(@planets))} = 0;

    my $count = 0;
    loop {
        $count++;
        run-step(@planets);
        if defined %visited{$(get-x-state(@planets))} {
            my $offset = %visited{$(get-x-state(@planets))};
            my $period = $count - $offset;
            return $period;
        }
        %visited{$(get-x-state(@planets))} = $count - 1;;
    }
}

sub get-y-period(@input) {
    my @planets = @input;
    my %visited;
    %visited{$(get-y-state(@planets))} = 0;

    my $count = 0;
    loop {
        $count++;
        run-step(@planets);
        if defined %visited{$(get-y-state(@planets))} {
            my $offset = %visited{$(get-y-state(@planets))};
            my $period = $count - $offset;
            return $period;
        }
        %visited{$(get-y-state(@planets))} = $count - 1;
    }
}

sub get-z-period(@input) {
    my @planets = @input;
    my %visited;
    %visited{$(get-z-state(@planets))} = 0;

    my $count = 0;
    loop {
        $count++;
        run-step(@planets);
        if defined %visited{$(get-z-state(@planets))} {
            my $offset = %visited{$(get-z-state(@planets))};
            my $period = $count - $offset;
            return $period;
        }
        %visited{$(get-z-state(@planets))} = $count - 1;
    }
}

my @lines = @AOC-INPUT-LINES;

# Initialize @planets
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

my $x-period = get-x-period(@planets);
say "x period: $x-period";
my $y-period = get-y-period(@planets);
say "y period: $y-period";
my $z-period = get-z-period(@planets);
say "z period: $z-period";

say "Number of steps: {$x-period lcm $y-period lcm $z-period}";

