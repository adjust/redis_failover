use Test::More;

BEGIN {
    use_ok( 'RedisFailover' ) || print "Bail out!";
    use_ok( 'RedisFailover::Template' ) || print "Bail out!";
}

done_testing;
