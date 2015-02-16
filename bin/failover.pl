#!/usr/bin/perl

use strict;
use warnings;
use 5.012;

use Getopt::Long;
use RedisFailover;
use File::Basename;

our $PROGNAME = basename($0);

my $sentinel = 'localhost:26379';
my $out      = '/etc/nutcracker/nutcracker.yml';
my $pid      = '/tmp/redis_failover';
my $cmd = '/bin/bash -l -c "env >> /tmp/failover_env ;sudo /etc/init.d/nutcracker restart &> /tmp/failover_nutcracker"';
my $pretend;
my $check;
my $help;

GetOptions(
    "sentinel|s=s" => \$sentinel,
    "command=s"    => \$cmd,
    "out|o=s"      => \$out,
    "pretend|p"    => \$pretend,
    "check|c"      => \$check,
    "help|h"       => \$help,
);

if ($check) {
    {
        my $uid  = ( stat $out )[4];
        my $user = ( getpwuid $uid )[0];
        if ( $user ne 'redis' ) {
            say 'it seems like the nutcracker config is not writable by redis user';
        }
    }
    {
        my $uid  = ( stat dirname($out) )[4];
        my $user = ( getpwuid $uid )[0];
        if ( $user ne 'redis' ) {
            say 'it seems like the nutcracker config directory is not writable by redis user';
        }
    }

    exit(0);
}

if ($help) {
    say "usage:";
    say "$PROGNAME --out <nutcracker.yml> --help";
    say "\t--sentinel  | -s define sentinel server";
    say "\t--out       | -o output to specified file";
    say "\t--pretend   | -p write config, but don't issue restart";
    say "\t--check     | -c quick check if redis can rewrite nutcracker config";
    say "\t--help      | -h display this help";
    exit(0);
}

#TODO: this is ugly :X
while ( -f $pid ) { }

open my $fh, '>', $pid;
close($fh);
eval {
    my $failover = RedisFailover->new(
        out      => $out,
        sentinel => $sentinel,
        cmd      => $cmd,
        pretend  => $pretend,
    );
    $failover->run;
};
unlink $pid;
