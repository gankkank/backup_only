configs = [
  {
  name: "nginx",
  config: """pkgs="libpcre3-dev libssl-dev libbz2-dev zlib1g-dev libcurl4-openssl-dev"
usergrp="www-data"
option="--user=${usergrp} --groups=${usergrp} --with-http_ssl_module --with-http_stub_status_module"
  """
  }
  {
  name: "httpd",
  config: """pkgs="libpcre3-dev"
options="--with-mpm=prefork --enable-so --enable-ssl"
  """
  }
  {
  name: "lighttpd",
  config: """pkgs="libcurl4-openssl-dev"
options="--with-openssl-libs=/usr/lib"
  """
  }
  {
  name: "php",
  config: """pkgs="libbz2-dev zlib1g-dev libpcre3-dev libssl-dev curl libmysqlclient-dev libmcrypt-dev curl libcurl4-openssl-dev unzip zip imagemagick bison flex libxml2-dev libssl-dev libpng12-dev libmcrypt-dev libpng3 libncurses5-dev"
options="--enable-fpm --with-gd --with-zlib --with-curl --with-iconv --with-openssl --with-mysql --with-pdo-mysql"
  """
  }
  {
  name: "nodejs",
  config: """pkgs="libssl-dev apache2-utils"
options=""
  """
  }
  {
  name: "redis"
  config: """pkgs="" """
  }
]

exec = require("child_process").exec
cookie = "/root/.gk/cookie.cccccccc"
curl="curl -b #{cookie}"
cPost="#{curl} -X POST -H 'Content-Type: application/json'"
tmpl="https://api-gank.rhcloud.com/gkm/template"
exec "#{curl} #{tmpl}", (err, stdout, stderr) ->
  console.log stdout
#console.log configs
postData = ->
  url="#{tmpl}/local-dev-ubu-12/new"
  query={ configs: configs }
  console.log JSON.stringify(query)
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout

postTmpl = ->
  url="#{tmpl}/new"
  query={ name: "local-dev-ubu-12" }
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout
#postData()
#postTmpl()
