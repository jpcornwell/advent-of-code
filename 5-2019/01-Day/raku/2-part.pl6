#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my $total-fuel = 0;

for @AOC-INPUT-LINES -> $module-weight {
	my $additional-weight = $module-weight;
	repeat {
		my $fuel = $additional-weight div 3 - 2;
		$total-fuel += $fuel if $fuel > 0;
		$additional-weight = $fuel;
	} while $additional-weight > 0;
}

say $total-fuel;
