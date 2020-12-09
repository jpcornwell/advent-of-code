#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @sequence = @AOC-INPUT-LINES;

my $pre-length = 25;

sub is-valid-index($i) {
  return True if any(@sequence[$i - $pre-length .. $i - 1].combinations(2)>>.sum) == @sequence[$i];
  return False;
}

for $pre-length ..^ @sequence.elems -> $i {
  if !is-valid-index($i) {
    say @sequence[$i];
    last;
  }
}
