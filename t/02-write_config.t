use strict;
use warnings;

use Test::More;
use File::Temp qw( tempfile );

BEGIN {
    use_ok 'RedisFailover';
}
my( $fh, $filename ) = tempfile();

my $failover = RedisFailover->new( out => $filename );

my $expected = <<END;
redis_cluster:
  auto_eject_hosts: false
  distribution: ketama
  hash: fnv1a_64
  listen: 0.0.0.0:6379
  preconnect: true
  redis: true
  servers:
    - 127.0.0.1:6380:1 server_0
    - 127.0.0.1:6381:1 server_1
    - 127.0.0.1:6382:1 server_2
END

my $server1 = [ 'name', 'server_0', 'ip', '127.0.0.1', 'port', '6380' ];
my $server2 = [ 'name', 'server_1', 'ip', '127.0.0.1', 'port', '6381' ];
my $server3 = [ 'name', 'server_2', 'ip', '127.0.0.1', 'port', '6382' ];

my $servers = [ $server1, $server2, $server3 ];

$servers = $failover->_sort($servers);
$failover->_write_config($servers);

$/ = undef;
my $result = <$fh>;

is( $result, $expected, 'written config');

done_testing;
