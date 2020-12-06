#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @passports = $AOC-INPUT-WHOLE.trim.split("\n\n");

sub is-valid($passport) {
  my %fields = $passport.split(/ <[ \n \s ]> /)>>.split(':').flat;

  # Check required fields are present
  # ---------------------------------

  return False if %fields.keys ⊉ <byr iyr eyr hgt hcl ecl pid>;

  # Validate fields
  # ---------------

  given %fields<byr> {
    return False if !m/^ <digit> ** 4 $/;
    return False if !(1920 <= $_ <= 2002);
  }

  given %fields<iyr> {
    return False if !m/^ <digit> ** 4 $/;
    return False if !(2010 <= $_ <= 2020);
  }

  given %fields<eyr> {
    return False if !m/^ <digit> ** 4 $/;
    return False if !(2020 <= $_ <= 2030);
  }

  given %fields<hgt> {
    return False if !m/^ <digit>+ in | cm $/;
    my $unit = $_.substr(*-2);
    my $amount = $_.comb(/\d+/).first.Num;
    return False if ($unit eq 'in' && !(59 <= $amount <= 76));
    return False if ($unit eq 'cm' && !(150 <= $amount <= 193));
  }

  given %fields<hcl> {
    return False if !m/^ '#' <[a..f 0..9]> ** 6 $/;
  }

  given %fields<ecl> {
    return False if $_ ∉ <amb blu brn gry grn hzl oth>;
  }

  given %fields<pid> {
    return False if !m/^ <digit> ** 9 $/;
  }

  return True;
}

say @passports.grep(&is-valid).elems;

