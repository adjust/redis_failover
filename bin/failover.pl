#!/usr/bin/perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use RedisFailover;
use File::Basename;

our $PROGNAME = basename($0);

my $out = '/etc/nutcracker/nutcracker.yml';

GetOptions(
    "out|o=s" => \$out
);

while (1) {
    my $other_failovers = `pgrep $PROGNAME`;
    last if $other_failovers eq "";
}

my $failover = RedisFailover->new( out => $out );
$failover->run;
