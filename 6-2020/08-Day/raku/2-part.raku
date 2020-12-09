#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @program = @AOC-INPUT-LINES;

my $acc;
my $ip;
my $visited;

sub reset-console {
  $acc = 0;
  $ip = 0;
  $visited = SetHash.new;
}

sub process-instruction {
  { say "Program exited. Acc: $acc."    ; exit } if $ip == @program.elems;
  { say 'Error! ip is out of bounds.'   ; last } if $ip > @program.elems;
  { say 'Error! Infinite loop detected.'; last } if $visited{$ip};

  $visited.set($ip);
  my ($opcode, $operand) := @program[$ip] ~~ / (\S+) ' ' (\S+) /;

  given $opcode {
    when 'acc' { $acc += $operand.Num }
    when 'jmp' { $ip += $operand.Num - 1 }
    when 'nop' { }
  }
  $ip++;
}

for ^@program.elems -> $i {
  my $op = @program[$i];

  @program[$i] = $op.subst('jmp', 'nop') if $op.contains('jmp');
  @program[$i] = $op.subst('nop', 'jmp') if $op.contains('nop');

  reset-console;
  process-instruction for ^Inf;

  @program[$i] = $op;
}

