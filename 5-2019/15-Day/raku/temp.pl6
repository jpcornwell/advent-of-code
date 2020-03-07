#!/usr/bin/env perl6
use v6;

module Foo {
    my $count = 0;

    our sub incr {
        $count++;
    }

    our sub display {
        say $count;
    }
}

#import Foo;

my $incr = Foo::incr;
say $incr.WHAT;
say $incr.perl;
#Foo::display();

