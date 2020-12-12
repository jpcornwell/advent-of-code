#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @sequence = @AOC-INPUT-LINES>>.Int.sort;

# Add charging outlet and device's built-in adapter
@sequence = 0, |@sequence, @sequence.max + 3;

my @diffs = @sequence.rotor(2 => -1).map({ [R-] @_ });

my $possible-combinations = 1;
my $one-count = 0;
for @diffs -> $diff {
  if $diff == 1 {
    $one-count++;
  } else {
    my $a = $one-count - 1;
    $possible-combinations *= 2 ** $a - (0..($a - 2)).sum if $a > 0;
    $one-count = 0;
  }
}

say $possible-combinations;

