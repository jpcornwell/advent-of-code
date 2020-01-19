#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

my @program = $AOC-INPUT-WHOLE.split(',');
my $computer = Computer.new;

$computer.reset;
$computer.load-program(@program);
$computer.add-inputs(2);
$computer.run;

say "Coordinates: $computer.remove-output()";
