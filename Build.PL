use 5.012;
use Module::Build;

my $build = Module::Build->new(
    module_name       => 'RedisFailover',
    dist_abstract     => 'Failover script for nutcracker and redis sentinel',
    dist_author       => 'Robert Abraham <roa@adeven.com>',
    dist_version_from => 'lib/RedisFailover.pm',
    license           => 'mit',
    build_requires    => { 'Module::Build' => 0.38, },
    requires          => {
        'Redis' => 0,
        'YAML'  => 0,
        'Moo'   => 0,
    },
    script_files => ['bin/failover.pl'],
);
$build->create_build_script;

