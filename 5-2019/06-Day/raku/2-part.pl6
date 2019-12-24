#!/usr/bin/env perl6
use v6;

use lib '../../common';
use AOC;

my @orbits = @AOC-INPUT-LINES;

my %this-orbits-that;

for @orbits -> $orbit {
    my ($center, $satellite) = $orbit.split(')');
    %this-orbits-that{$satellite} = $center;
}

my $origin = %this-orbits-that<YOU>;
my $dest = %this-orbits-that<SAN>;

# Generate a route from origin to COM.
my @origin-route;
@origin-route.unshift($origin);
my $target = %this-orbits-that{$origin};
while $target ne 'COM' {
    @origin-route.unshift($target);
    $target = %this-orbits-that{$target};
}

# Generate a route from destination to COM.
my @dest-route;
@dest-route.unshift($dest);
$target = %this-orbits-that{$dest};
while $target ne 'COM' {
    @dest-route.unshift($target);
    $target = %this-orbits-that{$target};
}

# Find the last point of commonality.
my $common-point;
for @origin-route Z @dest-route -> ($a, $b) {
    last if $a ne $b;
    $common-point = $a;
}

# For each route, count the number of hops to get to and from the point of
# commonality.
my $index;
my ($origin-hops, $dest-hops);
$index = @origin-route.first($common-point, :k);
$origin-hops = @origin-route.elems - ($index + 1);
$index = @dest-route.first($common-point, :k);
$dest-hops = @dest-route.elems - ($index + 1);

my $total-hops = $origin-hops + $dest-hops;
say "Minimum number of orbital transfers: $total-hops";
