#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

# TODO
# Add enums for directions and tile types
# Move most of the logic out of Map and into Strategy modules
# See if there is an easy way to accept input without needing to press enter

class Node {
    has $.tile is rw = ' ';
}

class Grid {
    has %.contents;

    method get-point($x, $y) {
        if %!contents{$($x, $y)} !~~ Node {
            %!contents{$($x, $y)} = Node.new;
        }
        return %!contents{$($x, $y)};
    }
}

class Map {
    has $.grid = Grid.new;
    has $!droid-x = 0;
    has $!droid-y = 0;
    has $!top-boundary = 1;
    has $!left-boundary = -1;
    has $!right-boundary = 1;
    has $!bottom-boundary = -1;
    has $.last-input is rw = '';

    method handle-output($out) {
        if ($out == 0) {
            given $!last-input {
                when 'n' { $!grid.get-point($!droid-x, $!droid-y + 1).tile = '#'; }
                when 's' { $!grid.get-point($!droid-x, $!droid-y - 1).tile = '#'; }
                when 'w' { $!grid.get-point($!droid-x - 1, $!droid-y).tile = '#'; }
                when 'e' { $!grid.get-point($!droid-x + 1, $!droid-y).tile = '#'; }
            }
        }

        if ($out == 1) {
            given $!last-input {
                when 'n' { $!droid-y++; }
                when 's' { $!droid-y--; }
                when 'w' { $!droid-x--; }
                when 'e' { $!droid-x++; }
            }
        }

        # Update any boundaries
        $!top-boundary++ if $!droid-y > ($!top-boundary - 1);
        $!bottom-boundary-- if $!droid-y < ($!bottom-boundary + 1);
        $!left-boundary-- if $!droid-x < ($!left-boundary + 1);
        $!right-boundary++ if $!droid-x > ($!right-boundary - 1);
    }

    method print {
        my $width = ($!left-boundary ... $!right-boundary).elems;
        say '-' x $width + 4;
        for $!top-boundary ... $!bottom-boundary -> $y {
        print '| ';
            for $!left-boundary ... $!right-boundary -> $x {
                if ($x == $!droid-x && $y == $!droid-y) {
                    print 'D';
                } else {
                    print $!grid.get-point($x, $y).tile;
                }
            }
            say ' |';
        }
        say '-' x $width + 4;
    }
}

my $map = Map.new;

module ManualNavigation {
    our sub handle-input {
        my $input = '';
        while ($input ne 'n' &&
                $input ne 'w' &&
                $input ne 'e' &&
                $input ne 's') {
            $input = prompt('Direction: ');
            exit if $input eq 'exit';
        }
        $map.last-input = $input;
        given $input {
            when 'n' { return 1; }
            when 's' { return 2; }
            when 'w' { return 3; }
            when 'e' { return 4; }
        }
    }

    our sub handle-output($out) {
        $map.handle-output($out);
        $map.print;
    }
}

sub MAIN(Bool :i(:$interactive)) {
    my @program = $AOC-INPUT-WHOLE.split(',');

    my $computer = Computer.new;
    $computer.load-program: @program;

    if ($interactive) {
        say "Type 'exit' to quit program.";
        $computer.input-hook = &ManualNavigation::handle-input;
        $computer.output-hook = &ManualNavigation::handle-output;

        $computer.run;
    } else {
        say "Automation not implemented yet";
        exit;
    }
}

