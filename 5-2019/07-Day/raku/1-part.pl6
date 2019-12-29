#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

my @program = $AOC-INPUT-WHOLE.split(',');
my $computer = Computer.new;

my $hi-signal = 0;

my @phase-settings = <0 1 2 3 4>;
for @phase-settings.permutations -> @permutation {
    my $in = 0;
    for @permutation -> $phase {
        $computer.reset;
        $computer.pre-load-inputs($phase, $in);
        $computer.run(@program);
        $in = $computer.fetch-output[0];
    }
    $hi-signal max= $in;
}

say "High signal is $hi-signal";
