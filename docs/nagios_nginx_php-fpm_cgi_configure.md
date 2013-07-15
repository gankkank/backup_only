NAGIOS with nginx php-fpm and cgi configure guide [ubuntu]
==========================================================

## compile install

```bash

#download php nginx fcgiwrap

apt-get install apt-get install -y libbz2-dev zlib1g-dev libpcre3-dev libssl-dev curl libmysqlclient-dev libmcrypt-dev curl libcurl4-openssl-dev unzip zip imagemagick bison flex libxml2-dev libssl-dev libpng12-dev libmcrypt-dev libpng3 libncurses5-dev
apt-get install -y libpcre3-dev libssl-dev libbz2-dev zlib1g-dev libcurl4-openssl-dev
apt-get install libfcgi-dev spawn-fcgi git-core build-essential libfcgi-dev autoconf libtool automake

#- php with php-fpm
./configure --prefix=/opt/php --enable-fpm --with-gd --with-zlib --with-curl --with-iconv --with-openssl --with-mysql --with-pdo-mysql
make
make install

#- nginx
./configure --prefix=/opt/nginx --user=apache --group=apache -with-http_ssl_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --with-http_stub_status_module
make
make install

#- cgi
./configure --prefix=/opt/cgi
autoreconf -i
make
make install
ln -s /opt/cgi/sbin/fcgiwrap /usr/sbin/fcgiwrap

```

## configure

```bash

#- nginx init script

#cat /etc/init/nginx.conf
# nginx
description "nginx daemon"
start on runlevel [2345]
stop on runlevel [!2345]
env DAEMON=/opt/nginx/sbin/nginx
expect fork
respawn
respawn limit 10 5
pre-start script
        $DAEMON -t -c /opt/nginx/nginx.conf
        if [ $? -ne 0 ]
          then exit $?
        fi
end script
exec $DAEMON -c /opt/nginx/nginx.conf

#- nginx conf file

#vi /opt/nginx/nginx.conf
worker_processes 1;
events {
    worker_connections  1024;
}
http {
    include       conf/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    #virtual
    include conf.d/local.conf;
}

#- php-fpm conf file

#cat /opt/php/etc/php-fpm.conf
[global]
error_log = /var/log/php-fpm_error.log
log_level = error
emergency_restart_threshold = 10
emergency_restart_interval = 1m
process_control_timeout = 10s
daemonize = yes
[local]
listen = 127.0.0.1:9000
;listen.allowed_clients = 127.0.0.1
user = apache
group = apache
request_terminate_timeout = 120s
request_slowlog_timeout = 5s
slowlog = /var/log/php-fpm_local-pool_slowlog.log
pm = dynamic
pm.max_children = 15
;pm.start_servers = min_spare_servers + (max_spare_servers - min_spare_servers) / 2
pm.min_spare_servers = 5
pm.max_spare_servers = 25
pm.max_requests = 1000
pm.status_path = /status
rlimit_files = 131072
rlimit_core = 0
catch_workers_output = yes
;listen.backlog = -1
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin:/opt/php/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
```




