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
  my $has-changed = process-grid;
  if !$has-changed {
    last;
  }
}

say @grid.values.grep(* eq '#').elems;

sub get-adjacent($x, $y) {
  my @adjacent;
  @adjacent.push: @grid[$x-1;$y-1] if $y - 1 >= 0 && $x - 1 >= 0;
  @adjacent.push: @grid[$x;$y-1] if $y - 1 >= 0;
  @adjacent.push: @grid[$x+1;$y-1] if $y - 1 >= 0 && $x + 1 < $width;
  @adjacent.push: @grid[$x-1;$y] if $x - 1 >= 0;
  @adjacent.push: @grid[$x+1;$y] if $x + 1 < $width;
  @adjacent.push: @grid[$x-1;$y+1] if $y + 1 < $height && $x - 1 >= 0;
  @adjacent.push: @grid[$x;$y+1] if $y + 1 < $height;
  @adjacent.push: @grid[$x+1;$y+1] if $y + 1 < $height && $x + 1 < $width;

  return @adjacent;
}

sub process-grid {
  my @new-grid[$width ; $height];
  my $has-changed = False;
  for ^$width X ^$height -> ($x, $y) {
    @new-grid[$x;$y] = @grid[$x;$y];
    if @grid[$x;$y] eq 'L' && get-adjacent($x, $y).comb('#').elems == 0 {
      @new-grid[$x;$y] = '#';
      $has-changed = True;
    } elsif @grid[$x;$y] eq '#' && get-adjacent($x, $y).comb('#').elems >= 4 {
      @new-grid[$x;$y] = 'L';
      $has-changed = True;
    }
  }
  @grid = @new-grid;
  return $has-changed;
}

