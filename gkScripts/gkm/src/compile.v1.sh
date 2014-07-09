#!/bin/bash - 
#===============================================================================
#
#          FILE: compile.v1.sh
# 
#         USAGE: ./compile.v1.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: gankkank (), gankkank@gmail.com
#  ORGANIZATION: GK
#       CREATED: 05/28/2013 05:44:06 PM HKT
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
debug=1
srcDir=/opt/srcv
prefixDir=/opt

checkVar() {
[ ! "x" == "x$1" ]
}

installPkgs() {
  #1. define var
  local prefix=${prefixDir}/${fullname}

  #2. local config from server
  eval $remote_configs
  if which apt-get &> /dev/null
  then
    checkVar $aptpkgs && apt-get -y install $aptpkgs || echo "not install"
  elif which yum &> /dev/null
  then
    checkVar $yumpkgs && yum -y install $yumpkgs || echo "not install"
  fi

  #3. compile
  cd ${srcDir}/${fullname}
  #./configure --prefix=${prefix} $config
  #make
  #make install
  #[ -f ${link} ] && rm -f ${link}
  #ln -s ${prefix} ${link}

}

installControl() {
local remote_configs='
aptpkgs="libpcre3-dev libssl-dev libbz2-dev zlib1g-dev libcurl4-openssl-dev"
usergrp="www-data"
option="--user=${usergrp} --groups=${usergrp} --with-http_ssl_module --with-http_stub_status_module"
'

#$1 service name
#$2 service version
case $1 in
nginx|httpd|lighttpd|php)
  local fullname=${1}-${2}
  local link=${prefixDir}/${1}
  installPkgs
;;
nodejs)
  local fullname=${1}-v${2}
  local link=${prefixDir}/${1}
  installPkgs
;;
nagios)
  echo 
;;
*)
  echo
;;
esac

#fcgiwrap, pnp4nagios,nrpe-server,nrpe-plugin, ruby
}

installControl "$1" "$2"
