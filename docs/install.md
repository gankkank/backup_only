USER GUIDE OF GK-SCRIPTS
==========================

## intro scripts: gk-init
#### configure PATH
* such as all data in: /opt/data/dropbox/
* add PATH and links in /opt

```bash
#/opt/data/dropbox/1.commands/gk-init
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/opt/commands
sed -ie "/^PATH.*$/ c\PATH=$PATH:/opt/commands" ~/.bashrc
boxPath=/opt/data/dropbox
ln -s ${boxPath}/1.commands /opt/commands
ln -s ${boxPath}/1.sample-configs /opt/sample-configs
[ -d /opt/bin ] || mkdir /opt/bin
#source ~/.bashrc
```

## intro scripts: gk-compile
* use all files in the source
* how-to:

  gk-compile install nginx 1.2.7
* rules apply to all:

```bash
  #- example:
  #- 1. one link to actived version of nginx
  ln -s /opt/nginx-1.2.7 /opt/nginx
  #- 2. all configuration file will use /opt/nginx
  #- 3. create link in /opt/bin for convenience [run: gk-config bin]
  ln -s /opt/nginx/sbin/nginx /opt/bin/nginx
```
* important functions:

```bash
DEBUG=0
cecho() {
echo -en '\E[47;31m'"\033[1m $1 \033[0m \n"; tput sgr0
}
finishSteps() {
for (( i = 0 ; $i < ${#steps[*]} ; i++ ))
do
  cecho "* ${steps[$i]}"
  if [ $DEBUG -eq 1 ]
  then
  ${steps[$i]}
  else
  ${steps[$i]} > /dev/null
  fi
done
}
```


## intro scripts: gk-config
* this script will use dir: **/opt/sample-configs**


####command details:

gk-config bin		#create symbolic from each service to /opt/bin/

gk-config stat	#show installed services and actived version

```
services          actived version                     installed version(s)          
--------          ---------------                     -------------------           
lighttpd          lighttpd-1.4.32                     1.00 1.01                     
nginx             nginx-1.2.6                                                       
node              node-0.8.16                                                       
nrpd              nrpe-2.13                           0.01                          
pnp4nagios        pnp4                                                              
redis             redis-2.6.7      
```
gk-config enable pnp	#copy configuration files to service direcotries

```bash
#- 1.copy template-pnp.cfg to /opt/nagios/etc/objects/
#cat template-pnp.cfg
define host {
   name       host-pnp
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=_HOST_' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=_HOST_
   register   0
}

define service {
   name       srv-pnp
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=$SERVICEDESC$
   register   0
}

#- 2.copy commands-pnp.cfg /opt/nagios/etc/objects/

#- 3.copy nagios-fin.cfg to /opt/nagios/etc/nagios.cfg
#cat /opt/nagios/etc/nagios.cfg
cfg_file=/opt/nagios/etc/objects/template-pnp.cfg
cfg_file=/opt/nagios/etc/objects/commands-pnp.cfg
cfg_file=/opt/nagios/etc/objects/hosts.cfg
cfg_file=/opt/nagios/etc/objects/services.cfg
cfg_file=/opt/nagios/etc/objects/group.cfg
```


## intro scripts: gk-nagios-conf
* how-to:

  gk-nagios-conf -f hosts.txt
* format of hosts.txt

```csv
format:
#host-group-simple,host-group-full-name
[id_of_group:1],[domain-name],[host-name],[ip_or_domain-name],[services]

sample:
#local,Local Hosts Group
2,localhost,local1,127.0.0.1,ssh,web
```
* services available:

```
default enabled:
	memory,swap,cpu,totalprocs,zombieprocs,disk

available to use:
	ssh,mysql,web,ftp,smtp,pop3,imap,svn,nodejs,web8080,smtp587

	raid_mega,raid_mpt,raid_mpt2,raid_hp
```

* default using pnp templates

```bash
define service{
        use     generic-service,srv-pnp
        host_name       $hostname
        service_description     $description
        check_command   $commands
}
define host{
        use     linux-server,host-pnp
        host_name $hostname
        alias   $aliasname
        address $ipaddress
}
```

* create host.cfg,service.cfg,group.cfg under /opt/nagios/etc/objects/ 

## use these to install a complete service:

####install nagios services:

```bash
#- 1. also download:
#-    nginx-1.2.6.tar.gz php-5.4.12.tar.gz fcgiwrap.tar.gz
#-    nrpe-2.13.tar.gz pnp4nagios-0.6.19.tar.gz nagios-plugins-1.4.16.tar.gz
wget nagios-3.4.4.tar.gz -O /opt/srcv/nagios-3.4.4.tar.gz

#- 2. extract files
cd /opt/srcv
tar zxvf nagios-3.4.4.tar.gz

#- 3. install 
gk-compile install nginx 1.2.6	#or: gk-compile install ngx 1.2.6
gk-compile install php 5.4.12
gk-compile install nagios 3.4.4	#or: gk-compile install nag 3.4.4
gk-compile install nap 1.4.16	#or: gk-compile install nagios-plugins 1.4.16
gk-compile install nrp 2.12
gk-compile install nrpd 2.12
gk-compile install pnp 0.6.19	#or: gk-compile install pnp4nagios 0.6.19
gk-compile install cgi 0		#or: gk-compile install fcgiwrap 0
#- web services:	nginx php cgi
#- nagios plugin:	nap nrp
#- nagios service:	nagios
#- nrpe-server service:	nrpd
```

#### config and enable services:

```bash
#- 4. write hosts monitoring file
#cat hosts.txt
#local,Local Hosts Group
1,localhost,local1,127.0.0.1,ssh,web

gk-nagios-conf -f hosts.txt

#- 5. enable services
gk-config bin
gk-config enable php-fpm
gk-config enable nginx
gk-config enable nrpd
gk-config enable pnp

#- 6. start services
service nrpd start
service nagios checkconfig
service nagios start
service php-fpm start
service cgi start
service nginx start
```

#### others:

```bash
#cgi will be linked to /usr/bin/ after install

gk-config enable php-fpm
#copy to /opt/php/etc/php-fpm.conf
#default use pool [local], listen 127.0.0.1:9009

gk-config enable nginx
#copy to /etc/init/nginx.conf, /opt/nginx/nginx.conf, /opt/nginx/conf.d/local.conf
#default init script use /opt/nginx/nginx.conf; localhost config in /opt/nginx/conf.d/local.conf

gk-config enable nrpd
#copy to /opt/nrpe-2.13/etc/nrpe.cfg

#----
#nagio-only nagios-pnp
#gk-config enable nagios
#create link to /opt/site/nagios
#copy to /opt/nginx/conf.d/local.conf, /opt/nagios/etc/nagios.cfg

gk-config enable pnp
#copy to /opt/nginx/conf.d/local.conf, /opt/nagios/etc/nagios.cfg
#	 /opt/nagios/etc/objects/template-pnp.cfg /opt/nagios/etc/objects/commands-pnp.cfg
#ln -s /opt/nagios/share /opt/site/nagios
#ln -s /opt/pnp4nagios/share /opt/site/pnp4nagios


```
