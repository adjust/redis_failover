#!/usr/bin/perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use RedisFailover;

my $out = '/etc/nutcracker/nutcracker.yml';

GetOptions(
    "out|o=s" => \$out
);

my $failover = RedisFailover->new( out => $out );
$failover->run;
