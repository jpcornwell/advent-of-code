#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @program = @AOC-INPUT-LINES;

my ($x, $y) = 0, 0;
my ($w-x, $w-y) = 10, 1;

for @program -> $instr {
  my $command = $instr.comb[0];
  my $amount = $instr.comb[1..*].join.Int;

  given $command {
    when 'N' { $w-y += $amount }
    when 'E' { $w-x += $amount }
    when 'S' { $w-y -= $amount }
    when 'W' { $w-x -= $amount }
    when 'L' { ($w-x, $w-y) = $w-y * -1, $w-x for ^($amount / 90) }
    when 'R' { ($w-x, $w-y) = $w-y, $w-x * -1 for ^($amount / 90) }
    when 'F' {
      $x += $w-x * $amount;
      $y += $w-y * $amount;
    }
  }
}

say $x.abs + $y.abs;

