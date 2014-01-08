#!/usr/bin/perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use RedisFailover;
use File::Basename;

our $PROGNAME = basename($0);

my $out = '/etc/nutcracker/nutcracker.yml';
my $pid = '/tmp/redis_failover';

GetOptions(
    "out|o=s" => \$out
);

while ( -f $pid ) { }

open my $fh, '>', $pid;
close($fh);
eval {
    my $failover = RedisFailover->new( out => $out );
    $failover->run;
};
unlink $pid;
