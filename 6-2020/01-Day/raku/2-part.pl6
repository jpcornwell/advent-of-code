#!/usr/bin/env raku
use v6;

use lib '../../common';
use AOC;

say @AOC-INPUT-LINES
        .combinations(3)
        .grep( *.sum == 2020 )
        .map({ [*] |$_ });

