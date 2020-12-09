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

my $invalid-number = @sequence[$_] if !is-valid-index($_) for $pre-length ..^ @sequence.elems;

for ^@sequence -> $i {
  my $sum = 0;
  my @nums;
  my $j = 0;

  until $sum >= $invalid-number {
    @nums.push: @sequence[$i + $j];
    $sum = @nums.sum;
    $j++;
  }

  if $sum == $invalid-number { say @nums.sort[0, *-1].sum andthen exit }
}

