#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @sequence = @AOC-INPUT-LINES>>.Int.sort;

# Add charging outlet 
@sequence.unshift: 0;
# Add device's built-in adapter
@sequence.push: @sequence[*-1] + 3;

my @diffs;
for 1 ..^ @sequence -> $i {
  @diffs.push: @sequence[$i] - @sequence[$i - 1];
}

my $possible-combinations = 1;
my $one-count = 0;
for @diffs -> $diff {
  if $diff != 1 {
    my $foo = $one-count - 1;
    $possible-combinations *= 2 ** $foo - ((0..($foo - 2)).sum) if $one-count > 0;
    $one-count = 0;
    next;
  }
  $one-count++;
}

say $possible-combinations;

