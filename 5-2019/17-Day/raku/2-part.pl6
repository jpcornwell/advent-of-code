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
}

my $grid = Grid.new;

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

my @path;

# This finds the main path, which is the path the robot takes if it always
# goes straight when encountering an intersection. It is assumed that there
# is a valid solution using the main path.
sub find-main-path {
    my ($x, $y);
    my $steps = 0;
    my $direction = 'U'; # 'L', 'R', 'U', or 'D'
    
    # Check left and right, and make turn if possible. If not possible then
    # we have reached the end of the path. Return False if at end of path.
    # Return True if not at end of path.
    sub check-l-r {
        # Check left
        if $grid.get-point($x-1, $y).tile eq Scaffold {
            @path.push(Str($steps));

            @path.push('L') if $direction eq 'U';
            @path.push('R') if $direction eq 'D';

            $direction = 'L';
            $steps = 0;
            return True;
        }

        # Check right
        if $grid.get-point($x+1, $y).tile eq Scaffold {
            @path.push(Str($steps));

            @path.push('R') if $direction eq 'U';
            @path.push('L') if $direction eq 'D';

            $direction = 'R';
            $steps = 0;
            return True;
        }

        @path.push(Str($steps));
        return False;
    }

    # Same as check-l-r but checking up and down.
    sub check-u-d {
        # Check up
        if $grid.get-point($x, $y-1).tile eq Scaffold {
            @path.push(Str($steps));

            @path.push('R') if $direction eq 'L';
            @path.push('L') if $direction eq 'R';

            $direction = 'U';
            $steps = 0;
            return True;
        }

        # Check down
        if $grid.get-point($x, $y+1).tile eq Scaffold {
            @path.push(Str($steps));

            @path.push('L') if $direction eq 'L';
            @path.push('R') if $direction eq 'R';

            $direction = 'D';
            $steps = 0;
            return True;
        }

        @path.push(Str($steps));
        return False;
    }

    my $start = $grid.get-contents.grep(*.tile eq '^')[0];
    ($x, $y) = $start.x, $start.y;

    loop {
        if $direction eq 'U' {
            if $grid.get-point($x, $y-1).tile eq Scaffold {
                $steps++;
                $y--;
            } else {
                last if !check-l-r;
            }
        } elsif $direction eq 'D' {
            if $grid.get-point($x, $y+1).tile eq Scaffold {
                $steps++;
                $y++;
            } else {
                last if !check-l-r;
            }
        } elsif $direction eq 'L' {
            if $grid.get-point($x-1, $y).tile eq Scaffold {
                $steps++;
                $x--;
            } else {
                last if !check-u-d;
            }
        } elsif $direction eq 'R' {
            if $grid.get-point($x+1, $y).tile eq Scaffold {
                $steps++;
                $x++;
            } else {
                last if !check-u-d;
            }
        }
    }
}

my @MAIN;
my @A;
my @B;
my @C;

sub find-A {
    my $cur = 0;
    my @orig-MAIN = @MAIN;

    for 20...1 -> $n {
        next if $cur + $n > @path.elems;

        @A = @path[0..^$n];
        $cur = $n;
        @MAIN.push('A');
        my $found = find-B($cur);

        if $found {
            return True;
        } else {
            $cur = 0;
            @MAIN = @orig-MAIN;
        }
    }

    return False;
}

sub find-B($in) {
    my $cur = $in;
    my @orig-MAIN = @MAIN;

    # Consume any A patterns (assumes A isn't a subset of B, and later in
    # find-C we assume that A and B aren't subsets of C)
    loop {
        # Check A can fit
        last if $cur + @A.elems > @path.elems;
        
        # Check A matches
        last if @path[$cur..^($cur+@A.elems)] ne @A;

        # Consume A
        $cur += @A.elems;
        @MAIN.push('A');
    }

    my @temp-MAIN = @MAIN;
    for 20...1 -> $n {
        next if $cur + $n > @path.elems;

        @B = @path[$cur..^($cur+$n)];
        $cur += $n;
        @MAIN.push('B');
        my $found = find-C($cur);

        if $found {
            return True;
        } else {
            $cur -= $n;
            @MAIN = @temp-MAIN;
        }
    }

    @MAIN = @orig-MAIN;
    return False;
}

sub find-C($in) {
    my $cur = $in;
    my @orig-MAIN = @MAIN;

    # Consume any A or B patterns
    my $is-A-consumable = True;
    my $is-B-consumable = True;
    while ($is-A-consumable || $is-B-consumable) {
        $is-A-consumable++;
        $is-B-consumable++;

        $is-A-consumable-- if $cur + @A.elems > @path.elems;
        $is-B-consumable-- if $cur + @B.elems > @path.elems;

        if $is-A-consumable {
            $is-A-consumable-- if @path[$cur..^($cur+@A.elems)] ne @A;
        }
        if $is-B-consumable {
            $is-B-consumable-- if @path[$cur..^($cur+@B.elems)] ne @B;
        }
        
        if $is-A-consumable {
            $cur += @A.elems;
            @MAIN.push('A');
        } elsif $is-B-consumable {
            $cur += @B.elems;
            @MAIN.push('B');
        }
    }
    
    my @temp-MAIN = @MAIN;
    my $temp-cur = $cur;
    for 20...1 -> $n {
        next if $cur + $n > @path.elems;

        @C = @path[$cur..^($cur+$n)];
        $cur += $n;
        @MAIN.push('C');
        
        # Consume rest of path using A, B, and C
        my $is-A-consumable = True;
        my $is-B-consumable = True;
        my $is-C-consumable = True;
        while ($is-A-consumable || $is-B-consumable || $is-C-consumable) {
            $is-A-consumable++;
            $is-B-consumable++;
            $is-C-consumable++;

            $is-A-consumable-- if $cur + @A.elems > @path.elems;
            $is-B-consumable-- if $cur + @B.elems > @path.elems;
            $is-C-consumable-- if $cur + @C.elems > @path.elems;

            if $is-A-consumable {
                $is-A-consumable-- if @path[$cur..^($cur+@A.elems)] ne @A;
            }
            if $is-B-consumable {
                $is-B-consumable-- if @path[$cur..^($cur+@B.elems)] ne @B;
            }
            if $is-C-consumable {
                $is-C-consumable-- if @path[$cur..^($cur+@C.elems)] ne @C;
            }
        
            if $is-A-consumable {
                $cur += @A.elems;
                @MAIN.push('A');
            } elsif $is-B-consumable {
                $cur += @B.elems;
                @MAIN.push('B');
            } elsif $is-C-consumable {
                $cur += @C.elems;
                @MAIN.push('C');
            }
        }

        # Check if the path has been completely consumed
        if $cur == @path.elems {
            # One last check to make sure resulting inputs are 20 chars or less
            if @MAIN.join(',').chars > 20 {
                $cur = $temp-cur;
                @MAIN = @temp-MAIN;
                next;
            }
            if @A.join(',').chars > 20 {
                $cur = $temp-cur;
                @MAIN = @temp-MAIN;
                next;
            }
            if @B.join(',').chars > 20 {
                $cur = $temp-cur;
                @MAIN = @temp-MAIN;
                next;
            }
            if @C.join(',').chars > 20 {
                $cur = $temp-cur;
                @MAIN = @temp-MAIN;
                next;
            }

            return True;
        } else {
            $cur = $temp-cur;
            @MAIN = @temp-MAIN;
        }
    }

    @MAIN = @orig-MAIN;
    return False;
}

sub handle-input {
    state $iterator = (gather {
        my @main = @MAIN.join(',').comb>>.ord;
        take $_ for @main;
        take ord("\n");

        my @a = @A.join(',').comb>>.ord;
        take $_ for @a;
        take ord("\n");

        my @b = @B.join(',').comb>>.ord;
        take $_ for @b;
        take ord("\n");

        my @c = @C.join(',').comb>>.ord;
        take $_ for @c;
        take ord("\n");

        # Do not want continuous video feed
        take ord('n');
        take ord("\n");
    }).iterator;

    my $input = $iterator.pull-one;
    print chr($input);
    return $input;
}

sub handle-output($out) {
    if 0 < $out < 255 {
        print chr($out);
    } else {
        say $out;
    }
}

sub MAIN {
    my @program = $AOC-INPUT-WHOLE.split(',');

    my $computer = Computer.new;
    $computer.load-program: @program;

    # Look at camera feed and fill in map info
    $computer.output-hook = &fill-grid;
    $computer.run;

    find-main-path;
    # Remove leading zero from main path
    @path = @path[1..*];

    my $found = find-A;
    if !$found {
        say "Movement routines couldn't be calculated";
        exit;
    }

    # Activate robot and control it
    @program[0] = 2;
    $computer.reset;
    $computer.load-program: @program;
    $computer.input-hook = &handle-input;
    $computer.output-hook = &handle-output;
    $computer.run;
}
