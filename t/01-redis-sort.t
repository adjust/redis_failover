use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok 'RedisFailover';
}

my $failover = RedisFailover->new(out => '/tmp/tmp');

my $server1 = [ 'name', 'server_0', 'ip', '127.0.0.1', 'port', '6380' ];
my $server2 = [ 'name', 'server_1', 'ip', '127.0.0.1', 'port', '6381' ];
my $server3 = [ 'name', 'server_2', 'ip', '127.0.0.1', 'port', '6382' ];

my $servers1 = [ $server1, $server2, $server3 ];
my $servers2 = [ $server2, $server3, $server1 ];
my $servers3 = [ $server3, $server1, $server2 ];

my $result1 = $failover->_sort($servers1);
my $result2 = $failover->_sort($servers2);
my $result3 = $failover->_sort($servers3);

for (my $i = 0; $i < 3; $i++) {
    my $port = 6380+$i;
    is( @$result1[$i], "127.0.0.1:$port:1 server_$i", 'sort_test');
}

done_testing;
