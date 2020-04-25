#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

# The signal returned from this transform will only be valid in the 2nd half.
# Anything in the 1st half is garbage.
sub transform-end-half(@signal, $count) {
    my @foo = @signal.reverse;

    for ^$count {
        say $_;
        @foo = [\+] @foo;
        @foo = @foo.map: * % 10;
    }
    
    return @foo.reverse;
}

sub MAIN {
    my @init-signal = $AOC-INPUT-WHOLE.trim.comb;

    my $offset = @init-signal[^7].join.Int;
    my @real-signal = flat(@init-signal xx 10_000);

    my $answer = transform-end-half(@real-signal[$offset .. *], 100)[^8].join;

    say "Answer is $answer";
}

