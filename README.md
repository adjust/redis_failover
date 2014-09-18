redis failover
==============

redis failover scripts

## Scope

This lib is supposed to be the glue between [Redis Sentinel](http://redis.io/topics/sentinel) and [Nutcracker/Twemproxy](https://github.com/twitter/twemproxy).

## Build

```
$ perl Build.PL
$ ./Build installdeps
$ ./Build test
$ ./Build install
```

## Usage

Install the lib on the same server as Nutcracker.

```
usage:
failover.pl --out <nutcracker.yml> --help

    --sentinel  | -s define sentinel server
                     default: 'localhost:26379'

    --command        define the command to restart nutcracker
                     default: 'sudo /etc/init.d/nutcracker restart'

    --out       | -o output to specified file
                     default: '/etc/nutcracker/nutcracker.yml'

    --pretend   | -p write config, but don't issue restart
                     print nutcracker start command
                     default: false

    --check     | -c quick check if redis can rewrite nutcracker config
                     default: false

    --help      | -h display this help and exit
```

After successful installation add it to your sentinel config:

```
sentinel monitor my_master redis.example.com 6379 1
sentinel down-after-milliseconds my_master 3000
sentinel parallel-syncs my_master 1
sentinel failover-timeout my_master 180000
sentinel client-reconfig-script my_master /usr/bin/failover.pl
```

If a failover get triggered, sentinel will rewrite the nutcracker config.
