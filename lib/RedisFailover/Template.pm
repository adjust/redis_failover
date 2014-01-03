package RedisFailover::Template;

use strict;
use warnings;
use 5.012;

use Moo;
use YAML qw( DumpFile );

has cluster_name     => ( is => 'rw' );
has listen_addr      => ( is => 'rw' );
has hash_function    => ( is => 'rw' );
has key_distribution => ( is => 'rw' );
has preconnect       => ( is => 'rw' );
has file             => ( is => 'rw', required => 1 );
has servers          => ( is => 'rw', required => 1 );

sub BUILD {
    my $self = shift;
    $self->cluster_name('redis_cluster') unless $self->cluster_name;
    $self->listen_addr('0.0.0.0:6379')   unless $self->listen_addr;
    $self->hash_function('fnv1a_64')     unless $self->hash_function;
    $self->key_distribution('ketama')    unless $self->key_distribution;
    $self->preconnect('true')            unless $self->preconnect;
}

sub write {
    my $self = shift;
    my $data = {
        $self->{cluster_name} => {
            listen           => $self->{listen_addr},
            hash             => $self->{hash_function},
            distribution     => $self->{key_distribution},
            auto_eject_hosts => 'false',
            redis            => 'true',
            preconnect       => $self->{preconnect},
            servers          => $self->{servers},
          }
    };
    $YAML::UseHeader = 0;
    DumpFile( $self->{file}, $data );
}

1;
