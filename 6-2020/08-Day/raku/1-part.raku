#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @program = @AOC-INPUT-LINES;

my $acc = 0;
my $ip = 0;

sub process-instruction {
  state $visited = SetHash.new;

  if $visited{$ip} {
    say $acc;
    exit;
  }

  $visited.set($ip);
  my ($opcode, $operand) := @program[$ip] ~~ / (\S+) ' ' (\S+) /;
  $ip++;

  given $opcode {
    when 'acc' { $acc += $operand.Num }
    when 'jmp' { $ip += $operand.Num - 1 }
    when 'nop' { }
  }
}

process-instruction for ^Inf;

