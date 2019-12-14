#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

say [+] @AOC-INPUT-LINES.map: * div 3 - 2;

