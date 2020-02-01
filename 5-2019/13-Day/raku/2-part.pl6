#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

enum TileTypes ( empty_tile  => 0,
                 wall_tile   => 1,
                 block-tile  => 2,
                 paddle-tile => 3,
                 ball-tile   => 4 );
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
    has $.print-display is rw = False;
    has $.auto-input is rw = True;
    has $.grid = Grid.new;
    has $!computer = Computer.new;
    has $!height = 20;
    has $!width = 40;
    has $!x;
    has $!y;
    has $!tile;
    has $.segment;

    method !get-tile-x-pos($tile) {
        for ^$!height -> $y {
            for ^$!width -> $x {
                return $x if $!grid.get-point($x, $y).tile == $tile;
            }
        }
    }

    method !ball-x   { self!get-tile-x-pos(ball-tile) }
    method !paddle-x { self!get-tile-x-pos(paddle-tile) }

    method !print-display {
        say "\n\n\n\n\n\n\n\n\n\n\n";
        for ^$!height -> $y {
            for ^$!width -> $x {
                given $!grid.get-point($x, $y).tile {
                    when  empty_tile { print ' ' }
                    when   wall_tile { print 'W' }
                    when  block-tile { print 'X' }
                    when paddle-tile { print '_' }
                    when   ball-tile { print '0' }
                }
            }
            print "\n";
        }
    }

    method !calc-auto-input {
        return -1 if self!ball-x < self!paddle-x;
        return  1 if self!ball-x > self!paddle-x;
        return  0;
    }

    method get-input() {
        if $!print-display {
            self!print-display;
            sleep 0.1;
        }

        if $!auto-input {
            return self!calc-auto-input;
        }

        my $input = get-char;
        return -1 if $input eq 'a';
        return  1 if $input eq 'd';
        return  0;
    }

    method process-output($command) {
        state $phase = 'get-x';
        state $is-redirect-to-segment = False;

        given $phase {
            when 'get-x' { 
                $!x = $command;
                $is-redirect-to-segment = True if $!x == -1;
                $phase = 'get-y';
            }
            when 'get-y' {
                $!y = $command;
                $phase = 'draw-tile';
            }
            when 'draw-tile' {
                if $is-redirect-to-segment {
                    $!segment = $command;
                    $is-redirect-to-segment = False;
                } else {
                    $!grid.get-point($!x, $!y).tile = $command;
                }

                $phase = 'get-x';
            }
        }
    }

    method init(@program) {
        # Can't pass methods using "&act" so use MOP
        $!computer.input-hook = self.^lookup('get-input').assuming(self);
        $!computer.output-hook = self.^lookup('process-output').assuming(self);
        $!computer.reset;
        $!computer.load-program(@program);
    }

    method run {
        $!computer.run;
    }
}

# Copy pasted this sub from rosettacode.org
# May be overkill, have no idea, don't know much about working with terminals
sub get-char {
    ENTER shell "stty raw -echo min 1 time 1";
    LEAVE shell "stty sane";

    my $tty = open("/dev/tty");
    $tty.read(1).decode('latin1');
}

my @program = $AOC-INPUT-WHOLE.split(',');

# Modify program to think two quarters have been inserted
@program[0] = 2;

# Play it for real! (Kind of, pretty hacky but works in the terminal, will
# pause and wait for player input unfortunately)
# Use 'a' and 'd' to move
#my $arcade-cabinet = Arcade-Cabinet.new: :print-display, :!auto-input;

# Watch it play automatically
#my $arcade-cabinet = Arcade-Cabinet.new: :print-display;

# Auto play silently
my $arcade-cabinet = Arcade-Cabinet.new;

$arcade-cabinet.init(@program);

say "Play arcade game...";
$arcade-cabinet.run;
say "Game finished";

say "Score: $arcade-cabinet.segment()";

