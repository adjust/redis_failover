#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use 5.018;

use Linux::Inotify2;
use Getopt::Long;
use File::Basename;

our $PROGNAME = basename($0);

my $file;

GetOptions(
    'f|file=s' => \$file,
);

unless ( defined($file) ) {
    say "usage: $PROGNAME --file <file_to_watch>";
    exit(1);
}

my $inotify = new Linux::Inotify2;

while (1) {
    $inotify->watch( $file, IN_MODIFY, sub {
            my $e = shift;
            ## TODO: alarm somehow
            mkdir '/run/redis';
            system('rc-service nutcracker restart');
            system('rc-service nutcracker_socket restart');
            system('rc-service adjust_server restart');
            system('rc-service adjust_server2 restart');
            $e->w->cancel;
        }
    );

    $inotify->poll;
}
