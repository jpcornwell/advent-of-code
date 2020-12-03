#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @rows = @AOC-INPUT-LINES;
my $index = 0;
my $tree-count = 0;
for @rows -> $row {
  $tree-count++ if $row.comb[$index] eq '#';
  $index = ($index + 3) % $row.chars;
}

say $tree-count;

