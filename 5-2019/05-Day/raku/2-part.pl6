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
        # This is only used for reading parameters.
        # If you want to write to a parameter, do it manually via memory
        # manipulation.
        my @param-values;
        for @param-modes.kv -> $id, $mode {
            last unless @memory[$ip + $id + 1].DEFINITE; # Hack to avoid
                                                         # going past memory
                                                         # limit.
            given $mode {
                # Positional
                when 0 { @param-values[$id] = @memory[@memory[$ip + $id + 1]]}
                # Immediate
                when 1 { @param-values[$id] = @memory[$ip + $id + 1]}
            }
        }
        given $opcode {
            # Addition
            when 1 { 
                @memory[@memory[$ip+3]] = @param-values[0] + @param-values[1];
                $ip += 4;
            }
            # Multiplication
            when 2 { 
                @memory[@memory[$ip+3]] = @param-values[0] * @param-values[1];
                $ip += 4;
            }
            # Input
            when 3 { 
                @memory[@memory[$ip+1]] = prompt('Input> ');
                $ip += 2;
            }
            # Output
            when 4 { 
                say @param-values[0];
                $ip += 2;
            }
            # Jump if true
            when 5 {
                if @param-values[0] != 0 {
                    $ip = @param-values[1];
                } else {
                    $ip += 3;
                }
            }
            # Jump if false
            when 6 {
                if @param-values[0] == 0 {
                    $ip = @param-values[1];
                } else {
                    $ip += 3;
                }
            }
            # Less than
            when 7 {
                if @param-values[0] < @param-values[1] {
                    @memory[@memory[$ip+3]] = 1;
                } else {
                    @memory[@memory[$ip+3]] = 0;
                }
                $ip += 4;
            }
            # Equals
            when 8 {
                if @param-values[0] == @param-values[1] {
                    @memory[@memory[$ip+3]] = 1;
                } else {
                    @memory[@memory[$ip+3]] = 0;
                }
                $ip += 4;
            }
            # Halt
            when 99 { $running = False; say "HALT" }
            default { die 'Unrecognized opcode' }
        }
    }
}
