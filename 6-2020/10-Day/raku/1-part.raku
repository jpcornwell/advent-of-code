#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @sequence = @AOC-INPUT-LINES>>.Int.sort;

@sequence.unshift: 0;
@sequence.push: @sequence[*-1] + 3;

my $bag = BagHash.new;

for 1 ..^ @sequence -> $i {
  $bag.add: @sequence[$i] - @sequence[$i - 1];
}

say $bag{1} * $bag{3};

