require 'json'
data = [
  {
  service: "nginx",
  config: %q[pkgs="libpcre3-dev libssl-dev libbz2-dev zlib1g-dev libcurl4-openssl-dev"
usergrp="www-data"
option="--user=${usergrp} --groups=${usergrp} --with-http_ssl_module --with-http_stub_status_module"
  ]},
  {
  service: "httpd",
  config: %q[pkgs="libpcre3-dev"
options="--with-mpm=prefork --enable-so --enable-ssl"
  ]},
  {
  service: "lighttpd",
  config: %q[pkgs="libcurl4-openssl-dev"
options="--with-openssl-libs=/usr/lib"
  ]},
  {
  service: "php",
  config: %q[pkgs="libbz2-dev zlib1g-dev libpcre3-dev libssl-dev curl libmysqlclient-dev libmcrypt-dev curl libcurl4-openssl-dev unzip zip imagemagick bison flex libxml2-dev libssl-dev libpng12-dev libmcrypt-dev libpng3 libncurses5-dev"
options="--enable-fpm --with-gd --with-zlib --with-curl --with-iconv --with-openssl --with-mysql --with-pdo-mysql"
  ]},
  {
  service: "nodejs",
  config: %q[pkgs="libssl-dev apache2-utils"
options=""
  ]},
  {
  service: "redis"
  }
]
puts JSON.parse(data.to_json)
