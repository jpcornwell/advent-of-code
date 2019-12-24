#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @orbits = @AOC-INPUT-LINES;

my %this-orbits-that;

for @orbits -> $orbit {
    my ($center, $satellite) = $orbit.split(')');
    %this-orbits-that{$satellite} = $center;
}

# Take each satellite and count the number of hops it takes to get to COM
my $hop-count = 0;
for %this-orbits-that.values -> $start {
    $hop-count++;
    my $a = $start;
    while $a ne "COM" {
        $hop-count++;
        $a = %this-orbits-that{$a};
    }
}

say "Orbit count checksum: $hop-count";
