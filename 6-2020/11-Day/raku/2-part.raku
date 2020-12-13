#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @rows = @AOC-INPUT-LINES;
my $height = @rows.elems;
my $width = @rows[0].chars;

# Load grid
my @grid[$width ; $height];
for ^$width X ^$height -> ($x, $y) {
  @grid[$x ; $y] = @rows[$y].comb[$x];
}

loop {
  last if process-grid;
}

say @grid.values.grep(* eq '#').elems;

sub get-adjacent($x, $y) {
  my @adjacent;
  for -1, -1, 0, -1, 1, -1, -1, 0, 1, 0, -1, 1, 0, 1, 1, 1 -> $x-diff, $y-diff {
    my ($i, $j) = $x, $y;
    loop {
      $i += $x-diff;
      $j += $y-diff;
      if $i < 0 || $i >= $width || $j < 0 || $j >= $height {
        last;
      }
      if @grid[$i;$j] eq any('#', 'L') {
        @adjacent.push: @grid[$i;$j];
        last;
      }
    }
  }
  return @adjacent;
}
  
sub process-grid {
  my @new-grid[$width ; $height];
  my $is-stable = True;
  for ^$width X ^$height -> ($x, $y) {
    @new-grid[$x;$y] = @grid[$x;$y];
    if @grid[$x;$y] eq 'L' && get-adjacent($x, $y).comb('#').elems == 0 {
      @new-grid[$x;$y] = '#';
      $is-stable = False;
    } elsif @grid[$x;$y] eq '#' && get-adjacent($x, $y).comb('#').elems >= 5 {
      @new-grid[$x;$y] = 'L';
      $is-stable = False;
    }
  }
  @grid = @new-grid;
  return $is-stable;
}

