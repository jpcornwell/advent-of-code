#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my $running = True;
my $pc = 0;
my @memory = $AOC-INPUT-WHOLE.split(',');

# Restore "1202 program alarm" state
@memory[1] = 12;
@memory[2] = 2;

while $running {
	my $opcode = @memory[$pc];
	my $a-index = @memory[$pc+1];
	my $b-index = @memory[$pc+2];
	my $target = @memory[$pc+3];
	given $opcode {
		when 1 { @memory[$target] = @memory[$a-index] + @memory[$b-index] }
		when 2 { @memory[$target] = @memory[$a-index] * @memory[$b-index] }
		when 99 { $running = False }
		default { die 'Unrecognized opcode' }
	}
	$pc += 4;
}

say @memory[0];
