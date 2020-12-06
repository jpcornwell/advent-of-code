#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

my @groups = $AOC-INPUT-WHOLE.split("\n\n");

my @intersections = @groups.map: { [(&)] $_.split("\n")>>.comb };
say [+] @intersections>>.elems;

