package RedisFailover;

use strict;
use warnings;
use 5.012;

use Moo;
use Redis;
use autodie;

use RedisFailover::Template;

our $VERSION = '0.02';

has out      => ( is => 'ro', required => 1 );
has sentinel => ( is => 'ro', required => 1 );
has pretend  => ( is => 'ro' );
has listen_addr => ( is => 'ro' );

sub BUILD {
    my $self = shift;
}

sub run {
    my $self   = shift;
    my $server = $self->_get_master;
    $self->_write_config($server);
}

sub _get_master {
    my $self    = shift;
    my $r       = Redis->new( server => $self->{sentinel} );
    my $masters = $r->sentinel("masters");
    return $self->_sort($masters);
}

sub _write_config {
    my $self   = shift;
    my $server = shift;
    my $t      = RedisFailover::Template->new(
        servers     => $server,
        file        => $self->{out},
        listen_addr => $self->{listen_addr},
    );
    $t->write;
}

sub _sort {
    my $self    = shift;
    my $masters = shift;
    my $server  = [];
    @$masters = sort _redis_sort @$masters;
    for my $master (@$masters) {
        push @$server, "@$master[3]:@$master[5]:1 @$master[1]";
    }
    return $server;
}

sub _redis_sort {
    my ( $aa, $ab ) = split( "_", $a->[1] );
    my ( $ba, $bb ) = split( "_", $b->[1] );
    $ab <=> $bb;
}

1;
