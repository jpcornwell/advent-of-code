#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @passports = $AOC-INPUT-WHOLE.trim.split("\n\n");

my $valid-count = 0;
for @passports -> $passport {
  my %fields = $passport.split(/ <[ \n \s ]> /)>>.split(':').flat;

  $valid-count++ if %fields.keys ⊇ <byr iyr eyr hgt hcl ecl pid>;
}

say $valid-count;

