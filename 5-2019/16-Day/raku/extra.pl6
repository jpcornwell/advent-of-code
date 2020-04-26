#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

# Get first 8 values of signal after n transformations.
#
# This takes advantage of a pattern found in the 2nd half of the signal. This
# will be inaccurate for anything in the 1st half.
#
# Playing around with this, I was able to find a formula for determining the
# nth transformation of a given signal. In theory, this would then mean that
# computation time would be contant in regard to the number of transformations.
# In practice though, the multiplier becomes so large that it starts to slow
# down with a large number of transformations. There is probably a way around
# this considering that the only piece of interest is the one's digit of the
# result. If the multiplier can be kept small while still yielding the same
# one's digit, this would be a good approach. I'm moving on to the next problem
# though.
#
# The formula is as follows.
#
# Given a signal (d, c, b, a). To compute a after N transformations you use
# a
# To compute b after N transformations you use
# b + aN
# To compute c after N transformations you use
# c + bN + a(N(N+1)/2)
# To compute d after N transformations you use
# d + cN + b(N(N+1)/2) + a(N(N+1)(N+2)/6)
#
# If we change the notation for the signal to (S0, S1, S2, ...) then to compute
# S0 after N transformations we can use
# S0 + S1N + S2(N(N+1)/2) + ...
# Which leads to
# Sum of: Si((N+0)(N+1)(N+2)...(N+i) / i!)
#
# It would be similar for S1 but you would shift the entire sequence as if S1
# were actually S0 and do the same thing.
#
# This is difficult to try to notate using ASCII
sub get-answer(@signal, $n) {
    my @answer;

    for ^8 -> $i {
        my $multiplier = 1;
        my $total = 0;

        my $j = 0;
        for @signal[$i..*] -> $val {
            $total += $multiplier * $val;

            $multiplier *= $n + $j;
            $j++;
            $multiplier /= $j;

            $total %= 10;
        }
        @answer.push($total);
    }

    return @answer.join;
}

sub MAIN {
    my @init-signal = $AOC-INPUT-WHOLE.trim.comb;

    # Smaller input to test with
    @init-signal = '03036732577212944063491565474664'.comb;

    my $offset = @init-signal[^7].join.Int;
    my @real-signal = flat(@init-signal xx 10_000);

    my $answer = get-answer(@real-signal[$offset .. *], 100);

    say "Answer is $answer";
}

