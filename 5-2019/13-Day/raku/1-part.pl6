#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

class Node {
    has $.tile is rw = 0;
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

class Arcade-Cabinet {
    has $.grid = Grid.new;
    has $!computer = Computer.new;
    has $!x;
    has $!y;
    has $!tile;

    method act($command) {
        state $phase = 'get-x';

        given $phase {
            when 'get-x' { 
                $!x = $command;
                $phase = 'get-y';
            }
            when 'get-y' {
                $!y = $command;
                $phase = 'draw-tile';
            }
            when 'draw-tile' {
                $!grid.get-point($!x, $!y).tile = $command;

                $phase = 'get-x';
            }
        }
    }

    method init(@program) {
        # Can't pass methods using "&act" so use MOP
        $!computer.output-hook = self.^lookup('act').assuming(self);
        $!computer.reset;
        $!computer.load-program(@program);
    }

    method run {
        $!computer.run;
    }
}

my @program = $AOC-INPUT-WHOLE.split(',');

my $arcade-cabinet = Arcade-Cabinet.new;
$arcade-cabinet.init(@program);

say "Play arcade game...";
$arcade-cabinet.run;
say "Game finished";

say "Block count: {$arcade-cabinet.grid.contents.values>>.tile.grep('2').elems}";

