#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

sub generate-pattern($n) {
    return flat(0 xx $n, 1 xx $n, 0 xx $n, -1 xx $n);
}

sub transform(@signal) {
    my @new-signal;

    for 1 .. @signal.elems -> $n {
        my @pattern = generate-pattern($n);

        # Repeat pattern so it is long enough to apply to signal
        @pattern.append(@pattern) while @pattern.elems < @signal.elems + $n;
        
        # Shift pattern
        @pattern = @pattern[1..*];

        # Apply the pattern
        @new-signal.push(sum(@pattern Z* @signal).abs % 10);
    }

    return @new-signal;
}

sub MAIN {
    my @signal = $AOC-INPUT-WHOLE.trim.comb;

    @signal = transform(@signal) for ^100;
    say @signal[0..^8].join;
}

