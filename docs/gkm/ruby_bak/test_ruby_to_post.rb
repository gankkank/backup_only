#`coffee -p 1.coffee`
require 'json'

=begin
data={ configs: [
{
      name: "httpd",
      config: "pkgs=\"apache2\""
}, {
      name: "mongodb",
      config: "pkgs=\"mongodb-10gen\""
}, {
      name: "mysql",
      config: "pkgs=\"mysql-server\""
}
]
}
puts JSON.pretty_generate(data)

url="https://api-gank.rhcloud.com/ok"
tmpl_new="https://api-gank.rhcloud.com/gkm/template/new"
tmpl="https://api-gank.rhcloud.com/gkm/template"
cookie="/root/.gk/cookie.cccccccc"
curl="curl -b #{cookie}"
cPost="#{curl} -X POST -H 'Content-Type: application/json'"
puts cookie
puts `#{curl} #{url} 2> /dev/null`

#query={ name: "apt-get" }
#query="name=lcal-dev"
#puts query.to_json
#
puts data.to_json

#puts `#{cPost} -d \'#{query.to_json}\' #{tmpl}`
#
puts `#{cPost} -d \'#{data.to_json}\' "#{tmpl}/apt-get/new" &> /dev/null`
=end

data={configs: [
  { name: "nginx", 
    config: %q[
pkgs="libpcre3-dev libssl-dev libbz2-dev zlib1g-dev libcurl4-openssl-dev"
usergrp="www-data"
option="--user=${usergrp} --groups=${usergrp} --with-http_ssl_module --with-http_stub_status_module"
] },
  {}

	]}
puts data.to_json

test={ name: %q[ this is ok? 
by now"." ] }
puts test.to_json
