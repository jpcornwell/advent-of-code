#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my %rules;
for @AOC-INPUT-LINES -> $line {
  my ($origin, @products) := $line ~~ / ( \w+ \s \w+) ' bags contain ' [ [\d+ \s]? (\w+ \s \w+) \s \w+ ]+ % ', ' /;
  %rules{$origin} = @products;
}

my $visited = 'shiny gold'.SetHash;

my ($old-count, $new-count) = 0, 1;
until ($old-count == $new-count) {
  my @foo = $visited.keys;
  for @foo -> $item {
    $visited.set(%rules.invert.grep( *.key eq $item )>>.value);
  }
  ($old-count, $new-count) = $new-count, $visited.elems;
}

# Subtract one because 'shiny gold' shouldn't be counted
say $new-count - 1;

