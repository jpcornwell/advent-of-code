#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my %rules;
for @AOC-INPUT-LINES -> $line {
  my ($origin, @products) := $line ~~ / ( \w+ \s \w+) ' bags contain ' [ ([\d+ \s]? \w+ \s \w+) \s \w+ ]+ % ', ' /;
  %rules{$origin} = @products;
}

sub find-count($item) {
  my $sum = 0;
  for %rules{$item}.List -> $foo {
    if $foo.contains(/\d/) {
      my $amount = $foo.comb(/\d+/).first.Num;
      my $description = $foo.comb(/<alpha>+/).join(' ');
      $sum += $amount;
      $sum += $amount * find-count($description);
    }
  }
  return $sum;
}

say find-count('shiny gold');

