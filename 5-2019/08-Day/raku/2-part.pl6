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

my @display;

for ^$layer-size -> $pixel-id {
    for @layers -> @layer {
        if @layer[$pixel-id] == any(0, 1) {
            @display[$pixel-id] = @layer[$pixel-id];
            last;
        }
    }
}

print @display.map({ +$_ ?? '*' !! ' ' })
              .rotor($width)
              .join("\n");
