#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

sub is-valid($db-entry) {
  my ($min, $max, $char, $pass) := $db-entry ~~ /(\d+) '-' (\d+) \s (\w) ':' \s (\w+)/;
  return $min <= $pass.comb($char).elems <= $max;
}

say @AOC-INPUT-LINES
        .grep(&is-valid)
        .elems;

