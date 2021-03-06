#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

sub is-valid-password($pass) {
    # Check for adjacent repeat of exactly two
    return False if $pass.comb(/(.)$0*/).grep(*.chars == 2).elems == 0;

    # Check digits are ascending
    for 1..^6 {
        return False if $pass.comb[$^i] < $pass.comb[$^i - 1];
    }
    
    return True;
}

my ($min, $max) = $AOC-INPUT-WHOLE.split('-');

my $count = 0;

$count++ if is-valid-password($_) for $min..$max;

say "Number of possible passwords: $count";
