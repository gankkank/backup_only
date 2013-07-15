HAproxy Benchmark info
======================

## Info About Configuration

both vm with 1 core

* haproxy 127.0.0.1:3308

```bash

cat /etc/sysctl.conf
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 60
net.ipv4.ip_local_port_range = 10240 65000
fs.file-max = 102400

cat /etc/security/limits.conf
root	hard	nofile	102400
root	soft	nofile	10240
haproxy	soft	nofile	10240
haproxy	hard	nofile	102400


cat /opt/haproxy/mysqld.cfg
#- part of the conf
maxconn 80

timeout connect 1m
timeout client 1m
timeout server 1m

option tcpka
option mysql-check user haproxy
server mysql1 192.168.1.52:3306 fall 10 inter 20s check


mysqlslap --create-schema=test --user=root --password=xxxx -h 127.0.0.1 -P 3308 \
--query="select * from a;" \
--concurrency=300 --iterations=5 \
--number-of-queries=30000


```
* mysql 192.168.1.246:3306

```bash
cat /etc/security/limits.conf
root    hard    nofile  102400
root    soft    nofile  10240
mysql		hard	nofile		102400
mysql		soft	nofile		10240

cat /etc/mysql/my.cnf
max_connections        = 1000
```

## Tune maxconn of haproxy

- [x] tested on weak machine

**tips may help: haproxy can help increase performance of mysql by limit the max concurrent sessions it passed.**

**note** the haproxy high cpu rate

**note** that mysql server load > 1

**note** that benchmark concurrent level is 300

* maxconn=80
```
Benchmark
	Average number of seconds to run all queries: 5.559 seconds
	Minimum number of seconds to run all queries: 5.450 seconds
	Maximum number of seconds to run all queries: 5.735 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
```

* maxconn=90
```
Benchmark
	Average number of seconds to run all queries: 5.663 seconds
	Minimum number of seconds to run all queries: 5.563 seconds
	Maximum number of seconds to run all queries: 5.792 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
```

* maxconn=100,120,140,180
```
Benchmark
	Average number of seconds to run all queries: 5.872 seconds
	Minimum number of seconds to run all queries: 5.589 seconds
	Maximum number of seconds to run all queries: 6.564 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
Benchmark
	Average number of seconds to run all queries: 5.737 seconds
	Minimum number of seconds to run all queries: 5.564 seconds
	Maximum number of seconds to run all queries: 6.057 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
Benchmark
	Average number of seconds to run all queries: 6.103 seconds
	Minimum number of seconds to run all queries: 5.598 seconds
	Maximum number of seconds to run all queries: 7.573 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
Benchmark
	Average number of seconds to run all queries: 10.770 seconds
	Minimum number of seconds to run all queries: 5.647 seconds
	Maximum number of seconds to run all queries: 18.041 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
```

* maxconn=200
```
Benchmark
	Average number of seconds to run all queries: 5.877 seconds
	Minimum number of seconds to run all queries: 5.573 seconds
	Maximum number of seconds to run all queries: 6.395 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
Benchmark
	Average number of seconds to run all queries: 6.891 seconds
	Minimum number of seconds to run all queries: 5.702 seconds
	Maximum number of seconds to run all queries: 9.757 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
```

* maxconn=250
```
#cpu of haproxy and mysqld became unstable.
#note that haproxy connection timeout is set to 1m
Benchmark
	Average number of seconds to run all queries: 29.022 seconds
	Minimum number of seconds to run all queries: 6.019 seconds
	Maximum number of seconds to run all queries: 61.176 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
Benchmark
	Average number of seconds to run all queries: 18.614 seconds
	Minimum number of seconds to run all queries: 6.114 seconds
	Maximum number of seconds to run all queries: 60.168 seconds
	Number of clients running queries: 300
	Average number of queries per client: 100
```


#### test  mysql server without haproxy

**note** use mysqlslap to benchmark mysql server

**note** mysql: system load became extremely high; mysqlslap use =~ 30% cpu load on testing machine

--concurrency=210 --iterations=5 \

--number-of-queries=30000

* concurrency=220,240,260
```
Benchmark
	Average number of seconds to run all queries: 6.645 seconds
	Minimum number of seconds to run all queries: 6.568 seconds
	Maximum number of seconds to run all queries: 6.756 seconds
	Number of clients running queries: 220
	Average number of queries per client: 136
Benchmark
	Average number of seconds to run all queries: 6.758 seconds
	Minimum number of seconds to run all queries: 6.650 seconds
	Maximum number of seconds to run all queries: 6.852 seconds
	Number of clients running queries: 240
	Average number of queries per client: 125
Benchmark
	Average number of seconds to run all queries: 6.540 seconds
	Minimum number of seconds to run all queries: 6.418 seconds
	Maximum number of seconds to run all queries: 6.653 seconds
	Number of clients running queries: 260
	Average number of queries per client: 115
```

* failed on concurrency=280

