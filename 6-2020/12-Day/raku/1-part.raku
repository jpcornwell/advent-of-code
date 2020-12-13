#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @program = @AOC-INPUT-LINES;

my @directions = <north east south west>;
my ($x, $y) = 0, 0;
my $direction = 'east';

for @program -> $instr {
  my $command = $instr.comb[0];
  my $amount = $instr.comb[1..*].join.Int;

  given $command {
    when 'N' { $y += $amount }
    when 'E' { $x += $amount }
    when 'S' { $y -= $amount }
    when 'W' { $x -= $amount }
    when 'L' { $direction = @directions[(@directions.first($direction, :k) - ($amount / 90)) % 4] }
    when 'R' { $direction = @directions[(@directions.first($direction, :k) + ($amount / 90)) % 4] }
    when 'F' { 
      given $direction {
        when 'north' { $y += $amount } 
        when 'east'  { $x += $amount } 
        when 'south' { $y -= $amount } 
        when 'west'  { $x -= $amount } 
      }
    }
  }
}

say $x.abs + $y.abs;

