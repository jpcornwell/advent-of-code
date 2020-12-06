#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @groups = $AOC-INPUT-WHOLE.split("\n\n");

say [+] @groups>>.trans("\n" => '')>>.comb>>.Bag>>.elems;

