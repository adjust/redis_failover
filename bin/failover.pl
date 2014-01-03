#!/usr/bin/perl

use strict;
use warnings;
use 5.012;
use lib 'lib';
use RedisFailover;

my $failover = RedisFailover->new( out => '/tmp/test.yml' );
$failover->run;
