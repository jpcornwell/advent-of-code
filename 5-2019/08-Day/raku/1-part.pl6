#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @image-contents = $AOC-INPUT-WHOLE.trim.comb;

my $width = 25;
my $height = 6;

my $layer-size = $width * $height;
my $layer-count = @image-contents.elems / $layer-size;

my @layers = @image-contents.rotor($layer-size);
my @bags = @layers.map: { bag(@$_) };

# Bag with the least number of zeros
# Using <0> results in weird behavior, I don't know why
my $bag = @bags.min: *{"0"};

say "Product: {$bag{"1"} * $bag{"2"}}";
