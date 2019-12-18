#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

class Node {
    has $.has-wire-a is rw = False;
    has $.has-wire-b is rw = False;
    has $.wire-a-length is rw = 0;
    has $.wire-b-length is rw = 0;
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
    method get-collision-points() {
        return %!contents.kv.grep(
              -> $k, $v { $v.has-wire-a == True && $v.has-wire-b == True }
            ).map( { my ($index, $node) = $_; ($index.words, $node) } );
    }
}

subset Wire-Layer-Command of Str where /^ [U|D|L|R] <digit>+ $/;

class Wire-Layer {
    has Grid $.grid;
    has  Int $!x-pos;
    has  Int $!y-pos;
    has  Int $!length;
    has  Str $!wire;

    method start-wire($wire) {
        $!x-pos = 0;
        $!y-pos = 0;
        $!length = 0;
        $!wire  = $wire;
    }

    method exec-command($command) {
        my $direction = $command.substr: 0, 1;
        my $magnitude = $command.substr: 1, *;

        for ^$magnitude {
            $!length++;

            given $direction {
                when 'L' { $!x-pos-- }
                when 'R' { $!x-pos++ }
                when 'U' { $!y-pos++ }
                when 'D' { $!y-pos--}
            }

            given $!wire {
                my $node = $!grid.get-point($!x-pos, $!y-pos);
                when 'a' { $node.has-wire-a = True;
                           $node.wire-a-length = $!length unless $node.wire-a-length > 0;
                         }
                when 'b' { $node.has-wire-b = True;
                           $node.wire-b-length = $!length unless $node.wire-b-length > 0;
                         }
            }
        }
    }
}

sub calc-total-length($node) { $node.wire-a-length + $node.wire-b-length }

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

my $ans = $grid.get-collision-points
               .map( { my ($coordinates, $node) = $_;
                       calc-total-length($node) } )
               .min;

say "Shortest length to intersection: $ans";
