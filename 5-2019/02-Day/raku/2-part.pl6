#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @program = $AOC-INPUT-WHOLE.split(',');
my @memory = @program;

my $noun = 0;
my $verb = -1;

for flat(^100 X ^100) -> $noun, $verb {
	@memory = @program;
	@memory[1] = $noun;
	@memory[2] = $verb;
	run-computer;
	if @memory[0] == 19690720 {
		say 100 * $noun + $verb;
		exit;
	}
}

sub run-computer() {
	my $running = True;
	my $ip = 0;
	while $running {
		my $opcode = @memory[$ip];
		my $a-address = @memory[$ip+1];
		my $b-address = @memory[$ip+2];
		my $target = @memory[$ip+3];
		given $opcode {
			when 1 { @memory[$target] = @memory[$a-address] + @memory[$b-address] }
			when 2 { @memory[$target] = @memory[$a-address] * @memory[$b-address] }
			when 99 { $running = False }
			default { die 'Unrecognized opcode' }
		}
		$ip += 4;
	}
}
