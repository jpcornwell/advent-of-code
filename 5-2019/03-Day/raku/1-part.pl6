#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

class Node {
    has $.has-wire-a is rw = False;
    has $.has-wire-b is rw = False;
}

class Grid {
    has     %!contents;

    # Would like to eventually replace this with $grid[$x;$y] functionality,
    # which can be done by adding elems, AT-POS, and EXISTS-POS methods. See
    # the documentation for Subscripts - Custom Types.
    method get-point($x, $y) {
        if %!contents{$($x,$y)} !~~ Node {
            %!contents{$($x,$y)} = Node.new;
        }
        return %!contents{$($x,$y)};
    }

    # Grid should be generic and not have this method which is tied to the
    # underlying element type as well as the specific requirements for this
    # script, but it's not a big deal.
    method get-collision-coordinates() {
        return %!contents.kv.grep(
              -> $k, $v { $v.has-wire-a == True && $v.has-wire-b == True }
            ).map( { my ($index, $node) = $_; $index.words } );
    }
}

subset Wire-Layer-Command of Str where /^ [U|D|L|R] <digit>+ $/;

class Wire-Layer {
    has Grid $.grid;
    has  Int $!x-pos;
    has  Int $!y-pos;
    has  Str $!wire;

    method start-wire($wire) {
        $!x-pos = 0;
        $!y-pos = 0;
        $!wire  = $wire;
    }

    method exec-command($command) {
        my $direction = $command.substr: 0, 1;
        my $magnitude = $command.substr: 1, *;

        for ^$magnitude {
            given $direction {
                when 'L' { $!x-pos-- }
                when 'R' { $!x-pos++ }
                when 'U' { $!y-pos++ }
                when 'D' { $!y-pos--}
            }

            given $!wire {
                when 'a' { $!grid.get-point($!x-pos, $!y-pos).has-wire-a = True }
                when 'b' { $!grid.get-point($!x-pos, $!y-pos).has-wire-b = True }
            }
        }
    }
}

sub calc-distance($x, $y) { $x.abs + $y.abs }

my @wire-a-path = @AOC-INPUT-LINES[0].split(',');
my @wire-b-path = @AOC-INPUT-LINES[1].split(',');

my $grid = Grid.new;
my $wire-layer = Wire-Layer.new: :$grid;

say "Laying wire a";
$wire-layer.start-wire('a');
$wire-layer.exec-command($_) for @wire-a-path;

say "Laying wire b";
$wire-layer.start-wire('b');
$wire-layer.exec-command($_) for @wire-b-path;

my $ans = $grid.get-collision-coordinates
               .map( { calc-distance(|$_) } )
               .min;

say "Distance to closest intersection: $ans";
