unit module AOC;

our $AOC-INPUT-WHOLE is export = slurp '../input.txt';

our @AOC-INPUT-LINES is export = $AOC-INPUT-WHOLE.lines>>.&val;
