unit module IntComputer;

class Computer is export {
    has @!input-buffer;
    has @!output-buffer;

    # If set to true then inputs and outputs are fetched and printed to the
    # command line.
    # If set to false then inputs and outputs are fetched and printed to their
    # respective buffers.
    has $.interactive = False;

    has $.is-halted = False;

    has $!ip = 0;
    has $!rb = 0; # Relative base
    has @!memory is default(0);

    method add-inputs(*@inputs) {
        @!input-buffer.append(@inputs);
    }

    method remove-output() {
        @!output-buffer.shift;
    }

    method load-program(@program) {
        @!memory = @program;
    }

    method reset() {
        @!input-buffer = [];
        @!output-buffer = [];
        $!is-halted = False;
        $!ip = 0;
    }

    method run() {
        die 'Computer is halted! Needs to be reset.' if $!is-halted;

        my $running = True;
        while $running {
            my ($opcode, @param-modes) = @!memory[$!ip].Int.polymod(100, 10, 10);

            # This is only used for reading parameters
            my @param-values;

            # This is only used for writing to parameters
            my @target-addresses;

            for @param-modes.kv -> $id, $mode {
                given $mode {
                    # Positional
                    when 0 { 
                        @param-values[$id] = @!memory[@!memory[$!ip + $id + 1] max 0];
                        @target-addresses[$id] = @!memory[$!ip + $id + 1];
                    }
                    # Immediate
                    when 1 { 
                        @param-values[$id] = @!memory[$!ip + $id + 1];
                        @target-addresses[$id] = -1;
                    }
                    # Relative
                    when 2 { 
                        @param-values[$id] = @!memory[$!rb + @!memory[$!ip + $id + 1] max 0];
                        @target-addresses[$id] = $!rb + @!memory[$!ip + $id + 1];
                    }
                }
            }
            given $opcode {
                # Addition
                when 1 { 
                    @!memory[@target-addresses[2]] = @param-values[0] + @param-values[1];
                    $!ip += 4;
                }
                # Multiplication
                when 2 { 
                    @!memory[@target-addresses[2]] = @param-values[0] * @param-values[1];
                    $!ip += 4;
                }
                # Input
                when 3 { 
                    my $in;
                    if $.interactive {
                        $in = prompt('Input> ');
                    } else {
                        if @!input-buffer.elems == 0 {
                            # Quit running to allow the user to add input
                            return;
                        }
                        $in = @!input-buffer.shift;
                    }
                    @!memory[@target-addresses[0]] = $in;
                    $!ip += 2;
                }
                # Output
                when 4 { 
                    my $out = @param-values[0];
                    if $.interactive {
                        say $out;
                    } else {
                        @!output-buffer.push: $out;
                    }
                    $!ip += 2;
                }
                # Jump if true
                when 5 {
                    if @param-values[0] != 0 {
                        $!ip = @param-values[1];
                    } else {
                        $!ip += 3;
                    }
                }
                # Jump if false
                when 6 {
                    if @param-values[0] == 0 {
                        $!ip = @param-values[1];
                    } else {
                        $!ip += 3;
                    }
                }
                # Less than
                when 7 {
                    if @param-values[0] < @param-values[1] {
                        @!memory[@target-addresses[2]] = 1;
                    } else {
                        @!memory[@target-addresses[2]] = 0;
                    }
                    $!ip += 4;
                }
                # Equals
                when 8 {
                    if @param-values[0] == @param-values[1] {
                        @!memory[@target-addresses[2]] = 1;
                    } else {
                        @!memory[@target-addresses[2]] = 0;
                    }
                    $!ip += 4;
                }
                # Adjust relative base
                when 9 {
                    $!rb += @param-values[0];
                    $!ip += 2;
                }
                # Halt
                when 99 { 
                    $running = False;
                    $!is-halted = True;
                    say "HALT" if $!interactive;
                }
                default { die 'Unrecognized opcode' }
            }
        }
    }
}

