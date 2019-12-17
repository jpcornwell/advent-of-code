#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

# TODO
# Wire-Layer class that holds logic for parsing commands and tracing wires on a given 2d-Grid
# Function to calculate distance between point and origin

class Node {
    has $.has-wire-a is rw = False;
    has $.has-wire-b is rw = False;
}

class Grid {
    has Int $!min-x                        = -100;
    has Int $!max-x                        =  100;
    has Int $!min-y                        = -100;
    has Int $!max-y                        =  100;
    has     @!contents[201;201] of Node;

    # Hack to get around the fact that default values for compound attribute
    # types aren't supported yet.
    method TWEAK {
        # Surely there is a better way to initialize this array.
        @!contents = [Node.new xx 201] xx 201;
    }

    # Would like to eventually replace this with $grid[$x;$y] functionality,
    # which can be done by adding elems, AT-POS, and EXISTS-POS methods. See
    # the documentation for Subscripts - Custom Types.
    method get-point($x, $y) {
        return @!contents[$x + 100; $y + 100];
    }

    # Grid should be generic and not have this method which is tied to the
    # underlying element type as well as the specific requirements for this
    # script, but it's not a big deal.
    method get-collision-coordinates() {
        return @!contents.kv.grep(
                -> $k, $v { $v.has-wire-a == True && $v.has-wire-b == True }
            ).map( { my ($index, $node) = $_; $index.map( * - 100) } );
    }
}

subset Wire-Layer-Command of Str where /^ [U|D|L|R] <digit>+ $/;

class Wire-Layer {
    has Grid $!grid;
    has  Int $!x-pos;
    has  Int $!y-pos;
    has  Str $!wire;

    method start-wire($wire) {
        $!x-pos = 0;
        $!y-pos = 0;
        $!wire  = $wire;
    }

    method exec-command($command) {
    }
}

my $grid = Grid.new;

$grid.get-point(33,33).has-wire-a = True;
$grid.get-point(33,33).has-wire-b = True;
say $grid.get-collision-coordinates;

my $wire-layer = Wire-Layer.new: :$grid;

