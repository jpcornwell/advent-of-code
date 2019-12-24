#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @program = $AOC-INPUT-WHOLE.split(',');

run-computer(@program);

sub run-computer(@program) {
    my $running = True;
    my $ip = 0;
    my @memory = @program;
    while $running {
        my ($opcode, @param-modes) = @memory[$ip].Int.polymod(100, 10);
        my @param-values;
        for @param-modes.kv -> $id, $mode {
            last unless @memory[$ip + $id + 1].DEFINITE; # Hack to avoid
                                                         # going past memory
                                                         # limit.
            given $mode {
                when 0 { @param-values[$id] = @memory[@memory[$ip + $id + 1]]}
                when 1 { @param-values[$id] = @memory[$ip + $id + 1]}
            }
        }
        given $opcode {
            when 1 { 
                @memory[@memory[$ip+3]] = @param-values[0] + @param-values[1];
                $ip += 4;
            }
            when 2 { 
                @memory[@memory[$ip+3]] = @param-values[0] * @param-values[1];
                $ip += 4;
            }
            when 3 { 
                @memory[@memory[$ip+1]] = prompt('Input> ');
                $ip += 2;
            }
            when 4 { 
                say @param-values[0];
                $ip += 2;
            }
            when 99 { $running = False; say "HALT" }
            default { die 'Unrecognized opcode' }
        }
    }
}
