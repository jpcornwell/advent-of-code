#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

say @AOC-INPUT-LINES
        .combinations(2)
        .grep( *.sum == 2020 )
        .map({ [*] |$_ });

