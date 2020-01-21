#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

use lib '.';
use IntComputer;

class Direction {
    has $.value = 'up';

    method turn-left {
        given $!value {
            when 'up'    { $!value = 'left'  }
            when 'right' { $!value = 'up'    }
            when 'down'  { $!value = 'right' }
            when 'left'  { $!value = 'down'  }
        }
    }

    method turn-right {
        given $!value {
            when 'up'    { $!value = 'right' }
            when 'right' { $!value = 'down'  }
            when 'down'  { $!value = 'left'  }
            when 'left'  { $!value = 'up'    }
        }
    }
}

class Node {
    has $.color is rw = 0;
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

class Paint-Bot {
    has $.grid = Grid.new;
    has $!computer = Computer.new;
    has $!direction = Direction.new;
    has $!x = 0;
    has $!y = 0;

    method read-sensor {
        return $!grid.get-point($!x, $!y).color;
    }

    method act($command) {
        state $phase = 'paint';

        given $phase {
            when 'paint' { 
                $!grid.get-point($!x, $!y).color = $command;
                $phase = 'move';
            }
            when 'move' { 
                if $command == 0 {
                    $!direction.turn-left;
                }
                if $command == 1 {
                    $!direction.turn-right;
                }

                # Move
                given $!direction.value {
                    when 'up'    { $!y++ }
                    when 'left'  { $!x-- }
                    when 'right' { $!x++ }
                    when 'down'  { $!y-- }
                }

                $phase = 'paint';
            }
        }
    }

    method init(@program) {
        # Can't pass methods using "&read-sensor" so use MOP
        $!computer.input-hook = self.^lookup('read-sensor').assuming(self);
        $!computer.output-hook = self.^lookup('act').assuming(self);
        $!computer.reset;
        $!computer.load-program(@program);
        $!grid.get-point(0, 0).color = 1;
    }

    method run {
        $!computer.run;
    }
}

my @program = $AOC-INPUT-WHOLE.split(',');

my $paint-bot = Paint-Bot.new;
$paint-bot.init(@program);

say "Run paint bot...";
$paint-bot.run;
say "Paint bot finished";

my $display = '';
for 0..50 -> $x {
    my $line = '';
    for -10..50 -> $y {
        if $paint-bot.grid.get-point($x, $y).color == 1 {
            $line ~= '#';
        } else {
            $line ~= '.';
        }
    }
    $display ~= $line ~ "\n";
}

say $display;
