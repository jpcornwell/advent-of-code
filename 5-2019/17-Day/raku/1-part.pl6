#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

enum Tile (Scaffold => '#', Unknown => '.');

class Node {
    has $.tile is rw = Unknown;
    has $.x is rw;
    has $.y is rw;

    method WHICH() {
        ObjAt.new(('Node', $!x, $!y).join('|'));
    }
}

class Grid {
    has %!contents;

    method get-point($x, $y) {
        if %!contents{$($x, $y)} !~~ Node {
            %!contents{$($x, $y)} = Node.new(:$x, :$y);
        }
        return %!contents{$($x, $y)};
    }

    method get-contents() {
        return %!contents.values;
    }

    method print {
        # Boundaries of image are hard coded
        for ^40 -> $y {
            for ^50 -> $x {
                print $.get-point($x, $y).tile;
            }
            print "\n";
        }
    }
}

my $grid = Grid.new;

sub print-ascii($in) {
    print(chr($in));
}

sub fill-grid($in) {
    state ($x, $y) = 0, 0;

    if $in == ord("\n") {
        $x = 0;
        $y++;
        return;
    }

    $grid.get-point($x, $y).tile = chr($in);
    $x++;
}

sub find-intersections {
    my @scaffolds = $grid.get-contents.grep(*.tile eq Scaffold);
    my @intersections;

    for @scaffolds -> $scaffold {
        my ($x, $y) = $scaffold.x, $scaffold.y;

        next if $grid.get-point($x, $y + 1).tile ne Scaffold;
        next if $grid.get-point($x, $y - 1).tile ne Scaffold;
        next if $grid.get-point($x + 1, $y).tile ne Scaffold;
        next if $grid.get-point($x - 1, $y).tile ne Scaffold;

        @intersections.push($scaffold);
    }

    return @intersections;
}

sub MAIN(Bool :p(:$print-scaffold)) {
    my @program = $AOC-INPUT-WHOLE.split(',');

    my $computer = Computer.new;
    $computer.load-program: @program;

    if $print-scaffold {
        $computer.output-hook = &print-ascii;
        $computer.run;
    } else {
        $computer.output-hook = &fill-grid;
        $computer.run;

        my @intersections = find-intersections;

        my $answer = 0;
        $answer += $_.x * $_.y for @intersections;
        say "Sum of alignment parameters is $answer";
    }
}
