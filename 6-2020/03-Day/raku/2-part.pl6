#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @rows = @AOC-INPUT-LINES;
my $width = @rows[0].chars;
my $height = @rows.elems;

sub slope($right, $down) {
  my ($x, $y, $tree-count) = 0, 0, 0;

  while $y < $height {
    $tree-count++ if @rows[$y].comb[$x] eq '#';
    $x = ($x + $right) % $width;
    $y += $down;
  }

  return $tree-count;
}

say [*] slope(1, 1), slope(3, 1), slope(5, 1), slope(7, 1), slope(1, 2);
