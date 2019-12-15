#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @program = $AOC-INPUT-WHOLE.split(',');

#`[ Could be done like this
for flat(^100 X ^100) -> $noun, $verb {
    my @memory = @program;
    @memory[1] = $noun;
    @memory[2] = $verb;
    run-computer;
    if @memory[0] == 19690720 {
        say 100 * $noun + $verb;
        exit;
    }
}
#]

# But I prefer this
my $noun;
my $verb;
my @possible-inputs = ^100 X ^100;
my @memory;
repeat until @memory[0] == 19690720 {
    ($noun, $verb) = @possible-inputs.shift;
    @memory = @program;
    @memory[1] = $noun;
    @memory[2] = $verb;
    run-computer;
}

say "Answer: { $noun * 100 + $verb }";

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
