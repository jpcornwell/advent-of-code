#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my $row-count = 128;
my $col-count = 8;
my @passes = @AOC-INPUT-LINES;

sub get-coords($pass) {
  my ($min, $max, $delta);
  my $i = 0;

  $min = 0;
  $max = $row-count - 1;
  for $row-count / 2, * / 2 ... 1 -> $delta {
    $min += $delta if $pass.comb[$i] eq 'B';
    $max -= $delta if $pass.comb[$i] eq 'F';
    $i++;
  }
  my $row = $min;

  $min = 0;
  $max = $col-count - 1;
  for $col-count / 2, * / 2 ... 1 -> $delta {
    $min += $delta if $pass.comb[$i] eq 'R';
    $max -= $delta if $pass.comb[$i] eq 'L';
    $i++;
  }
  my $col = $min;

  return $row, $col;
}

sub get-id(@coords) { @coords[0] * 8 + @coords[1] }

my @seat-ids = @passes.map(&get-coords).map(&get-id);

say (@seat-ids.min .. @seat-ids.max) (-) @seat-ids;

