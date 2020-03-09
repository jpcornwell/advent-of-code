#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

enum Direction (North => 1, South => 2, West =>3, East => 4);
enum Tile (Wall => '#', Goal => 'O', Explored => '.', Unknown => ' ');
enum StatusCode <WallHit NoHit GoalHit>;

class Node {
    has $.tile is rw = Unknown;
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
    has $!top-boundary = 1;
    has $!left-boundary = -1;
    has $!right-boundary = 1;
    has $!bottom-boundary = -1;

    method update-point($x, $y, $tile) {
        $!grid.get-point($x, $y).tile = $tile;

        # Update any boundaries
        $!top-boundary++ if $y > $!top-boundary;
        $!bottom-boundary-- if $y < $!bottom-boundary;
        $!left-boundary-- if $x < $!left-boundary;
        $!right-boundary++ if $x > $!right-boundary;
    }

    method get-point($x, $y) {
        my $tile = $!grid.get-point($x, $y).tile;
        return $tile;
    }

    method print($marker-x, $marker-y, $marker) {
        my $width = ($!left-boundary ... $!right-boundary).elems;
        say '-' x $width + 4;
        for $!top-boundary ... $!bottom-boundary -> $y {
        print '| ';
            for $!left-boundary ... $!right-boundary -> $x {
                if ($x == $marker-x && $y == $marker-y) {
                    print $marker;
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
$map.update-point(0, 0, Explored);

module ManualNavigation {
    my $x = 0;
    my $y = 0;
    my $last-input;

    our sub handle-input {
        my $input = '';
        until $input eq any(<n w e s>) {
            $input = prompt('Direction: ');
            exit if $input eq 'exit';
        }
        given $input {
            when 'n' { $last-input = North; return North; }
            when 'w' { $last-input = West; return West; }
            when 'e' { $last-input = East; return East; }
            when 's' { $last-input = South; return South; }
        }
    }

    our sub handle-output($out) {
        if ($out == WallHit) {
            given $last-input {
                when North { $map.update-point($x, $y + 1, Wall); }
                when South { $map.update-point($x, $y - 1, Wall); }
                when West  { $map.update-point($x - 1, $y, Wall); }
                when East  { $map.update-point($x + 1, $y, Wall); }
            }
        }

        if ($out == NoHit) {
            move-droid($last-input);
            $map.update-point($x, $y, Explored);
        }

        if ($out == GoalHit) {
            move-droid($last-input);
            $map.update-point($x, $y, Goal);
            say "YOU FOUND THE GOAL!";
        }

        $map.print($x, $y, 'D');
    }

    my sub move-droid($direction) {
        given $direction {
            when North { $y++; }
            when South { $y--; }
            when West  { $x--; }
            when East  { $x++; }
        }
    }
}

module FloodFill {
    my $x = 0;
    my $y = 0;
    my $last-input;
    my $last-output = -1;

    sub flood-fill($direction) {
        lazy gather {
            if $last-output != WallHit {
                if $map.get-point($x, $y + 1) eq Unknown {
                    take North;
                    take $_ for flood-fill(North);
                }

                if $map.get-point($x + 1, $y) eq Unknown {
                    take East;
                    take $_ for flood-fill(East);
                }

                if $map.get-point($x, $y - 1) eq Unknown {
                    take South;
                    take $_ for flood-fill(South);
                }

                if $map.get-point($x - 1, $y) eq Unknown {
                    take West;
                    take $_ for flood-fill(West);
                }

                # Undo step
                given $direction {
                    when North { take South; }
                    when West  { take East;  }
                    when South { take North; }
                    when East  { take West;  }
                }
            }
        }
    }

    my $iterator = flood-fill(North).iterator;

    our sub handle-input {
        #exit if prompt("Continue: ") eq 'exit';
        my $foo := $iterator.pull-one;
        if $foo =:= IterationEnd {
            say "THE END!";
            $map.print($x, $y, 'D');
            exit;
        }
        my $direction = $foo;
        $last-input = $direction;
        return $last-input;
    }

    our sub handle-output($out) {
        state $count = 0;
        $count++;

        if $count %% 100 {
            say "Count at $count";
            $map.print($x, $y, 'X');
        }

        if ($out == WallHit) {
            given $last-input {
                when North { $map.update-point($x, $y + 1, Wall); }
                when South { $map.update-point($x, $y - 1, Wall); }
                when West  { $map.update-point($x - 1, $y, Wall); }
                when East  { $map.update-point($x + 1, $y, Wall); }
            }
        }

        if ($out == NoHit) {
            move-droid($last-input);
            $map.update-point($x, $y, Explored);
        }

        if ($out == GoalHit) {
            move-droid($last-input);
            $map.update-point($x, $y, Goal);
        }

        $last-output = $out;

        #$map.print($x, $y, 'D');
    }

    my sub move-droid($direction) {
        given $direction {
            when North { $y++; }
            when South { $y--; }
            when West  { $x--; }
            when East  { $x++; }
        }
    }
}

sub MAIN(Bool :i(:$interactive)) {
    my @program = $AOC-INPUT-WHOLE.split(',');

    my $computer = Computer.new;
    $computer.load-program: @program;

    if ($interactive) {
        say "Type 'exit' to quit program.";
        say "Type 'n', 'e', 's', or 'w' to move.";
        $computer.input-hook = &ManualNavigation::handle-input;
        $computer.output-hook = &ManualNavigation::handle-output;

        $computer.run;
    } else {
        $computer.input-hook = &FloodFill::handle-input;
        $computer.output-hook = &FloodFill::handle-output;

        $computer.run;
    }
}

