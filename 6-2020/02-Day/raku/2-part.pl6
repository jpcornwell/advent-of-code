#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

sub is-valid($db-entry) {
  my ($x, $y, $char, $pass) := $db-entry ~~ /(\d+) '-' (\d+) \s (\w) ':' \s (\w+)/;
  return $pass.comb[$x - 1] ^ $pass.comb[$y - 1] eq $char;
}

say @AOC-INPUT-LINES
        .grep(&is-valid)
        .elems;

