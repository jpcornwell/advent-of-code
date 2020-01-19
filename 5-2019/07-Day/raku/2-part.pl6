#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer-v2;

my @program = $AOC-INPUT-WHOLE.split(',');
my @computers = Computer.new xx 5;

my $hi-signal = 0;

my @phase-settings = 5..9;
for @phase-settings.permutations -> @permutation {
    my $halted = False;
    my $in = 0;

    # Reset computers
    .reset for @computers;
    .load-program(@program) for @computers;

    # Preload the phase inputs
    for @computers Z @permutation -> ($comp, $phase) { $comp.add-inputs($phase) }
    .run for @computers;

    while not $halted {
        for @computers -> $comp {
            $comp.add-inputs($in);
            $comp.run;
            $in = $comp.remove-output;
        }
        # Check the last computer to see if we're done
        $halted = @computers[4].is-halted;
        $hi-signal max= $in if $halted;
    }
}

say "High signal is $hi-signal";
